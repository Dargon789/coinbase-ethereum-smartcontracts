// SPDX-License-Identifier: MIT
pragma solidity 0.7.6;

/// @title HotWalletBase
/// @notice Access control, pausability, initialization, and low-level ERC-20 transfer helpers.
/// @dev Compiled without ABIEncoderV2 so revert strings and low-level abi.decode/encodeWithSelector
///      use Solidity 0.7.6 legacy ABI codegen, matching the deployed bytecode.
abstract contract HotWalletBase {
    bool private _initialized;
    address private _owner;
    mapping(address => bool) private _controllers;
    address private _pauser;
    bool private _paused;

    event Initialized(address indexed initializer);
    event OwnerChanged(address indexed previousOwner, address indexed newOwner);
    event ControllerAdded(address indexed controller, address indexed owner);
    event ControllerRemoved(address indexed controller, address indexed owner);
    event PauserChanged(address indexed previousPauser, address indexed newPauser);
    event Paused(address indexed pauser);
    event Unpaused(address indexed pauser);

    modifier onlyOwner() {
        require(msg.sender == _owner, "caller is not the owner");
        _;
    }

    modifier onlyController() {
        require(_controllers[msg.sender], "caller is not a controller");
        _;
    }

    modifier onlyPauser() {
        require(msg.sender == _pauser, "caller is not the pauser");
        _;
    }

    modifier whenNotPaused() {
        require(!_paused, "contract is paused");
        _;
    }

    function initialize(address owner_, address controller_, address pauser_) external {
        require(!_initialized, "already initialized");
        _changeOwner(owner_);
        if (controller_ != address(0)) {
            _addController(controller_);
        }
        if (pauser_ != address(0)) {
            _setPauser(pauser_);
        }
        _initialized = true;
        emit Initialized(msg.sender);
    }

    function initialized() external view returns (bool) {
        return _initialized;
    }

    function owner() external view returns (address) {
        return _owner;
    }

    function isController(address account) external view returns (bool) {
        return _controllers[account];
    }

    function pauser() external view returns (address) {
        return _pauser;
    }

    function paused() external view returns (bool) {
        return _paused;
    }

    function changeOwner(address account) external onlyOwner {
        _changeOwner(account);
    }

    function addController(address account) external onlyOwner {
        _addController(account);
    }

    function removeController(address account) external onlyOwner {
        _removeController(account);
    }

    function setPauser(address account) external onlyOwner {
        _setPauser(account);
    }

    function pause() external onlyPauser {
        _paused = true;
        emit Paused(_pauser);
    }

    function unpause() external onlyPauser {
        _paused = false;
        emit Unpaused(_pauser);
    }

    function _getRevertMsg(bytes memory returnData) internal pure returns (string memory) {
        if (returnData.length < 100) return "no reason string provided";
        bytes memory sliced;
        assembly {
            sliced := add(returnData, 0x04)
        }
        return abi.decode(sliced, (string));
    }

    function _setPauser(address account) internal {
        emit PauserChanged(_pauser, account);
        _pauser = account;
    }

    function _transferERC20(address to, uint256 amount, address token, uint256 gasLimit)
        internal
        returns (bool, string memory)
    {
        bytes memory data = abi.encodeWithSelector(0xa9059cbb, to, amount);
        (bool success, bytes memory returnData) = token.call{gas: gasLimit}(data);
        if (success) {
            if (returnData.length > 0 && !abi.decode(returnData, (bool))) {
                return (false, "false returned");
            }
            return (true, "");
        }
        return (false, _getRevertMsg(returnData));
    }

    function _changeOwner(address account) internal {
        require(account != address(0), "account is the zero address");
        require(account != address(this), "account is this contract");
        emit OwnerChanged(_owner, account);
        _owner = account;
    }

    function _addController(address account) internal {
        require(account != address(0), "account is the zero address");
        require(account != address(this), "account is this contract");
        require(!_controllers[account], "account is already a controller");
        emit ControllerAdded(account, _owner);
        _controllers[account] = true;
    }

    function _removeController(address account) internal {
        require(_controllers[account], "account is not a controller");
        emit ControllerRemoved(account, _owner);
        _controllers[account] = false;
    }
}
