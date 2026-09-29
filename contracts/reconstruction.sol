// AI source reconstruction by app.dedaub.com
// 2026.03.21 00:15 UTC

pragma solidity 0.7.6;
pragma experimental ABIEncoderV2;

contract Contract {
    struct NativeTransfer {
        address to;
        uint256 amount;
    }

    struct TokenTransfer {
        address to;
        uint256 amount;
    }

    struct MixedTokenTransfer {
        address token;
        address to;
        uint256 amount;
    }

    bool private _initialized;
    mapping(address => bool) private _isController;
    address private _owner;
    address private _pauser;
    bool private _paused;

    event Unpaused(address);
    event Paused(address);
    event Initialized(address);
    event PauserChanged(address, address);
    event OwnerChanged(address, address);
    event ControllerRemoved(address, address);
    event ControllerAdded(address, address);
    event NativeTransferFailed(address indexed, uint256, uint256, string);
    event TokenTransferFailed(address indexed, address indexed, uint256, uint256, string);

    receive() external payable {}

    function _changeOwner(address newOwner) private {
        require(newOwner != address(0), "account is the zero address");
        require(newOwner != address(this), "account is this contract");
        emit OwnerChanged(_owner, newOwner);
        _owner = newOwner;
    }

    function _addController(address controller) private {
        require(controller != address(0), "account is the zero address");
        require(controller != address(this), "account is this contract");
        require(!_isController[controller], "account is already a controller");
        emit ControllerAdded(controller, _owner);
        _isController[controller] = true;
    }

    function _decodeReason(bytes memory data, string memory fallbackReason) private pure returns (string memory) {
        if (data.length >= 100) {
            bytes4 sel;
            assembly {
                sel := mload(add(data, 32))
            }
            if (sel == 0x08c379a0) {
                (, string memory reason) = abi.decode(data, (bytes4, string));
                return reason;
            }
        }
        return fallbackReason;
    }

    function initialized() public view returns (bool) {
        return _initialized;
    }

    function owner() public view returns (address) {
        return _owner;
    }

    function pauser() public view returns (address) {
        return _pauser;
    }

    function paused() public view returns (bool) {
        return _paused;
    }

    function isController(address _value) public view returns (bool) {
        return _isController[_value];
    }

    function setPauser(address varg0) public {
        require(msg.sender == _owner, "caller is not the owner");
        emit PauserChanged(_pauser, varg0);
        _pauser = varg0;
    }

    function pause() public {
        require(msg.sender == _pauser, "caller is not the pauser");
        _paused = true;
        emit Paused(_pauser);
    }

    function unpause() public {
        require(msg.sender == _pauser, "caller is not the pauser");
        _paused = false;
        emit Unpaused(_pauser);
    }

    function changeOwner(address newOwner) public {
        require(msg.sender == _owner, "caller is not the owner");
        _changeOwner(newOwner);
    }

    function addController(address controller) public {
        require(msg.sender == _owner, "caller is not the owner");
        _addController(controller);
    }

    function removeController(address controller) public {
        require(msg.sender == _owner, "caller is not the owner");
        require(_isController[controller], "account is not a controller");
        emit ControllerRemoved(controller, _owner);
        _isController[controller] = false;
    }

    function initialize(address varg0, address _caller, address _account) public {
        require(!_initialized, "already initialized");
        _changeOwner(varg0);
        if (_caller != address(0)) {
            _addController(_caller);
        }
        if (_account != address(0)) {
            emit PauserChanged(_pauser, _account);
            _pauser = _account;
        }
        _initialized = true;
        emit Initialized(msg.sender);
    }

    function batchNativeTransfer(NativeTransfer[] calldata varg0, uint256 varg1) public {
        require(_isController[msg.sender], "caller is not a controller");
        require(!_paused, "contract is paused");

        for (uint256 i = 0; i < varg0.length; i++) {
            NativeTransfer calldata t = varg0[i];
            (bool ok, bytes memory ret) = payable(t.to).call{value: t.amount, gas: varg1}("");
            if (!ok) {
                string memory reason;
                if (address(this).balance >= t.amount) {
                    reason = _decodeReason(ret, "no reason string provided");
                } else {
                    reason = "transfer amount exceeds balance";
                }
                emit NativeTransferFailed(t.to, t.amount, i, reason);
            }
        }
    }

    function batchTokenTransfer(address varg0, TokenTransfer[] calldata varg1, uint256 varg2) public {
        require(_isController[msg.sender], "caller is not a controller");
        require(!_paused, "contract is paused");

        for (uint256 i = 0; i < varg1.length; i++) {
            TokenTransfer calldata t = varg1[i];
            (bool ok, bytes memory ret) = varg0.call{gas: varg2}(abi.encodeWithSelector(0xa9059cbb, t.to, t.amount));

            bool success;
            string memory reason;
            if (!ok) {
                success = false;
                reason = _decodeReason(ret, "no reason string provided");
            } else if (ret.length == 0) {
                success = true;
            } else if (ret.length >= 32 && abi.decode(ret, (bool))) {
                success = true;
            } else {
                success = false;
                reason = "false returned";
            }

            if (!success) {
                emit TokenTransferFailed(varg0, t.to, t.amount, i, reason);
            }
        }
    }

    function batchMixedTokenTransfer(MixedTokenTransfer[] calldata varg0, uint256 varg1) public {
        require(_isController[msg.sender], "caller is not a controller");
        require(!_paused, "contract is paused");

        for (uint256 i = 0; i < varg0.length; i++) {
            MixedTokenTransfer calldata t = varg0[i];
            (bool ok, bytes memory ret) = t.token.call{gas: varg1}(abi.encodeWithSelector(0xa9059cbb, t.to, t.amount));

            bool success;
            string memory reason;
            if (!ok) {
                success = false;
                reason = _decodeReason(ret, "no reason string provided");
            } else if (ret.length == 0) {
                success = true;
            } else if (ret.length >= 32 && abi.decode(ret, (bool))) {
                success = true;
            } else {
                success = false;
                reason = "false returned";
            }

            if (!success) {
                emit TokenTransferFailed(t.token, t.to, t.amount, i, reason);
            }
        }
    }

    // 0x1a1da075
    function 0x1a1da075(NativeTransfer[] calldata varg0, uint256 varg1) external {
        batchNativeTransfer(varg0, varg1);
    }

    // 0x45c23df2
    function 0x45c23df2(address varg0, TokenTransfer[] calldata varg1, uint256 varg2) external {
        batchTokenTransfer(varg0, varg1, varg2);
    }

    // 0xca350aa6
    function 0xca350aa6(MixedTokenTransfer[] calldata varg0, uint256 varg1) external {
        batchMixedTokenTransfer(varg0, varg1);
    }
}
