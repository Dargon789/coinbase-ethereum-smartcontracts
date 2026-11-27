// SPDX-License-Identifier: MIT
pragma solidity 0.7.6;
pragma experimental ABIEncoderV2;

import "./HotWalletBase.sol";

/// @title HotWallet
/// @notice Batch ETH and ERC-20 disbursement wallet with role-based access control and pause support.
contract HotWallet is HotWalletBase {
    struct Transfer {
        address to;
        uint256 amount;
    }

    struct ERC20Transfer {
        address token;
        address to;
        uint256 amount;
    }

    event ETHTransferFailed(address indexed to, uint256 amount, uint256 index, string reason);
    event ERC20TransferFailed(
        address indexed token, address indexed to, uint256 amount, uint256 index, string reason
    );

    receive() external payable {}

    function batchTransferETH(Transfer[] calldata transfers, uint256 gasLimit)
        external
        onlyController
        whenNotPaused
    {
        for (uint256 i = 0; i < transfers.length; i++) {
            Transfer calldata transfer = transfers[i];
            (bool success, bytes memory returnData) = transfer.to.call{value: transfer.amount, gas: gasLimit}("");
            if (!success) {
                if (address(this).balance < transfer.amount) {
                    emit ETHTransferFailed(transfer.to, transfer.amount, i, "transfer amount exceeds balance");
                    continue;
                }
                emit ETHTransferFailed(transfer.to, transfer.amount, i, _getRevertMsg(returnData));
            }
        }
    }

    function batchTransferERC20(address token, Transfer[] calldata transfers, uint256 gasLimit)
        external
        onlyController
        whenNotPaused
    {
        for (uint256 i = 0; i < transfers.length; i++) {
            Transfer calldata transfer = transfers[i];
            (bool success, string memory reason) = _transferERC20(transfer.to, transfer.amount, token, gasLimit);
            if (!success) {
                emit ERC20TransferFailed(token, transfer.to, transfer.amount, i, reason);
            }
        }
    }

    function batchTransferMultipleERC20(ERC20Transfer[] calldata transfers, uint256 gasLimit)
        external
        onlyController
        whenNotPaused
    {
        for (uint256 i = 0; i < transfers.length; i++) {
            ERC20Transfer calldata transfer = transfers[i];
            (bool success, string memory reason) = _transferERC20(transfer.to, transfer.amount, transfer.token, gasLimit);
            if (!success) {
                emit ERC20TransferFailed(transfer.token, transfer.to, transfer.amount, i, reason);
            }
        }
    }
}
