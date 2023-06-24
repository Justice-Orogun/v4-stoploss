// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {Hooks} from "@uniswap/v4-core/contracts/libraries/Hooks.sol";
import {BaseHook} from "v4-periphery/BaseHook.sol";

import {IPoolManager} from "@uniswap/v4-core/contracts/interfaces/IPoolManager.sol";
import {BalanceDelta} from "@uniswap/v4-core/contracts/types/BalanceDelta.sol";

contract StopLoss is BaseHook {
    uint256 public beforeSwapCount;
    uint256 public afterSwapCount;

    mapping(bytes32 poolId => mapping(int24 tick => mapping(bool zeroForOne => uint256 amount))) public stopLossPositions;

    constructor(IPoolManager _poolManager) BaseHook(_poolManager) {}

    function getHooksCalls() public pure override returns (Hooks.Calls memory) {
        return Hooks.Calls({
            beforeInitialize: false,
            afterInitialize: false,
            beforeModifyPosition: false,
            afterModifyPosition: false,
            beforeSwap: true,
            afterSwap: true,
            beforeDonate: false,
            afterDonate: false
        });
    }

    function beforeSwap(address, IPoolManager.PoolKey calldata, IPoolManager.SwapParams calldata)
        external
        override
        returns (bytes4)
    {
        beforeSwapCount++;
        return BaseHook.beforeSwap.selector;
    }

    function afterSwap(address, IPoolManager.PoolKey calldata, IPoolManager.SwapParams calldata, BalanceDelta)
        external
        override
        returns (bytes4)
    {
        afterSwapCount++;
        return BaseHook.afterSwap.selector;
    }

    // -- Stop Loss User Facing Functions -- //
    function placeStopLoss(
        IPoolManager.PoolKey calldata poolKey,
        int24 tickLower,
        uint256 amountIn,
        bool zeroForOne
    ) external {
    }

    // TODO: implement, is out of scope for the hackathon
    function killStopLoss() external {}
    // ------------------------------------- //
}
