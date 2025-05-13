// SPDX-License-Identifier: MIT
pragma solidity =0.8.26 ^0.8.0 ^0.8.1;

// lib/openzeppelin-contracts/contracts/utils/Address.sol

// OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)

/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     *
     * [IMPORTANT]
     * ====
     * You shouldn't rely on `isContract` to protect against flash loan attacks!
     *
     * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
     * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
     * constructor.
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize/address.code.length, which returns 0
        // for contracts in construction, since the code is only stored at the end
        // of the constructor execution.

        return account.code.length > 0;
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain `call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        (bool success, bytes memory returndata) = target.call{value: value}(data);
        return verifyCallResultFromTarget(target, success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        (bool success, bytes memory returndata) = target.staticcall(data);
        return verifyCallResultFromTarget(target, success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return verifyCallResultFromTarget(target, success, returndata, errorMessage);
    }

    /**
     * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
     * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
     *
     * _Available since v4.8._
     */
    function verifyCallResultFromTarget(
        address target,
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        if (success) {
            if (returndata.length == 0) {
                // only check isContract if the call was successful and the return data is empty
                // otherwise we already know that it was a contract
                require(isContract(target), "Address: call to non-contract");
            }
            return returndata;
        } else {
            _revert(returndata, errorMessage);
        }
    }

    /**
     * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
     * revert reason or using the provided one.
     *
     * _Available since v4.3._
     */
    function verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            _revert(returndata, errorMessage);
        }
    }

    function _revert(bytes memory returndata, string memory errorMessage) private pure {
        // Look for revert reason and bubble it up if present
        if (returndata.length > 0) {
            // The easiest way to bubble the revert reason is using memory via assembly
            /// @solidity memory-safe-assembly
            assembly {
                let returndata_size := mload(returndata)
                revert(add(32, returndata), returndata_size)
            }
        } else {
            revert(errorMessage);
        }
    }
}

// src/dependencies/BeraborrowBase.sol

/*
 * Base contract for DenManager, BorrowerOperations and StabilityPool. Contains global system constants and
 * common functions.
 */
contract BeraborrowBase {
    uint256 public constant DECIMAL_PRECISION = 1e18;

    // Amount of debt to be locked in gas pool on opening dens
    uint256 public immutable DEBT_GAS_COMPENSATION;

    uint256 public constant PERCENT_DIVISOR = 200; // dividing by 200 yields 0.5%

    constructor(uint256 _gasCompensation) {
        DEBT_GAS_COMPENSATION = _gasCompensation;
    }

    // --- Gas compensation functions ---

    // Returns the composite debt (drawn debt + gas compensation) of a den, for the purpose of ICR calculation
    function _getCompositeDebt(uint256 _debt) internal view returns (uint256) {
        return _debt + DEBT_GAS_COMPENSATION;
    }

    function _getNetDebt(uint256 _debt) internal view returns (uint256) {
        return _debt - DEBT_GAS_COMPENSATION;
    }

    // Return the amount of collateral to be drawn from a den's collateral and sent as gas compensation.
    function _getCollGasCompensation(uint256 _entireColl) internal pure returns (uint256) {
        return _entireColl / PERCENT_DIVISOR;
    }

    function _requireUserAcceptsFee(uint256 _fee, uint256 _amount, uint256 _maxFeePercentage) internal pure {
        uint256 feePercentage = _amount != 0 ? (_fee * DECIMAL_PRECISION) / _amount : 0;
        require(feePercentage <= _maxFeePercentage, "Fee exceeded provided maximum");
    }
}

// src/dependencies/BeraborrowMath.sol

library BeraborrowMath {
    uint256 internal constant DECIMAL_PRECISION = 1e18;

    /* Precision for Nominal ICR (independent of price). Rationale for the value:
     *
     * - Making it “too high” could lead to overflows.
     * - Making it “too low” could lead to an ICR equal to zero, due to truncation from Solidity floor division.
     *
     * This value of 1e20 is chosen for safety: the NICR will only overflow for numerator > ~1e39,
     * and will only truncate to 0 if the denominator is at least 1e20 times greater than the numerator.
     *
     */
    uint256 internal constant NICR_PRECISION = 1e20;

    function _min(uint256 _a, uint256 _b) internal pure returns (uint256) {
        return (_a < _b) ? _a : _b;
    }

    function _max(uint256 _a, uint256 _b) internal pure returns (uint256) {
        return (_a >= _b) ? _a : _b;
    }

    /*
     * Multiply two decimal numbers and use normal rounding rules:
     * -round product up if 19'th mantissa digit >= 5
     * -round product down if 19'th mantissa digit < 5
     *
     * Used only inside the exponentiation, _decPow().
     */
    function decMul(uint256 x, uint256 y) internal pure returns (uint256 decProd) {
        uint256 prod_xy = x * y;

        decProd = (prod_xy + (DECIMAL_PRECISION / 2)) / DECIMAL_PRECISION;
    }

    /*
     * _decPow: Exponentiation function for 18-digit decimal base, and integer exponent n.
     *
     * Uses the efficient "exponentiation by squaring" algorithm. O(log(n)) complexity.
     *
     * Called by two functions that represent time in units of minutes:
     * 1) DenManager._calcDecayedBaseRate
     * 2) CommunityIssuance._getCumulativeIssuanceFraction
     *
     * The exponent is capped to avoid reverting due to overflow. The cap 525600000 equals
     * "minutes in 1000 years": 60 * 24 * 365 * 1000
     *
     * If a period of > 1000 years is ever used as an exponent in either of the above functions, the result will be
     * negligibly different from just passing the cap, since:
     *
     * In function 1), the decayed base rate will be 0 for 1000 years or > 1000 years
     * In function 2), the difference in tokens issued at 1000 years and any time > 1000 years, will be negligible
     */
    function _decPow(uint256 _base, uint256 _minutes) internal pure returns (uint256) {
        if (_minutes > 525600000) {
            _minutes = 525600000;
        } // cap to avoid overflow

        if (_minutes == 0) {
            return DECIMAL_PRECISION;
        }

        uint256 y = DECIMAL_PRECISION;
        uint256 x = _base;
        uint256 n = _minutes;

        // Exponentiation-by-squaring
        while (n > 1) {
            if (n % 2 == 0) {
                x = decMul(x, x);
                n = n / 2;
            } else {
                // if (n % 2 != 0)
                y = decMul(x, y);
                x = decMul(x, x);
                n = (n - 1) / 2;
            }
        }

        return decMul(x, y);
    }

    function _getAbsoluteDifference(uint256 _a, uint256 _b) internal pure returns (uint256) {
        return (_a >= _b) ? _a - _b : _b - _a;
    }

    function _computeNominalCR(uint256 _coll, uint256 _debt) internal pure returns (uint256) {
        if (_debt > 0) {
            return (_coll * NICR_PRECISION) / _debt;
        }
        // Return the maximal value for uint256 if the Den has a debt of 0. Represents "infinite" CR.
        else {
            // if (_debt == 0)
            return 2 ** 256 - 1;
        }
    }

    function _computeCR(uint256 _coll, uint256 _debt, uint256 _price) internal pure returns (uint256) {
        if (_debt > 0) {
            uint256 newCollRatio = (_coll * _price) / _debt;

            return newCollRatio;
        }
        // Return the maximal value for uint256 if the Den has a debt of 0. Represents "infinite" CR.
        else {
            // if (_debt == 0)
            return 2 ** 256 - 1;
        }
    }

    function _computeCR(uint256 _coll, uint256 _debt) internal pure returns (uint256) {
        if (_debt > 0) {
            uint256 newCollRatio = (_coll) / _debt;

            return newCollRatio;
        }
        // Return the maximal value for uint256 if the Den has a debt of 0. Represents "infinite" CR.
        else {
            // if (_debt == 0)
            return 2 ** 256 - 1;
        }
    }
}

// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol

// OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}

// lib/openzeppelin-contracts/contracts/interfaces/IERC3156FlashBorrower.sol

// OpenZeppelin Contracts (last updated v4.7.0) (interfaces/IERC3156FlashBorrower.sol)

/**
 * @dev Interface of the ERC3156 FlashBorrower, as defined in
 * https://eips.ethereum.org/EIPS/eip-3156[ERC-3156].
 *
 * _Available since v4.1._
 */
interface IERC3156FlashBorrower {
    /**
     * @dev Receive a flash loan.
     * @param initiator The initiator of the loan.
     * @param token The loan currency.
     * @param amount The amount of tokens lent.
     * @param fee The additional amount of tokens to repay.
     * @param data Arbitrary data structure, intended to contain user-defined parameters.
     * @return The keccak256 hash of "IERC3156FlashBorrower.onFlashLoan"
     */
    function onFlashLoan(
        address initiator,
        address token,
        uint256 amount,
        uint256 fee,
        bytes calldata data
    ) external returns (bytes32);
}

// src/interfaces/core/IFactory.sol

interface IFactory {
    // commented values are suggested default parameters
    struct DeploymentParams {
        uint256 minuteDecayFactor; // 999037758833783000  (half life of 12 hours)
        uint256 redemptionFeeFloor; // 1e18 / 1000 * 5  (0.5%)
        uint256 maxRedemptionFee; // 1e18  (100%)
        uint256 borrowingFeeFloor; // 1e18 / 1000 * 5  (0.5%)
        uint256 maxBorrowingFee; // 1e18 / 100 * 5  (5%)
        uint256 interestRateInBps; // 100 (1%)
        uint256 maxDebt;
        uint256 MCR; // 12 * 1e17  (120%)
        address collVaultRouter; // set to address(0) if DenManager coll is not CollateralVault
    }

    event NewDeployment(address collateral, address priceFeed, address denManager, address sortedDens);

    function deployNewInstance(
        address collateral,
        address priceFeed,
        address customDenManagerImpl,
        address customSortedDensImpl,
        DeploymentParams calldata params,
        uint64 unlockRatePerSecond,
        bool forceThroughLspBalanceCheck
    ) external;

    function setImplementations(address _denManagerImpl, address _sortedDensImpl) external;

    function BERABORROW_CORE() external view returns (address);

    function borrowerOperations() external view returns (address);

    function debtToken() external view returns (address);

    function guardian() external view returns (address);

    function liquidationManager() external view returns (address);

    function owner() external view returns (address);

    function sortedDensImpl() external view returns (address);

    function liquidStabilityPool() external view returns (address);

    function denManagerCount() external view returns (uint256);

    function denManagerImpl() external view returns (address);

    function denManagers(uint256) external view returns (address);
}

// src/interfaces/core/ILiquidationManager.sol

interface ILiquidationManager {
    /// @notice Liquidation coll and debt gas compensation redistribution shares and recipients
    /// @dev Fees are in WAD
    struct LiquidationFeeData {
        uint256 liquidatorFee;
        uint256 sNectGaugeFee;
        uint256 poolFee;
        address validatorPool;
        address sNectGauge;
    }

    function batchLiquidateDens(address denManager, address[] calldata _denArray, address liquidator) external;

    function enableDenManager(address _denManager) external;

    function liquidate(address denManager, address borrower, address liquidator) external;

    function liquidateDens(address denManager, uint256 maxDensToLiquidate, uint256 maxICR, address liquidator) external;

    function DEBT_GAS_COMPENSATION() external view returns (uint256);

    function DECIMAL_PRECISION() external view returns (uint256);

    function PERCENT_DIVISOR() external view returns (uint256);

    function borrowerOperations() external view returns (address);

    function factory() external view returns (address);

    function liquidStabilityPool() external view returns (address);

    function liquidationsFeeAndRecipients() external view returns (LiquidationFeeData memory);

    function liquidatorLiquidationFee() external view returns(uint256 feeBps);

    function sNectGaugeLiquidationFee() external view returns(address recipient, uint256 feeBps);

    function poolLiquidationFee() external view returns(address recipient, uint256 feeBps);

    function DOMAIN_SEPARATOR() external view returns (bytes32);
}

// src/interfaces/core/IMetaBeraborrowCore.sol

interface IMetaBeraborrowCore {
    // ---------------------------------
    // Structures
    // ---------------------------------
    struct FeeInfo {
        bool existsForNect;
        uint16 nectFee;
    }

    struct RebalancerFeeInfo {
        bool exists;
        uint16 entryFee;
        uint16 exitFee;
    }

    // ---------------------------------
    // Public constants
    // ---------------------------------
    function OWNERSHIP_TRANSFER_DELAY() external view returns (uint256);
    function DEFAULT_FLASH_LOAN_FEE() external view returns (uint16);

    // ---------------------------------
    // Public state variables
    // ---------------------------------
    function nect() external view returns (address);
    function lspEntryFee() external view returns (uint16);
    function lspExitFee() external view returns (uint16);

    function feeReceiver() external view returns (address);
    function priceFeed() external view returns (address);
    function owner() external view returns (address);
    function pendingOwner() external view returns (address);
    function ownershipTransferDeadline() external view returns (uint256);
    function manager() external view returns (address);
    function guardian() external view returns (address);
    function paused() external view returns (bool);
    function lspBootstrapPeriod() external view returns (uint64);

    // ---------------------------------
    // External functions
    // ---------------------------------
    function setFeeReceiver(address _feeReceiver) external;
    function setPriceFeed(address _priceFeed) external;
    function setGuardian(address _guardian) external;
    function setManager(address _manager) external;

    /**
     * @notice Global pause/unpause
     *         Pausing halts new deposits/borrowing across the protocol
     */
    function setPaused(bool _paused) external;

    /**
     * @notice Extend or change the LSP bootstrap period,
     *         after which certain protocol mechanics change
     */
    function setLspBootstrapPeriod(uint64 _bootstrapPeriod) external;

    /**
     * @notice Set a custom flash-loan fee for a given periphery contract
     * @param _periphery Target contract that will get this custom fee
     * @param _nectFee Fee in basis points (bp)
     * @param _existsForNect Whether this custom fee is used when the caller = `nect`
     */
    function setPeripheryFlashLoanFee(address _periphery, uint16 _nectFee, bool _existsForNect) external;

    /**
     * @notice Begin the ownership transfer process
     * @param newOwner The address proposed to be the new owner
     */
    function commitTransferOwnership(address newOwner) external;

    /**
     * @notice Finish the ownership transfer, after the mandatory delay
     */
    function acceptTransferOwnership() external;

    /**
     * @notice Revoke a pending ownership transfer
     */
    function revokeTransferOwnership() external;

    /**
     * @notice Look up a custom flash-loan fee for a specific periphery contract
     * @param peripheryContract The contract that might have a custom fee
     * @return The flash-loan fee in basis points
     */
    function getPeripheryFlashLoanFee(address peripheryContract) external view returns (uint16);

    /**
     * @notice Set / override entry & exit fees for a special rebalancer contract
     */
    function setRebalancerFee(address _rebalancer, uint16 _entryFee, uint16 _exitFee) external;

    /**
     * @notice Set the LSP entry fee globally
     * @param _fee Fee in basis points
     */
    function setEntryFee(uint16 _fee) external;

    /**
     * @notice Set the LSP exit fee globally
     * @param _fee Fee in basis points
     */
    function setExitFee(uint16 _fee) external;

    /**
     * @notice Look up the LSP entry fee for a rebalancer
     * @param rebalancer Possibly has a special fee
     * @return The entry fee in basis points
     */
    function getLspEntryFee(address rebalancer) external view returns (uint16);

    /**
     * @notice Look up the LSP exit fee for a rebalancer
     * @param rebalancer Possibly has a special fee
     * @return The exit fee in basis points
     */
    function getLspExitFee(address rebalancer) external view returns (uint16);

    // ---------------------------------
    // Events
    // ---------------------------------
    event NewOwnerCommitted(address indexed owner, address indexed pendingOwner, uint256 deadline);
    event NewOwnerAccepted(address indexed oldOwner, address indexed newOwner);
    event NewOwnerRevoked(address indexed owner, address indexed revokedOwner);

    event FeeReceiverSet(address indexed feeReceiver);
    event PriceFeedSet(address indexed priceFeed);
    event GuardianSet(address indexed guardian);
    event ManagerSet(address indexed manager);
    event PeripheryFlashLoanFee(address indexed periphery, uint16 nectFee);
    event LSPBootstrapPeriodSet(uint64 bootstrapPeriod);
    event RebalancerFees(address indexed rebalancer, uint16 entryFee, uint16 exitFee);
    event EntryFeeSet(uint16 fee);
    event ExitFeeSet(uint16 fee);
    event Paused();
    event Unpaused();
}

// src/interfaces/core/IPriceFeed.sol

interface IPriceFeed {
    struct FeedType {
        address spotOracle;
        bool isCollVault;
    }

    event NewOracleRegistered(address token, address chainlinkAggregator, address underlyingDerivative);
    event PriceFeedStatusUpdated(address token, address oracle, bool isWorking);
    event PriceRecordUpdated(address indexed token, uint256 _price);
    event NewCollVaultRegistered(address collVault, bool enable);
    event NewSpotOracleRegistered(address token, address spotOracle);

    function fetchPrice(address _token) external view returns (uint256);

    function getMultiplePrices(address[] memory _tokens) external view returns (uint256[] memory prices);

    function setOracle(
        address _token,
        address _chainlinkOracle,
        uint32 _heartbeat,
        uint16 _staleThreshold,
        address underlyingDerivative
    ) external;

    function whitelistCollateralVault(address _collateralVaultShareToken, bool enable) external;
    
    function setSpotOracle(address _token, address _spotOracle) external;
    
    function MAX_PRICE_DEVIATION_FROM_PREVIOUS_ROUND() external view returns (uint256);

    function BERABORROW_CORE() external view returns (address);

    function RESPONSE_TIMEOUT() external view returns (uint256);

    function TARGET_DIGITS() external view returns (uint256);

    function guardian() external view returns (address);

    function oracleRecords(
        address
    )
        external
        view
        returns (
        address chainLinkOracle,
        uint8 decimals,
        uint32 heartbeat,
        uint16 staleThreshold,
        address underlyingDerivative
    );

    function isCollVault(address _collateralVaultShareToken) external view returns (bool);

    function isStableBPT(address _oracle) external view returns (bool);

    function isWeightedBPT(address _oracle) external view returns (bool);

    function getSpotOracle(address _token) external view returns (address);

    function feedType(address _token) external view returns (FeedType memory);

    function owner() external view returns (address);
}

// src/interfaces/core/ISortedDens.sol

interface ISortedDens {
    event NodeAdded(address _id, uint256 _NICR);
    event NodeRemoved(address _id);

    function insert(address _id, uint256 _NICR, address _prevId, address _nextId) external;

    function reInsert(address _id, uint256 _newNICR, address _prevId, address _nextId) external;

    function remove(address _id) external;

    function setAddresses(address _denManagerAddress) external;

    function contains(address _id) external view returns (bool);

    function data() external view returns (address head, address tail, uint256 size);

    function findInsertPosition(
        uint256 _NICR,
        address _prevId,
        address _nextId
    ) external view returns (address, address);

    function getFirst() external view returns (address);

    function getLast() external view returns (address);

    function getNext(address _id) external view returns (address);

    function getPrev(address _id) external view returns (address);

    function getSize() external view returns (uint256);

    function isEmpty() external view returns (bool);

    function denManager() external view returns (address);

    function validInsertPosition(uint256 _NICR, address _prevId, address _nextId) external view returns (bool);
}

// lib/openzeppelin-contracts/contracts/utils/math/Math.sol

// OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)

/**
 * @dev Standard math utilities missing in the Solidity language.
 */
library Math {
    enum Rounding {
        Down, // Toward negative infinity
        Up, // Toward infinity
        Zero // Toward zero
    }

    /**
     * @dev Returns the largest of two numbers.
     */
    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return a > b ? a : b;
    }

    /**
     * @dev Returns the smallest of two numbers.
     */
    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }

    /**
     * @dev Returns the average of two numbers. The result is rounded towards
     * zero.
     */
    function average(uint256 a, uint256 b) internal pure returns (uint256) {
        // (a + b) / 2 can overflow.
        return (a & b) + (a ^ b) / 2;
    }

    /**
     * @dev Returns the ceiling of the division of two numbers.
     *
     * This differs from standard division with `/` in that it rounds up instead
     * of rounding down.
     */
    function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
        // (a + b - 1) / b can overflow on addition, so we distribute.
        return a == 0 ? 0 : (a - 1) / b + 1;
    }

    /**
     * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
     * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
     * with further edits by Uniswap Labs also under MIT license.
     */
    function mulDiv(
        uint256 x,
        uint256 y,
        uint256 denominator
    ) internal pure returns (uint256 result) {
        unchecked {
            // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
            // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
            // variables such that product = prod1 * 2^256 + prod0.
            uint256 prod0; // Least significant 256 bits of the product
            uint256 prod1; // Most significant 256 bits of the product
            assembly {
                let mm := mulmod(x, y, not(0))
                prod0 := mul(x, y)
                prod1 := sub(sub(mm, prod0), lt(mm, prod0))
            }

            // Handle non-overflow cases, 256 by 256 division.
            if (prod1 == 0) {
                return prod0 / denominator;
            }

            // Make sure the result is less than 2^256. Also prevents denominator == 0.
            require(denominator > prod1);

            ///////////////////////////////////////////////
            // 512 by 256 division.
            ///////////////////////////////////////////////

            // Make division exact by subtracting the remainder from [prod1 prod0].
            uint256 remainder;
            assembly {
                // Compute remainder using mulmod.
                remainder := mulmod(x, y, denominator)

                // Subtract 256 bit number from 512 bit number.
                prod1 := sub(prod1, gt(remainder, prod0))
                prod0 := sub(prod0, remainder)
            }

            // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
            // See https://cs.stackexchange.com/q/138556/92363.

            // Does not overflow because the denominator cannot be zero at this stage in the function.
            uint256 twos = denominator & (~denominator + 1);
            assembly {
                // Divide denominator by twos.
                denominator := div(denominator, twos)

                // Divide [prod1 prod0] by twos.
                prod0 := div(prod0, twos)

                // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
                twos := add(div(sub(0, twos), twos), 1)
            }

            // Shift in bits from prod1 into prod0.
            prod0 |= prod1 * twos;

            // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
            // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
            // four bits. That is, denominator * inv = 1 mod 2^4.
            uint256 inverse = (3 * denominator) ^ 2;

            // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
            // in modular arithmetic, doubling the correct bits in each step.
            inverse *= 2 - denominator * inverse; // inverse mod 2^8
            inverse *= 2 - denominator * inverse; // inverse mod 2^16
            inverse *= 2 - denominator * inverse; // inverse mod 2^32
            inverse *= 2 - denominator * inverse; // inverse mod 2^64
            inverse *= 2 - denominator * inverse; // inverse mod 2^128
            inverse *= 2 - denominator * inverse; // inverse mod 2^256

            // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
            // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
            // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
            // is no longer required.
            result = prod0 * inverse;
            return result;
        }
    }

    /**
     * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
     */
    function mulDiv(
        uint256 x,
        uint256 y,
        uint256 denominator,
        Rounding rounding
    ) internal pure returns (uint256) {
        uint256 result = mulDiv(x, y, denominator);
        if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
            result += 1;
        }
        return result;
    }

    /**
     * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
     *
     * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
     */
    function sqrt(uint256 a) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
        //
        // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
        // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
        //
        // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
        // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
        // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
        //
        // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
        uint256 result = 1 << (log2(a) >> 1);

        // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
        // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
        // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
        // into the expected uint128 result.
        unchecked {
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            return min(result, a / result);
        }
    }

    /**
     * @notice Calculates sqrt(a), following the selected rounding direction.
     */
    function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
        unchecked {
            uint256 result = sqrt(a);
            return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
        }
    }

    /**
     * @dev Return the log in base 2, rounded down, of a positive value.
     * Returns 0 if given 0.
     */
    function log2(uint256 value) internal pure returns (uint256) {
        uint256 result = 0;
        unchecked {
            if (value >> 128 > 0) {
                value >>= 128;
                result += 128;
            }
            if (value >> 64 > 0) {
                value >>= 64;
                result += 64;
            }
            if (value >> 32 > 0) {
                value >>= 32;
                result += 32;
            }
            if (value >> 16 > 0) {
                value >>= 16;
                result += 16;
            }
            if (value >> 8 > 0) {
                value >>= 8;
                result += 8;
            }
            if (value >> 4 > 0) {
                value >>= 4;
                result += 4;
            }
            if (value >> 2 > 0) {
                value >>= 2;
                result += 2;
            }
            if (value >> 1 > 0) {
                result += 1;
            }
        }
        return result;
    }

    /**
     * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
     * Returns 0 if given 0.
     */
    function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
        unchecked {
            uint256 result = log2(value);
            return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
        }
    }

    /**
     * @dev Return the log in base 10, rounded down, of a positive value.
     * Returns 0 if given 0.
     */
    function log10(uint256 value) internal pure returns (uint256) {
        uint256 result = 0;
        unchecked {
            if (value >= 10**64) {
                value /= 10**64;
                result += 64;
            }
            if (value >= 10**32) {
                value /= 10**32;
                result += 32;
            }
            if (value >= 10**16) {
                value /= 10**16;
                result += 16;
            }
            if (value >= 10**8) {
                value /= 10**8;
                result += 8;
            }
            if (value >= 10**4) {
                value /= 10**4;
                result += 4;
            }
            if (value >= 10**2) {
                value /= 10**2;
                result += 2;
            }
            if (value >= 10**1) {
                result += 1;
            }
        }
        return result;
    }

    /**
     * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
     * Returns 0 if given 0.
     */
    function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
        unchecked {
            uint256 result = log10(value);
            return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
        }
    }

    /**
     * @dev Return the log in base 256, rounded down, of a positive value.
     * Returns 0 if given 0.
     *
     * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
     */
    function log256(uint256 value) internal pure returns (uint256) {
        uint256 result = 0;
        unchecked {
            if (value >> 128 > 0) {
                value >>= 128;
                result += 16;
            }
            if (value >> 64 > 0) {
                value >>= 64;
                result += 8;
            }
            if (value >> 32 > 0) {
                value >>= 32;
                result += 4;
            }
            if (value >> 16 > 0) {
                value >>= 16;
                result += 2;
            }
            if (value >> 8 > 0) {
                result += 1;
            }
        }
        return result;
    }

    /**
     * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
     * Returns 0 if given 0.
     */
    function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
        unchecked {
            uint256 result = log256(value);
            return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
        }
    }
}

// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/draft-IERC20Permit.sol

// OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)

/**
 * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
 * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
 *
 * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
 * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
 * need to send a transaction, and thus is not required to hold Ether at all.
 */
interface IERC20Permit {
    /**
     * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
     * given ``owner``'s signed approval.
     *
     * IMPORTANT: The same issues {IERC20-approve} has related to transaction
     * ordering also apply here.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `deadline` must be a timestamp in the future.
     * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
     * over the EIP712-formatted function arguments.
     * - the signature must use ``owner``'s current nonce (see {nonces}).
     *
     * For more information on the signature format, see the
     * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
     * section].
     */
    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    /**
     * @dev Returns the current nonce for `owner`. This value must be
     * included whenever a signature is generated for {permit}.
     *
     * Every successful call to {permit} increases ``owner``'s nonce by one. This
     * prevents a signature from being used multiple times.
     */
    function nonces(address owner) external view returns (uint256);

    /**
     * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
     */
    // solhint-disable-next-line func-name-mixedcase
    function DOMAIN_SEPARATOR() external view returns (bytes32);
}

// src/interfaces/core/IBeraborrowCore.sol

interface IBeraborrowCore {

    // --- Public variables ---
    function metaBeraborrowCore() external view returns (IMetaBeraborrowCore);
    function startTime() external view returns (uint256);
    function CCR() external view returns (uint256);
    function dmBootstrapPeriod() external view returns (uint64);
    function isPeriphery(address peripheryContract) external view returns (bool);

    // --- External functions ---

    function setPeripheryEnabled(address _periphery, bool _enabled) external;
    function setDMBootstrapPeriod(address dm, uint64 _bootstrapPeriod) external;
    function setNewCCR(uint256 _CCR) external;

    function priceFeed() external view returns (address);
    function owner() external view returns (address);
    function pendingOwner() external view returns (address);
    function guardian() external view returns (address);
    function manager() external view returns (address);
    function feeReceiver() external view returns (address);
    function paused() external view returns (bool);
    function lspBootstrapPeriod() external view returns (uint64);
    function getLspEntryFee(address rebalancer) external view returns (uint16);
    function getLspExitFee(address rebalancer) external view returns (uint16);
    function getPeripheryFlashLoanFee(address peripheryContract) external view returns (uint16);

    // --- Events ---
    event CCRSet(uint256 initialCCR);
    event DMBootstrapPeriodSet(address dm, uint64 bootstrapPeriod);
    event PeripheryEnabled(address indexed periphery, bool enabled);
}

// src/dependencies/BeraborrowOwnable.sol

/**
    @title Beraborrow Ownable
    @notice Contracts inheriting `BeraborrowOwnable` have the same owner as `BeraborrowCore`.
            The ownership cannot be independently modified or renounced.
    @dev In the contracts that use BERABORROW_CORE to interact with protocol instance specific parameters,
            the immutable will be instanced with BeraborrowCore.sol, eitherway, it will be MetaBeraborrowCore.sol
 */
contract BeraborrowOwnable {
    IBeraborrowCore public immutable BERABORROW_CORE;

    constructor(address _beraborrowCore) {
        BERABORROW_CORE = IBeraborrowCore(_beraborrowCore);
    }

    modifier onlyOwner() {
        require(msg.sender == BERABORROW_CORE.owner(), "Only owner");
        _;
    }

    function owner() public view returns (address) {
        return BERABORROW_CORE.owner();
    }

    function guardian() public view returns (address) {
        return BERABORROW_CORE.guardian();
    }
}

// src/interfaces/core/IBorrowerOperations.sol

interface IBorrowerOperations {
    struct Balances {
        uint256[] collaterals;
        uint256[] debts;
        uint256[] prices;
    }

    event BorrowingFeePaid(address indexed borrower, uint256 amount);
    event CollateralConfigured(address denManager, address collateralToken);
    event DenCreated(address indexed _borrower, uint256 arrayIndex);
    event DenManagerRemoved(address denManager);
    event DenUpdated(address indexed _borrower, uint256 _debt, uint256 _coll, uint256 stake, uint8 operation);

    function addColl(
        address denManager,
        address account,
        uint256 _collateralAmount,
        address _upperHint,
        address _lowerHint
    ) external;

    function adjustDen(
        address denManager,
        address account,
        uint256 _maxFeePercentage,
        uint256 _collDeposit,
        uint256 _collWithdrawal,
        uint256 _debtChange,
        bool _isDebtIncrease,
        address _upperHint,
        address _lowerHint
    ) external;

    function brimeDen() external view returns (address);

    function closeDen(address denManager, address account) external;

    function configureCollateral(address denManager, address collateralToken) external;

    function fetchBalances() external view returns (Balances memory balances);

    function getGlobalSystemBalances() external view returns (uint256 totalPricedCollateral, uint256 totalDebt);

    function getTCR() external view returns (uint256 globalTotalCollateralRatio);

    function openDen(
        address denManager,
        address account,
        uint256 _maxFeePercentage,
        uint256 _collateralAmount,
        uint256 _debtAmount,
        address _upperHint,
        address _lowerHint
    ) external;

    function removeDenManager(address denManager) external;

    function repayDebt(
        address denManager,
        address account,
        uint256 _debtAmount,
        address _upperHint,
        address _lowerHint
    ) external;

    function setDelegateApproval(address _delegate, bool _isApproved) external;

    function setMinNetDebt(uint256 _minNetDebt) external;

    function withdrawColl(
        address denManager,
        address account,
        uint256 _collWithdrawal,
        address _upperHint,
        address _lowerHint
    ) external;

    function withdrawDebt(
        address denManager,
        address account,
        uint256 _maxFeePercentage,
        uint256 _debtAmount,
        address _upperHint,
        address _lowerHint
    ) external;

    function denManagers(uint256) external view returns (address);

    function checkRecoveryMode(uint256 TCR) external view returns (bool);

    function DEBT_GAS_COMPENSATION() external view returns (uint256);

    function DECIMAL_PRECISION() external view returns (uint256);

    function PERCENT_DIVISOR() external view returns (uint256);

    function BERABORROW_CORE() external view returns (IBeraborrowCore);

    function debtToken() external view returns (address);

    function factory() external view returns (address);

    function getCompositeDebt(uint256 _debt) external view returns (uint256);

    function guardian() external view returns (address);

    function isApprovedDelegate(address owner, address caller) external view returns (bool isApproved);

    function minNetDebt() external view returns (uint256);

    function owner() external view returns (address);

    function denManagersData(address) external view returns (address collateralToken, uint16 index);

    function brimeMCR() external view returns (uint256);
}

// src/dependencies/SystemStart.sol

/**
    @title Beraborrow System Start Time
    @dev Provides a unified `startTime` and `getWeek`, used for emissions.
 */
contract SystemStart {
    uint256 immutable startTime;

    constructor(address beraborrowCore) {
        startTime = IBeraborrowCore(beraborrowCore).startTime();
    }

    function getWeek() public view returns (uint256 week) {
        return (block.timestamp - startTime) / 1 weeks;
    }
}

// lib/openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol

// OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/utils/SafeERC20.sol)

/**
 * @title SafeERC20
 * @dev Wrappers around ERC20 operations that throw on failure (when the token
 * contract returns false). Tokens that return no value (and instead revert or
 * throw on failure) are also supported, non-reverting calls are assumed to be
 * successful.
 * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
library SafeERC20 {
    using Address for address;

    function safeTransfer(
        IERC20 token,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(
        IERC20 token,
        address from,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    /**
     * @dev Deprecated. This function has issues similar to the ones found in
     * {IERC20-approve}, and its usage is discouraged.
     *
     * Whenever possible, use {safeIncreaseAllowance} and
     * {safeDecreaseAllowance} instead.
     */
    function safeApprove(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        require(
            (value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        uint256 newAllowance = token.allowance(address(this), spender) + value;
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        unchecked {
            uint256 oldAllowance = token.allowance(address(this), spender);
            require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
            uint256 newAllowance = oldAllowance - value;
            _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
        }
    }

    function safePermit(
        IERC20Permit token,
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) internal {
        uint256 nonceBefore = token.nonces(owner);
        token.permit(owner, spender, value, deadline, v, r, s);
        uint256 nonceAfter = token.nonces(owner);
        require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves. We use {Address-functionCall} to perform this call, which verifies that
        // the target address contains contract code and also asserts for success in the low-level call.

        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
        if (returndata.length > 0) {
            // Return data is optional
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

// src/interfaces/core/IDebtToken.sol

 

interface IDebtToken is IERC20 {
    // --- Events ---
    event FlashLoanFeeUpdated(uint256 newFee);

    // --- Public constants ---
    function version() external view returns (string memory);
    function permitTypeHash() external view returns (bytes32);

    // --- Public immutables ---
    function gasPool() external view returns (address);
    function DEBT_GAS_COMPENSATION() external view returns (uint256);
    function PSMBond() external view returns (address);

    // --- Public mappings ---
    function liquidStabilityPools(address) external view returns (bool);
    function borrowerOperations(address) external view returns (bool);
    function factories(address) external view returns (bool);
    function peripheries(address) external view returns (bool);
    function denManagers(address) external view returns (bool);

    // --- External functions ---

    function enableDenManager(address _denManager) external;
    function mintWithGasCompensation(address _account, uint256 _amount) external returns (bool);
    function burnWithGasCompensation(address _account, uint256 _amount) external returns (bool);
    function mint(address _account, uint256 _amount) external;
    function burn(address _account, uint256 _amount) external;
    function decimals() external view returns (uint8);
    function sendToPeriphery(address _sender, uint256 _amount) external;
    function sendToSP(address _sender, uint256 _amount) external;
    function returnFromPool(address _poolAddress, address _receiver, uint256 _amount) external;
    function transfer(address recipient, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function maxFlashLoan(address token) external view returns (uint256);
    function flashFee(address token, uint256 amount) external view returns (uint256);
    function flashLoan(
        IERC3156FlashBorrower receiver,
        address token,
        uint256 amount,
        bytes calldata data
    ) external returns (bool);
    function whitelistLiquidStabilityPoolAddress(address _liquidStabilityPool, bool active) external;
    function whitelistBorrowerOperationsAddress(address _borrowerOperations, bool active) external;
    function whitelistFactoryAddress(address _factory, bool active) external;
    function whitelistPeripheryAddress(address _periphery, bool active) external;
    function setDebtGasCompensation(uint256 _gasCompensation, bool _isFinalValue) external;
    function setFlashLoanFee(uint256 _fee) external;
    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function permit(
        address owner,
        address spender,
        uint256 amount,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;
    function nonces(address owner) external view returns (uint256);
}

// src/core/DenManager.sol

/**
    @title Beraborrow Den Manager
    @notice Based on Liquity's `TroveManager`
            https://github.com/liquity/dev/blob/main/packages/contracts/contracts/TroveManager.sol

            Beraborrow's implementation is modified so that multiple `DenManager` and `SortedDens`
            contracts are deployed in tandem, with each pair managing dens of a single collateral
            type.

            Functionality related to liquidations has been moved to `LiquidationManager`. This was
            necessary to avoid the restriction on deployed bytecode size.
 */
contract DenManager is BeraborrowBase, BeraborrowOwnable, SystemStart {
    using SafeERC20 for IERC20;

    // --- Connected contract declarations ---

    address public immutable borrowerOperations;
    address public immutable liquidationManager;
    address immutable gasPoolAddress;
    IDebtToken public immutable debtToken;
    address public immutable brimeDen;
    
    address public collVaultRouter;
    IPriceFeed public priceFeed;
    IERC20 public collateralToken;

    // A doubly linked list of Dens, sorted by their collateral ratios
    ISortedDens public sortedDens;

    // Minimum collateral ratio for individual dens
    uint256 public MCR;

    uint256 constant SECONDS_IN_ONE_MINUTE = 60;
    uint256 constant INTEREST_PRECISION = 1e27;
    uint256 constant SECONDS_IN_YEAR = 365 days;

    uint256 public constant SUNSETTING_INTEREST_RATE = (INTEREST_PRECISION * 5000) / (BP * SECONDS_IN_YEAR); // 50%

    uint256 constant _100pct = 1000000000000000000; // 1e18 == 100%, below this CR it's considered undercollateralized

    /*
     * BETA: 18 digit decimal. Parameter by which to divide the redeemed fraction, in order to calc the new base rate from a redemption.
     * Corresponds to (1 / ALPHA) in the white paper.
     */
    uint256 constant BETA = 2;

    uint16 constant BP = 1e4;

    // --- ERC 3156 Data ---
    bytes32 private constant _RETURN_VALUE = keccak256("ERC3156FlashBorrower.onFlashLoan");

    // commented values are Liquity's fixed settings for each parameter
    uint256 public minuteDecayFactor; // 999037758833783000  (half-life of 12 hours)
    /// @dev Redemption fee floor should be higher than deviation threshold of oracle supporting this collateral
    uint256 public redemptionFeeFloor; // DECIMAL_PRECISION / 1000 * 5  (0.5%)
    uint256 public maxRedemptionFee; // DECIMAL_PRECISION  (100%)
    uint256 public borrowingFeeFloor; // DECIMAL_PRECISION / 1000 * 5  (0.5%)
    uint256 public maxBorrowingFee; // DECIMAL_PRECISION / 100 * 5  (5%)
    uint256 public maxSystemDebt;

    uint256 public interestRate;
    uint256 public activeInterestIndex;
    uint256 public lastActiveIndexUpdate;

    uint256 public systemDeploymentTime;
    bool public sunsetting;
    bool public paused;

    uint256 public baseRate;

    // The timestamp of the latest fee operation (redemption or new debt issuance)
    uint256 public lastFeeOperationTime;

    uint256 public totalStakes;

    // Snapshot of the value of totalStakes, taken immediately after the latest liquidation
    uint256 public totalStakesSnapshot;

    // Snapshot of the total collateral taken immediately after the latest liquidation.
    uint256 public totalCollateralSnapshot;

    /*
     * L_collateral and L_debt track the sums of accumulated liquidation rewards per unit staked. During its lifetime, each stake earns:
     *
     * An collateral gain of ( stake * [L_collateral - L_collateral(0)] )
     * A debt increase  of ( stake * [L_debt - L_debt(0)] )
     *
     * Where L_collateral(0) and L_debt(0) are snapshots of L_collateral and L_debt for the active Den taken at the instant the stake was made
     */
    uint256 public L_collateral;
    uint256 public L_debt;

    // Error trackers for the den redistribution calculation
    uint256 public lastCollateralError_Redistribution;
    uint256 public lastDebtError_Redistribution;

    uint256 internal totalActiveCollateral;
    uint256 internal totalActiveDebt;
    uint256 public interestPayable;

    uint256 public defaultedCollateral;
    uint256 public defaultedDebt;

    mapping(address => Den) public Dens;
    mapping(address => uint256) public surplusBalances;

    // Map addresses with active dens to their RewardSnapshot
    mapping(address => RewardSnapshot) public rewardSnapshots;

    // Array of all active den addresses - used to to compute an approximate hint off-chain, for the sorted list insertion
    address[] DenOwners;

    // Store the necessary data for a den
    struct Den {
        uint256 debt;
        uint256 coll;
        uint256 stake;
        Status status;
        uint128 arrayIndex;
        uint256 activeInterestIndex;
    }

    struct RedemptionTotals {
        uint256 remainingDebt;
        uint256 totalDebtToRedeem;
        uint256 totalCollateralDrawn;
        uint256 collateralFee;
        uint256 collateralToSendToRedeemer;
        uint256 decayedBaseRate;
        uint256 price;
        uint256 totalDebtSupplyAtStart;
    }

    struct SingleRedemptionValues {
        uint256 debtLot;
        uint256 collateralLot;
        bool cancelledPartial;
    }

    // Object containing the collateral and debt snapshots for a given active den
    struct RewardSnapshot {
        uint256 collateral;
        uint256 debt;
    }

    enum DenManagerOperation {
        applyPendingRewards,
        liquidateInNormalMode,
        liquidateInRecoveryMode,
        redeemCollateral
    }

    enum Status {
        nonExistent,
        active,
        closedByOwner,
        closedByLiquidation,
        closedByRedemption
    }

    event NewParameters(IFactory.DeploymentParams params);
    event PriceFeedUpdated(address _priceFeed);
    event DenUpdated(
        address indexed _borrower,
        uint256 _debt,
        uint256 _coll,
        uint256 _stake,
        DenManagerOperation _operation
    );
    event Redemption(
        address indexed _redeemer,
        uint256 _attemptedDebtAmount,
        uint256 _actualDebtAmount,
        uint256 _collateralSent,
        uint256 _collateralFee
    );
    event BaseRateUpdated(uint256 _baseRate);
    event LastFeeOpTimeUpdated(uint256 _lastFeeOpTime);
    event TotalStakesUpdated(uint256 _newTotalStakes);
    event SystemSnapshotsUpdated(uint256 _totalStakesSnapshot, uint256 _totalCollateralSnapshot);
    event LTermsUpdated(uint256 _L_collateral, uint256 _L_debt);
    event DenSnapshotsUpdated(uint256 _L_collateral, uint256 _L_debt);
    event DenIndexUpdated(address _borrower, uint256 _newIndex);
    event CollateralSent(address _to, uint256 _amount);

    modifier whenNotPaused() {
        require(!paused, "Collateral Paused");
        _;
    }

    /// @dev Overrided by PermissionedDenManager to enforce only one den
    function _isPermissionedCheck(address _borrower) internal virtual {}

    constructor(
        address _beraborrowCore,
        address _gasPoolAddress,
        address _debtTokenAddress,
        address _borrowerOperations,
        address _liquidationManager,
        address _brimeDen,
        uint256 _gasCompensation
    ) BeraborrowOwnable(_beraborrowCore) BeraborrowBase(_gasCompensation) SystemStart(_beraborrowCore) {
        if (_beraborrowCore == address(0) || _gasPoolAddress == address(0) || _debtTokenAddress == address(0) || _borrowerOperations == address(0) || _liquidationManager == address(0) || _brimeDen == address(0)) {
            revert("DenManager: 0 address");
        }

        gasPoolAddress = _gasPoolAddress;
        debtToken = IDebtToken(_debtTokenAddress);
        borrowerOperations = _borrowerOperations;
        liquidationManager = _liquidationManager;
        brimeDen = _brimeDen;
    }

    function setAddresses(address _priceFeedAddress, address _sortedDensAddress, address _collateralToken) external {
        require(address(sortedDens) == address(0));
        priceFeed = IPriceFeed(_priceFeedAddress);
        sortedDens = ISortedDens(_sortedDensAddress);
        collateralToken = IERC20(_collateralToken);

        systemDeploymentTime = block.timestamp;
        sunsetting = false;
        activeInterestIndex = INTEREST_PRECISION;
        lastActiveIndexUpdate = block.timestamp;
    }

    /**
     * @notice Sets the pause state for this den manager
     *         Pausing is used to mitigate risks in exceptional circumstances
     *         Functionalities affected by pausing are:
     *         - New borrowing is not possible
     *         - New collateral deposits are not possible
     * @param _paused If true the protocol is paused
     */
    function setPaused(bool _paused) external {
        require((_paused && msg.sender == guardian()) || msg.sender == owner(), "Unauthorized");
        paused = _paused;
    }

    /**
     * @notice Sets a custom price feed for this den manager
     * @param _priceFeedAddress Price feed address
     */
    function setPriceFeed(address _priceFeedAddress) external onlyOwner {
        priceFeed = IPriceFeed(_priceFeedAddress);
        emit PriceFeedUpdated(_priceFeedAddress);
    }

    function setCollVaultRouter(address _collVaultRouter) external onlyOwner {
        collVaultRouter = _collVaultRouter;
    }

    /**
     * @notice Starts sunsetting a collateral
     *         During sunsetting only the following are possible:
               1) Disable collateral handoff to SP
               2) Greatly Increase interest rate to incentivize redemptions
               3) Remove redemptions fees
               4) Disable new loans
        @dev IMPORTANT: When sunsetting a collateral altogether this function should be called on
                        all DM linked to that collateral as well as `StabilityPool.startCollateralSunset`
        @dev IMPORTANT: A peripheral system will ensure users aren't MEVed due to redemptions fees being removed
     */
    function startSunset() external onlyOwner {
        sunsetting = true;
        _accrueActiveInterests();
        interestRate = SUNSETTING_INTEREST_RATE;
        // accrual function doesn't update timestamp if interest was 0
        lastActiveIndexUpdate = block.timestamp;
        redemptionFeeFloor = 0;
        maxSystemDebt = 0;
        baseRate = 0;
        maxRedemptionFee = 0;
    }

    /*
        _minuteDecayFactor is calculated as

            10**18 * (1/2)**(1/n)

        where n = the half-life in minutes
     */
    function setParameters(IFactory.DeploymentParams calldata params) public  {
        require(!sunsetting, "Cannot change after sunset");
        require(params.MCR <= BERABORROW_CORE.CCR() && params.MCR >= 1.1e18, "MCR cannot be > CCR or < 110%");

        if (minuteDecayFactor != 0) {
            require(msg.sender == owner(), "Only owner");
        }
        require(
            params.minuteDecayFactor >= 977159968434245900 && // half-life of 30 minutes
                params.minuteDecayFactor <= 999931237762985000 // half-life of 1 week
        );
        require(params.redemptionFeeFloor <= params.maxRedemptionFee && params.maxRedemptionFee <= DECIMAL_PRECISION);
        require(params.borrowingFeeFloor <= params.maxBorrowingFee && params.maxBorrowingFee <= DECIMAL_PRECISION);

        _decayBaseRate();

        minuteDecayFactor = params.minuteDecayFactor;
        redemptionFeeFloor = params.redemptionFeeFloor;
        maxRedemptionFee = params.maxRedemptionFee;
        borrowingFeeFloor = params.borrowingFeeFloor;
        maxBorrowingFee = params.maxBorrowingFee;
        maxSystemDebt = params.maxDebt;
        collVaultRouter = params.collVaultRouter;

        uint256 newInterestRate = (INTEREST_PRECISION * params.interestRateInBps) / (BP * SECONDS_IN_YEAR);
        if (newInterestRate != interestRate) {
            _accrueActiveInterests();
            // accrual function doesn't update timestamp if interest was 0
            lastActiveIndexUpdate = block.timestamp;
            interestRate = newInterestRate;
        }
        MCR = params.MCR;

        emit NewParameters(params);
    }

    function collectInterests() external {
        uint256 interestPayableCached = interestPayable;
        require(interestPayableCached > 0, "Nothing to collect");
        debtToken.mint(BERABORROW_CORE.feeReceiver(), interestPayableCached);
        interestPayable = 0;
    }

    // --- Getters ---

    function fetchPrice() public view returns (uint256) {
        IPriceFeed _priceFeed = priceFeed;
        if (address(_priceFeed) == address(0)) {
            _priceFeed = IPriceFeed(BERABORROW_CORE.priceFeed());
        }
        return _priceFeed.fetchPrice(address(collateralToken));
    }

    function getDenOwnersCount() external view returns (uint256) {
        return DenOwners.length;
    }

    function getDenFromDenOwnersArray(uint256 _index) external view returns (address) {
        return DenOwners[_index];
    }

    function getDenStatus(address _borrower) external view returns (uint256) {
        return uint256(Dens[_borrower].status);
    }

    function getDenStake(address _borrower) external view returns (uint256) {
        return Dens[_borrower].stake;
    }

    /**
        @notice Get the current total collateral and debt amounts for a den
        @dev Also includes pending rewards from redistribution
     */
    function getDenCollAndDebt(address _borrower) public view returns (uint256 coll, uint256 debt) {
        (debt, coll, , ) = getEntireDebtAndColl(_borrower);
        return (coll, debt);
    }

    /**
        @notice Get the total and pending collateral and debt amounts for a den
        @dev Used by the liquidation manager
     */
    function getEntireDebtAndColl(
        address _borrower
    ) public view returns (uint256 debt, uint256 coll, uint256 pendingDebtReward, uint256 pendingCollateralReward) {
        Den storage t = Dens[_borrower];
        debt = t.debt;
        coll = t.coll;

        (pendingCollateralReward, pendingDebtReward) = getPendingCollAndDebtRewards(_borrower);
        // Accrued den interest for correct liquidation values. This assumes the index to be updated.
        uint256 denInterestIndex = t.activeInterestIndex;
        if (denInterestIndex > 0 && _borrower != brimeDen) {
            (uint256 currentIndex, ) = _calculateInterestIndex();
            debt = (debt * currentIndex) / denInterestIndex;
        }

        debt = debt + pendingDebtReward;
        coll = coll + pendingCollateralReward;
    }

    function getEntireSystemColl() public view returns (uint256) {
        return totalActiveCollateral + defaultedCollateral;
    }

    function getEntireSystemDebt() public view returns (uint256) {
        uint256 currentActiveDebt = totalActiveDebt;
        (, uint256 interestFactor) = _calculateInterestIndex();
        if (interestFactor > 0) {
            uint256 activeInterests = Math.mulDiv(currentActiveDebt, interestFactor, INTEREST_PRECISION);
            currentActiveDebt = currentActiveDebt + activeInterests;
        }
        return currentActiveDebt + defaultedDebt;
    }

    function getEntireSystemBalances() external view returns (uint256, uint256, uint256) {
        return (getEntireSystemColl(), getEntireSystemDebt(), fetchPrice());
    }

    // --- Helper functions ---

    // Return the nominal collateral ratio (ICR) of a given Den, without the price. Takes a den's pending coll and debt rewards from redistributions into account.
    function getNominalICR(address _borrower) public view returns (uint256) {
        (uint256 currentCollateral, uint256 currentDebt) = getDenCollAndDebt(_borrower);

        uint256 NICR = BeraborrowMath._computeNominalCR(currentCollateral, currentDebt);
        return NICR;
    }

    // Return the current collateral ratio (ICR) of a given Den. Takes a den's pending coll and debt rewards from redistributions into account.
    function getCurrentICR(address _borrower, uint256 _price) public view returns (uint256) {
        (uint256 currentCollateral, uint256 currentDebt) = getDenCollAndDebt(_borrower);

        uint256 ICR = BeraborrowMath._computeCR(currentCollateral, currentDebt, _price);
        return ICR;
    }

    function getTotalActiveCollateral() public view returns (uint256) {
        return totalActiveCollateral;
    }

    function getTotalActiveDebt() public view returns (uint256) {
        uint256 currentActiveDebt = totalActiveDebt;
        (, uint256 interestFactor) = _calculateInterestIndex();
        if (interestFactor > 0) {
            uint256 activeInterests = Math.mulDiv(currentActiveDebt, interestFactor, INTEREST_PRECISION);
            currentActiveDebt = currentActiveDebt + activeInterests;
        }
        return currentActiveDebt;
    }

    // Get the borrower's pending accumulated collateral and debt rewards, earned by their stake
    function getPendingCollAndDebtRewards(address _borrower) public view returns (uint256, uint256) {
        RewardSnapshot memory snapshot = rewardSnapshots[_borrower];

        uint256 coll = L_collateral - snapshot.collateral;
        uint256 debt = L_debt - snapshot.debt;

        if (coll + debt == 0 || Dens[_borrower].status != Status.active) return (0, 0);

        uint256 stake = Dens[_borrower].stake;
        return ((stake * coll) / DECIMAL_PRECISION, (stake * debt) / DECIMAL_PRECISION);
    }

    function hasPendingRewards(address _borrower) public view returns (bool) {
        /*
         * A Den has pending rewards if its snapshot is less than the current rewards per-unit-staked sum:
         * this indicates that rewards have occured since the snapshot was made, and the user therefore has
         * pending rewards
         */
        if (Dens[_borrower].status != Status.active) {
            return false;
        }

        return (rewardSnapshots[_borrower].collateral < L_collateral);
    }

    // --- Redemption fee functions ---

    /*
     * This function has two impacts on the baseRate state variable:
     * 1) decays the baseRate based on time passed since last redemption or debt borrowing operation.
     * then,
     * 2) increases the baseRate based on the amount redeemed, as a proportion of total supply
     */
    function _updateBaseRateFromRedemption(
        uint256 _collateralDrawn,
        uint256 _price,
        uint256 _totalDebtSupply
    ) internal returns (uint256) {
        uint256 decayedBaseRate = _calcDecayedBaseRate();

        /* Convert the drawn collateral back to debt at face value rate (1 debt:1 USD), in order to get
         * the fraction of total supply that was redeemed at face value. */
        uint256 redeemedDebtFraction = (_collateralDrawn * _price) / _totalDebtSupply;

        uint256 newBaseRate = decayedBaseRate + (redeemedDebtFraction / BETA);
        newBaseRate = BeraborrowMath._min(newBaseRate, DECIMAL_PRECISION); // cap baseRate at a maximum of 100%

        // Update the baseRate state variable
        baseRate = newBaseRate;
        emit BaseRateUpdated(newBaseRate);

        _updateLastFeeOpTime();

        return newBaseRate;
    }

    function getRedemptionRate() public view returns (uint256) {
        return _calcRedemptionRate(baseRate);
    }

    function getRedemptionRateWithDecay() public view returns (uint256) {
        return _calcRedemptionRate(_calcDecayedBaseRate());
    }

    function _calcRedemptionRate(uint256 _baseRate) internal view returns (uint256) {
        return
            BeraborrowMath._min(
                redemptionFeeFloor + _baseRate,
                maxRedemptionFee
            );
    }

    function getRedemptionFeeWithDecay(uint256 _collateralDrawn) external view returns (uint256) {
        return _calcRedemptionFee(getRedemptionRateWithDecay(), _collateralDrawn);
    }

    function _calcRedemptionFee(uint256 _redemptionRate, uint256 _collateralDrawn) internal pure returns (uint256) {
        uint256 redemptionFee = (_redemptionRate * _collateralDrawn) / DECIMAL_PRECISION;
        require(redemptionFee < _collateralDrawn, "Fee exceeds returned collateral");
        return redemptionFee;
    }

    // --- Borrowing fee functions ---

    function getBorrowingRate() public view returns (uint256) {
        return _calcBorrowingRate(baseRate);
    }

    function getBorrowingRateWithDecay() public view returns (uint256) {
        return _calcBorrowingRate(_calcDecayedBaseRate());
    }

    function _calcBorrowingRate(uint256 _baseRate) internal view returns (uint256) {
        return BeraborrowMath._min(borrowingFeeFloor + _baseRate, maxBorrowingFee);
    }

    function getBorrowingFee(uint256 _debt) external view returns (uint256) {
        return _calcBorrowingFee(getBorrowingRate(), _debt);
    }

    function getBorrowingFeeWithDecay(uint256 _debt) external view returns (uint256) {
        return _calcBorrowingFee(getBorrowingRateWithDecay(), _debt);
    }

    function _calcBorrowingFee(uint256 _borrowingRate, uint256 _debt) internal pure returns (uint256) {
        return (_borrowingRate * _debt) / DECIMAL_PRECISION;
    }

    // --- Internal fee functions ---

    // Update the last fee operation time only if time passed >= decay interval. This prevents base rate griefing.
    function _updateLastFeeOpTime() internal {
        uint256 timePassed = block.timestamp - lastFeeOperationTime;
        if (timePassed >= SECONDS_IN_ONE_MINUTE) {
            lastFeeOperationTime += _minutesPassedSinceLastFeeOp() * SECONDS_IN_ONE_MINUTE;
            emit LastFeeOpTimeUpdated(block.timestamp);
        }
    }

    function _calcDecayedBaseRate() internal view returns (uint256) {
        uint256 minutesPassed = _minutesPassedSinceLastFeeOp();
        uint256 decayFactor = BeraborrowMath._decPow(minuteDecayFactor, minutesPassed);

        return (baseRate * decayFactor) / DECIMAL_PRECISION;
    }

    function _minutesPassedSinceLastFeeOp() internal view returns (uint256) {
        return (block.timestamp - lastFeeOperationTime) / SECONDS_IN_ONE_MINUTE;
    }

    // --- Redemption functions ---

    /* Send _debtAmount debt to the system and redeem the corresponding amount of collateral from as many Dens as are needed to fill the redemption
     * request.  Applies pending rewards to a Den before reducing its debt and coll.
     *
     * Note that if _amount is very large, this function can run out of gas, specially if traversed dens are small. This can be easily avoided by
     * splitting the total _amount in appropriate chunks and calling the function multiple times.
     *
     * Param `_maxIterations` can also be provided, so the loop through Dens is capped (if it’s zero, it will be ignored).This makes it easier to
     * avoid OOG for the frontend, as only knowing approximately the average cost of an iteration is enough, without needing to know the “topology”
     * of the den list. It also avoids the need to set the cap in stone in the contract, nor doing gas calculations, as both gas price and opcode
     * costs can vary.
     *
     * All Dens that are redeemed from -- with the likely exception of the last one -- will end up with no debt left, therefore they will be closed.
     * If the last Den does have some remaining debt, it has a finite ICR, and the reinsertion could be anywhere in the list, therefore it requires a hint.
     * A frontend should use getRedemptionHints() to calculate what the ICR of this Den will be after redemption, and pass a hint for its position
     * in the sortedDens list along with the ICR value that the hint was found for.
     *
     * If another transaction modifies the list between calling getRedemptionHints() and passing the hints to redeemCollateral(), it
     * is very likely that the last (partially) redeemed Den would end up with a different ICR than what the hint is for. In this case the
     * redemption will stop after the last completely redeemed Den and the sender will keep the remaining debt amount, which they can attempt
     * to redeem later.
     */
    function redeemCollateral(
        uint256 _debtAmount,
        address _firstRedemptionHint,
        address _upperPartialRedemptionHint,
        address _lowerPartialRedemptionHint,
        uint256 _partialRedemptionHintNICR,
        uint256 _maxIterations,
        uint256 _maxFeePercentage
    ) external {
        ISortedDens _sortedDensCached = sortedDens;
        RedemptionTotals memory totals;

        require(
            _maxFeePercentage >= redemptionFeeFloor && _maxFeePercentage <= maxRedemptionFee,
            "Max fee not in bounds"
        );
        require(block.timestamp >= systemDeploymentTime + BERABORROW_CORE.dmBootstrapPeriod(), "BOOTSTRAP_PERIOD");
        totals.price = fetchPrice();
        require(IBorrowerOperations(borrowerOperations).getTCR() >= MCR, "Cannot redeem when TCR < MCR");
        require(_debtAmount > 0, "Amount must be greater than zero");
        require(debtToken.balanceOf(msg.sender) >= _debtAmount, "Insufficient balance");
        _updateBalances();
        totals.totalDebtSupplyAtStart = getEntireSystemDebt();

        totals.remainingDebt = _debtAmount;
        address currentBorrower;

        if (_isValidFirstRedemptionHint(_sortedDensCached, _firstRedemptionHint, totals.price)) {
            currentBorrower = _firstRedemptionHint;
        } else {
            currentBorrower = _sortedDensCached.getLast();
            // Find the first den with ICR >= MCR
            while (currentBorrower != address(0) && getCurrentICR(currentBorrower, totals.price) < _100pct) {
                currentBorrower = _sortedDensCached.getPrev(currentBorrower);
            }
        }

        // Loop through the Dens starting from the one with lowest collateral ratio until _amount of debt is exchanged for collateral
        if (_maxIterations == 0) {
            _maxIterations = 100;
        }
        while (currentBorrower != address(0) && totals.remainingDebt > 0 && _maxIterations > 0) {
            _maxIterations--;
            // Save the address of the Den preceding the current one, before potentially modifying the list
            address nextUserToCheck = _sortedDensCached.getPrev(currentBorrower);

            _applyPendingRewards(currentBorrower);
            SingleRedemptionValues memory singleRedemption = _redeemCollateralFromDen(
                _sortedDensCached,
                currentBorrower,
                totals.remainingDebt,
                totals.price,
                _upperPartialRedemptionHint,
                _lowerPartialRedemptionHint,
                _partialRedemptionHintNICR
            );
            if (singleRedemption.cancelledPartial) break; // Partial redemption was cancelled (out-of-date hint, or new net debt < minimum), therefore we could not redeem from the last Den

            totals.totalDebtToRedeem = totals.totalDebtToRedeem + singleRedemption.debtLot;
            totals.totalCollateralDrawn = totals.totalCollateralDrawn + singleRedemption.collateralLot;

            totals.remainingDebt = totals.remainingDebt - singleRedemption.debtLot;
            currentBorrower = nextUserToCheck;
        }
        require(totals.totalCollateralDrawn > 0, "Unable to redeem any amount");

        // Decay the baseRate due to time passed, and then increase it according to the size of this redemption.
        // Use the saved total debt supply value, from before it was reduced by the redemption.
        // only callabe when not sunsetting
        if (!sunsetting) {
            _updateBaseRateFromRedemption(totals.totalCollateralDrawn, totals.price, totals.totalDebtSupplyAtStart);
        }

        // Calculate the collateral fee
        totals.collateralFee = sunsetting ? 0 : _calcRedemptionFee(getRedemptionRate(), totals.totalCollateralDrawn);

        _requireUserAcceptsFee(totals.collateralFee, totals.totalCollateralDrawn, _maxFeePercentage);

        _sendCollateral(BERABORROW_CORE.feeReceiver(), totals.collateralFee);

        totals.collateralToSendToRedeemer = totals.totalCollateralDrawn - totals.collateralFee;

        emit Redemption(msg.sender, _debtAmount, totals.totalDebtToRedeem, totals.totalCollateralDrawn, totals.collateralFee);

        // Burn the total debt that is cancelled with debt, and send the redeemed collateral to msg.sender
        debtToken.burn(msg.sender, totals.totalDebtToRedeem);
        // Update Den Manager debt, and send collateral to account
        totalActiveDebt = totalActiveDebt - totals.totalDebtToRedeem;
        _sendCollateral(msg.sender, totals.collateralToSendToRedeemer);
        _resetState();
    }

    // Redeem as much collateral as possible from _borrower's Den in exchange for debt up to _maxDebtAmount
    function _redeemCollateralFromDen(
        ISortedDens _sortedDensCached,
        address _borrower,
        uint256 _maxDebtAmount,
        uint256 _price,
        address _upperPartialRedemptionHint,
        address _lowerPartialRedemptionHint,
        uint256 _partialRedemptionHintNICR
    ) internal returns (SingleRedemptionValues memory singleRedemption) {
        Den storage t = Dens[_borrower];
        // Determine the remaining amount (lot) to be redeemed, capped by the entire debt of the Den minus the liquidation reserve
        singleRedemption.debtLot = BeraborrowMath._min(_maxDebtAmount, t.debt - DEBT_GAS_COMPENSATION);

        // Get the CollateralLot of equivalent value in USD
        singleRedemption.collateralLot = (singleRedemption.debtLot * DECIMAL_PRECISION) / _price;

        // Decrease the debt and collateral of the current Den according to the debt lot and corresponding collateral to send
        uint256 newDebt = (t.debt) - singleRedemption.debtLot;
        uint256 newColl = (t.coll) - singleRedemption.collateralLot;
        if (newDebt == DEBT_GAS_COMPENSATION) {
            // No debt left in the Den (except for the liquidation reserve), therefore the den gets closed
            _removeStake(_borrower);
            _closeDen(_borrower, Status.closedByRedemption);
            _redeemCloseDen(_borrower, DEBT_GAS_COMPENSATION, newColl);
            emit DenUpdated(_borrower, 0, 0, 0, DenManagerOperation.redeemCollateral);
        } else {
            uint256 newNICR = BeraborrowMath._computeNominalCR(newColl, newDebt);
            /*
             * If the provided hint is out of date, we bail since trying to reinsert without a good hint will almost
             * certainly result in running out of gas.
             *
             * If the resultant net debt of the partial is less than the minimum, net debt we bail.
             */

            {
                // We check if the ICR hint is reasonable up to date, with continuous interest there might be slight differences (<1bps)
                uint256 icrError = _partialRedemptionHintNICR > newNICR
                    ? _partialRedemptionHintNICR - newNICR
                    : newNICR - _partialRedemptionHintNICR;
                if (
                    icrError > 5e14 ||
                    _getNetDebt(newDebt) < IBorrowerOperations(borrowerOperations).minNetDebt()
                ) {
                    singleRedemption.cancelledPartial = true;
                    return singleRedemption;
                }
            }

            _sortedDensCached.reInsert(_borrower, newNICR, _upperPartialRedemptionHint, _lowerPartialRedemptionHint);

            t.debt = newDebt;
            t.coll = newColl;
            _updateStakeAndTotalStakes(t);

            emit DenUpdated(_borrower, newDebt, newColl, t.stake, DenManagerOperation.redeemCollateral);
        }
        return singleRedemption;
    }

    /*
     * Called when a full redemption occurs, and closes the den.
     * The redeemer swaps (debt - liquidation reserve) debt for (debt - liquidation reserve) worth of collateral, so the debt liquidation reserve left corresponds to the remaining debt.
     * In order to close the den, the debt liquidation reserve is burned, and the corresponding debt is removed.
     * The debt recorded on the den's struct is zero'd elswhere, in _closeDen.
     * Any surplus collateral left in the den can be later claimed by the borrower.
     */
    function _redeemCloseDen(address _borrower, uint256 _debt, uint256 _collateral) internal {
        debtToken.burn(gasPoolAddress, _debt);
        totalActiveDebt = totalActiveDebt - _debt;

        surplusBalances[_borrower] += _collateral;
        totalActiveCollateral -= _collateral;
    }

    function _isValidFirstRedemptionHint(
        ISortedDens _sortedDens,
        address _firstRedemptionHint,
        uint256 _price
    ) internal view returns (bool) {
        if (
            _firstRedemptionHint == address(0) ||
            !_sortedDens.contains(_firstRedemptionHint) ||
            getCurrentICR(_firstRedemptionHint, _price) < _100pct
        ) {
            return false;
        }

        address nextDen = _sortedDens.getNext(_firstRedemptionHint);
        return nextDen == address(0) || getCurrentICR(nextDen, _price) < _100pct;
    }

    /**
     * Claim remaining collateral from a redemption or from a liquidation with ICR > MCR in Recovery Mode
     */
    function claimCollateral(address borrower, address _receiver) external {
        if (msg.sender != collVaultRouter) {
            borrower = msg.sender;
        }
        uint256 claimableColl = surplusBalances[borrower];
        require(claimableColl > 0, "No collateral available to claim");

        surplusBalances[borrower] = 0;

        collateralToken.safeTransfer(_receiver, claimableColl);
    }

    // --- Den Adjustment functions ---

    function openDen(
        address _borrower,
        uint256 _collateralAmount,
        uint256 _compositeDebt,
        uint256 NICR,
        address _upperHint,
        address _lowerHint
    ) external whenNotPaused returns (uint256 stake, uint256 arrayIndex) {
        _requireCallerIsBO();
        require(!sunsetting, "Cannot open while sunsetting");
        _isPermissionedCheck(_borrower);

        Den storage t = Dens[_borrower];
        require(t.status != Status.active, "BorrowerOps: Den is active");
        t.status = Status.active;
        t.coll = _collateralAmount;
        t.debt = _compositeDebt;
        uint256 currentInterestIndex = _accrueActiveInterests();
        t.activeInterestIndex = currentInterestIndex;
        _updateDenRewardSnapshots(_borrower);
        stake = _updateStakeAndTotalStakes(t);
        sortedDens.insert(_borrower, NICR, _upperHint, _lowerHint);

        DenOwners.push(_borrower);
        arrayIndex = DenOwners.length - 1;
        t.arrayIndex = uint128(arrayIndex);

        totalActiveCollateral = totalActiveCollateral + _collateralAmount;
        uint256 _newTotalDebt = totalActiveDebt + _compositeDebt;
        require(_newTotalDebt + defaultedDebt <= maxSystemDebt, "Collateral debt limit reached");
        totalActiveDebt = _newTotalDebt;
    }

    function updateDenFromAdjustment(
        bool _isDebtIncrease,
        uint256 _debtChange,
        uint256 _netDebtChange,
        bool _isCollIncrease,
        uint256 _collChange,
        address _upperHint,
        address _lowerHint,
        address _borrower,
        address _receiver
    ) external returns (uint256, uint256, uint256) {
        _requireCallerIsBO();
        if (_isCollIncrease || _isDebtIncrease) {
            require(!paused, "Collateral Paused");
            require(!sunsetting, "Cannot increase while sunsetting");
        }

        Den storage t = Dens[_borrower];
        require(t.status == Status.active, "Den closed or does not exist");

        uint256 newDebt = t.debt;
        if (_debtChange > 0) {
            if (_isDebtIncrease) {
                newDebt = newDebt + _netDebtChange;
                _increaseDebt(_receiver, _netDebtChange, _debtChange);
            } else {
                newDebt = newDebt - _netDebtChange;
                _decreaseDebt(_receiver, _debtChange);
            }
            t.debt = newDebt;
        }

        uint256 newColl = t.coll;
        if (_collChange > 0) {
            if (_isCollIncrease) {
                newColl = newColl + _collChange;
                totalActiveCollateral = totalActiveCollateral + _collChange;
                // trust that BorrowerOperations sent the collateral
            } else {
                newColl = newColl - _collChange;
                _sendCollateral(_receiver, _collChange);
            }
            t.coll = newColl;
        }

        uint256 newNICR = BeraborrowMath._computeNominalCR(newColl, newDebt);
        sortedDens.reInsert(_borrower, newNICR, _upperHint, _lowerHint);

        return (newColl, newDebt, _updateStakeAndTotalStakes(t));
    }

    function closeDen(address _borrower, address _receiver, uint256 collAmount, uint256 debtAmount) external {
        _requireCallerIsBO();
        require(Dens[_borrower].status == Status.active, "Den closed or does not exist");
        _removeStake(_borrower);
        _closeDen(_borrower, Status.closedByOwner);
        totalActiveDebt = totalActiveDebt - debtAmount;
        _sendCollateral(_receiver, collAmount);
        _resetState();
    }

    /**
        @dev Only called from `closeDen` because liquidating the final den is blocked in
             `LiquidationManager`. Many liquidation paths involve redistributing debt and
             collateral to existing dens. If the collateral is being sunset, the final den
             must be closed by repaying the debt or via a redemption.
     */
    function _resetState() private {
        if (DenOwners.length == 0) {
            activeInterestIndex = INTEREST_PRECISION;
            lastActiveIndexUpdate = block.timestamp;
            totalStakes = 0;
            totalStakesSnapshot = 0;
            totalCollateralSnapshot = 0;
            L_collateral = 0;
            L_debt = 0;
            lastCollateralError_Redistribution = 0;
            lastDebtError_Redistribution = 0;
            totalActiveCollateral = 0;
            totalActiveDebt = 0;
            defaultedCollateral = 0;
            defaultedDebt = 0;
        }
    }

    function _closeDen(address _borrower, Status closedStatus) internal {
        uint256 DenOwnersArrayLength = DenOwners.length;

        Den storage t = Dens[_borrower];
        t.status = closedStatus;
        t.coll = 0;
        t.debt = 0;
        t.activeInterestIndex = 0;
        ISortedDens sortedDensCached = sortedDens;
        rewardSnapshots[_borrower].collateral = 0;
        rewardSnapshots[_borrower].debt = 0;
        if (DenOwnersArrayLength > 1 && sortedDensCached.getSize() > 1) {
            // remove den owner from the DenOwners array, not preserving array order
            uint128 index = t.arrayIndex;
            address addressToMove = DenOwners[DenOwnersArrayLength - 1];
            DenOwners[index] = addressToMove;
            Dens[addressToMove].arrayIndex = index;
            emit DenIndexUpdated(addressToMove, index);
        }

        DenOwners.pop();

        sortedDensCached.remove(_borrower);
        t.arrayIndex = 0;
    }

    // Updates the baseRate state variable based on time elapsed since the last redemption or debt borrowing operation.
    function decayBaseRateAndGetBorrowingFee(uint256 _debt) external returns (uint256) {
        _requireCallerIsBO();
        uint256 rate = _decayBaseRate();

        return _calcBorrowingFee(_calcBorrowingRate(rate), _debt);
    }

    function _decayBaseRate() internal returns (uint256) {
        uint256 decayedBaseRate = _calcDecayedBaseRate();

        baseRate = decayedBaseRate;
        emit BaseRateUpdated(decayedBaseRate);

        _updateLastFeeOpTime();

        return decayedBaseRate;
    }

    function applyPendingRewards(address _borrower) external returns (uint256 coll, uint256 debt) {
        _requireCallerIsBO();
        return _applyPendingRewards(_borrower);
    }

    // Add the borrowers's coll and debt rewards earned from redistributions, to their Den
    function _applyPendingRewards(address _borrower) internal returns (uint256 coll, uint256 debt) {
        Den storage t = Dens[_borrower];
        if (t.status == Status.active) {
            uint256 denInterestIndex = t.activeInterestIndex;
            uint256 currentInterestIndex = _accrueActiveInterests();
            debt = t.debt;
            uint256 prevDebt = debt;
            coll = t.coll;
            // We accrue interests for this den if not already updated and borrower is not BrimeDen
            if (denInterestIndex < currentInterestIndex && _borrower != brimeDen) {
                debt = (debt * currentInterestIndex) / denInterestIndex;
                t.activeInterestIndex = currentInterestIndex;
            }

            if (rewardSnapshots[_borrower].collateral < L_collateral) {
                // Compute pending rewards
                (uint256 pendingCollateralReward, uint256 pendingDebtReward) = getPendingCollAndDebtRewards(_borrower);

                // Apply pending rewards to den's state
                coll = coll + pendingCollateralReward;
                t.coll = coll;
                debt = debt + pendingDebtReward;

                _updateDenRewardSnapshots(_borrower);

                _movePendingDenRewardsToActiveBalance(pendingDebtReward, pendingCollateralReward);

                emit DenUpdated(_borrower, debt, coll, t.stake, DenManagerOperation.applyPendingRewards);
            }
            if (prevDebt != debt) {
                t.debt = debt;
            }
        }
        return (coll, debt);
    }

    function _updateDenRewardSnapshots(address _borrower) internal {
        uint256 L_collateralCached = L_collateral;
        uint256 L_debtCached = L_debt;
        rewardSnapshots[_borrower] = RewardSnapshot(L_collateralCached, L_debtCached);
        emit DenSnapshotsUpdated(L_collateralCached, L_debtCached);
    }

    // Remove borrower's stake from the totalStakes sum, and set their stake to 0
    function _removeStake(address _borrower) internal {
        uint256 stake = Dens[_borrower].stake;
        totalStakes = totalStakes - stake;
        Dens[_borrower].stake = 0;
    }

    // Update borrower's stake based on their latest collateral value
    function _updateStakeAndTotalStakes(Den storage t) internal returns (uint256) {
        uint256 newStake = _computeNewStake(t.coll);
        uint256 oldStake = t.stake;
        t.stake = newStake;
        uint256 newTotalStakes = totalStakes - oldStake + newStake;
        totalStakes = newTotalStakes;
        emit TotalStakesUpdated(newTotalStakes);

        return newStake;
    }

    // Calculate a new stake based on the snapshots of the totalStakes and totalCollateral taken at the last liquidation
    function _computeNewStake(uint256 _coll) internal view returns (uint256) {
        uint256 stake;
        uint256 totalCollateralSnapshotCached = totalCollateralSnapshot;
        if (totalCollateralSnapshotCached == 0) {
            stake = _coll;
        } else {
            /*
             * The following assert() holds true because:
             * - The system always contains >= 1 den
             * - When we close or liquidate a den, we redistribute the pending rewards, so if all dens were closed/liquidated,
             * rewards would’ve been emptied and totalCollateralSnapshot would be zero too.
             */
            uint256 totalStakesSnapshotCached = totalStakesSnapshot;
            assert(totalStakesSnapshotCached > 0);
            stake = (_coll * totalStakesSnapshotCached) / totalCollateralSnapshotCached;
        }
        return stake;
    }

    // --- Liquidation Functions ---

    function closeDenByLiquidation(address _borrower) external {
        _requireCallerIsLM();
        _removeStake(_borrower);
        _closeDen(_borrower, Status.closedByLiquidation);
    }

    function movePendingDenRewardsToActiveBalances(uint256 _debt, uint256 _collateral) external {
        _requireCallerIsLM();
        _movePendingDenRewardsToActiveBalance(_debt, _collateral);
    }

    function _movePendingDenRewardsToActiveBalance(uint256 _debt, uint256 _collateral) internal {
        defaultedDebt -= _debt;
        totalActiveDebt += _debt;
        defaultedCollateral -= _collateral;
        totalActiveCollateral += _collateral;
    }

    function addCollateralSurplus(address borrower, uint256 collSurplus) external {
        _requireCallerIsLM();
        surplusBalances[borrower] += collSurplus;
    }

    function finalizeLiquidation(
        address _liquidator,
        uint256 _debt,
        uint256 _coll,
        uint256 _collSurplus,
        uint256 _debtGasComp,
        uint256 _collGasComp
    ) external {
        _requireCallerIsLM();
        // redistribute debt and collateral
        _redistributeDebtAndColl(_debt, _coll);
        uint256 _activeColl = totalActiveCollateral;
        if (_collSurplus > 0) {
            _activeColl -= _collSurplus;
            totalActiveCollateral = _activeColl;
        }
        // update system snapshot
        totalStakesSnapshot = totalStakes;
        totalCollateralSnapshot = _activeColl + defaultedCollateral - _collGasComp;  
        emit SystemSnapshotsUpdated(totalStakesSnapshot, totalCollateralSnapshot);
        
        // Split collateral and debt compensation between liquidator, sNect guage and validator pools.
        // Send compensation tokens to liquidator
        ILiquidationManager.LiquidationFeeData memory data = ILiquidationManager(liquidationManager).liquidationsFeeAndRecipients();
        debtToken.returnFromPool(gasPoolAddress, _liquidator, _debtGasComp * data.liquidatorFee / DECIMAL_PRECISION);
        // Send compensation tokens to sNect Gauge
        debtToken.returnFromPool(gasPoolAddress, data.sNectGauge, _debtGasComp * data.sNectGaugeFee / DECIMAL_PRECISION);
        // Send compensation tokens to validator pool
        debtToken.returnFromPool(gasPoolAddress, data.validatorPool, _debtGasComp * data.poolFee / DECIMAL_PRECISION);

        _sendCollateral(_liquidator, _collGasComp * data.liquidatorFee / DECIMAL_PRECISION);
        _sendCollateral(data.sNectGauge, _collGasComp * data.sNectGaugeFee / DECIMAL_PRECISION);
        _sendCollateral(data.validatorPool, _collGasComp * data.poolFee / DECIMAL_PRECISION);
    }

    function _redistributeDebtAndColl(uint256 _debt, uint256 _coll) internal {
        if (_debt == 0) {
            return;
        }
        /*
         * Add distributed coll and debt rewards-per-unit-staked to the running totals. Division uses a "feedback"
         * error correction, to keep the cumulative error low in the running totals L_collateral and L_debt:
         *
         * 1) Form numerators which compensate for the floor division errors that occurred the last time this
         * function was called.
         * 2) Calculate "per-unit-staked" ratios.
         * 3) Multiply each ratio back by its denominator, to reveal the current floor division error.
         * 4) Store these errors for use in the next correction when this function is called.
         * 5) Note: static analysis tools complain about this "division before multiplication", however, it is intended.
         */
        uint256 collateralNumerator = (_coll * DECIMAL_PRECISION) + lastCollateralError_Redistribution;
        uint256 debtNumerator = (_debt * DECIMAL_PRECISION) + lastDebtError_Redistribution;
        uint256 totalStakesCached = totalStakes;
        // Get the per-unit-staked terms
        uint256 collateralRewardPerUnitStaked = collateralNumerator / totalStakesCached;
        uint256 debtRewardPerUnitStaked = debtNumerator / totalStakesCached;

        lastCollateralError_Redistribution = collateralNumerator - (collateralRewardPerUnitStaked * totalStakesCached);
        lastDebtError_Redistribution = debtNumerator - (debtRewardPerUnitStaked * totalStakesCached);

        // Add per-unit-staked terms to the running totals
        uint256 new_L_collateral = L_collateral + collateralRewardPerUnitStaked;
        uint256 new_L_debt = L_debt + debtRewardPerUnitStaked;
        L_collateral = new_L_collateral;
        L_debt = new_L_debt;

        emit LTermsUpdated(new_L_collateral, new_L_debt);

        totalActiveDebt -= _debt;
        defaultedDebt += _debt;
        defaultedCollateral += _coll;
        totalActiveCollateral -= _coll;
    }

    // --- Den property setters ---

    function _sendCollateral(address _account, uint256 _amount) private {
        if (_amount > 0) {
            totalActiveCollateral = totalActiveCollateral - _amount;
            emit CollateralSent(_account, _amount);

            collateralToken.safeTransfer(_account, _amount);
        }
    }

    function _increaseDebt(address account, uint256 netDebtAmount, uint256 debtAmount) internal {
        uint256 _newTotalDebt = totalActiveDebt + netDebtAmount;
        require(_newTotalDebt + defaultedDebt <= maxSystemDebt, "Collateral debt limit reached");
        totalActiveDebt = _newTotalDebt;
        debtToken.mint(account, debtAmount);
    }

    function decreaseDebtAndSendCollateral(address account, uint256 debt, uint256 coll) external {
        _requireCallerIsLM();
        _decreaseDebt(account, debt);
        _sendCollateral(account, coll);
    }

    function _decreaseDebt(address account, uint256 amount) internal {
        debtToken.burn(account, amount);
        totalActiveDebt = totalActiveDebt - amount;
    }

    // --- Balances and interest ---

    function updateBalances() external {
        _requireCallerIsLM();
        _updateBalances();
    }

    function _updateBalances() private {
        _accrueActiveInterests();
    }

    // This function must be called any time the debt or the interest changes
    function _accrueActiveInterests() internal returns (uint256) {
        (uint256 currentInterestIndex, uint256 interestFactor) = _calculateInterestIndex();
        if (interestFactor > 0) {
            uint256 currentDebt = totalActiveDebt;
            uint256 activeInterests = Math.mulDiv(currentDebt, interestFactor, INTEREST_PRECISION);
            totalActiveDebt = currentDebt + activeInterests;
            interestPayable = interestPayable + activeInterests;
            activeInterestIndex = currentInterestIndex;
            lastActiveIndexUpdate = block.timestamp;
        }
        return currentInterestIndex;
    }

    function _calculateInterestIndex() internal view returns (uint256 currentInterestIndex, uint256 interestFactor) {
        uint256 lastIndexUpdateCached = lastActiveIndexUpdate;
        // Short circuit if we updated in the current block
        if (lastIndexUpdateCached == block.timestamp) return (activeInterestIndex, 0);
        uint256 currentInterest = interestRate;
        currentInterestIndex = activeInterestIndex; // we need to return this if it's already up to date
        if (currentInterest > 0) {
            /*
             * Calculate the interest accumulated and the new index:
             * We compound the index and increase the debt accordingly
             */
            uint256 deltaT = block.timestamp - lastIndexUpdateCached;
            interestFactor = deltaT * currentInterest;
            currentInterestIndex =
                currentInterestIndex +
                Math.mulDiv(currentInterestIndex, interestFactor, INTEREST_PRECISION);
        }
    }

    // --- Requires ---

    function _requireCallerIsBO() internal view {
        require(msg.sender == borrowerOperations, "Caller not BO");
    }

    function _requireCallerIsLM() internal view {
        require(msg.sender == liquidationManager, "Not Liquidation Manager");
    }
}
