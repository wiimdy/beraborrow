// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Counter} from "../src/Counter.sol";
import {IMetaBeraborrowCore} from "src/interfaces/core/IMetaBeraborrowCore.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IDebtToken} from "src/interfaces/core/IDebtToken.sol";

contract CounterTest is Test {
    Counter public counter;

    function setUp() public {
        counter = new Counter();
        counter.setNumber(0);
    }

    function test_Increment() public {
        counter.increment();
        assertEq(counter.number(), 1);
    }
    function test_getPeripheryFlashLoanFee() public {
        uint16 newFee = 1; // 0.05% --> 0.01%
        address periphery = makeAddr("periphery");

        IMetaBeraborrowCore metaBeraborrowCore = IMetaBeraborrowCore(
            0x27393e8a6f8f2e32B870903279999C820E984DC7
        ); // 실제 주소로 설정 필요
        address owner = metaBeraborrowCore.owner();
        address nectarToken = (metaBeraborrowCore.nect()); // nect 토큰 주소 가져오기

        vm.prank(owner);
        metaBeraborrowCore.setPeripheryFlashLoanFee(periphery, newFee, true);

        vm.prank(periphery);
        uint fee = IDebtToken((nectarToken)).flashFee((nectarToken), 1e4);

        assertEq(fee, 5);
    }
    function testFuzz_SetNumber(uint256 x) public {
        counter.setNumber(x);
        assertEq(counter.number(), x);
    }
}
