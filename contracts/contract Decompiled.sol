contract Decompiled {
    // Decompiled by library.dedaub.com
// 2026.08.30 05:01 UTC
// Compiled using the solidity compiler version 0.7.6

    
    // Data structures and variables inferred from the use of storage instructions
    bool _initialized; // STORAGE[0x0] bytes 0 to 0
    mapping (address => bool) _isController; // STORAGE[0x1]
    address _owner; // STORAGE[0x0] bytes 1 to 20
    address _pauser; // STORAGE[0x2] bytes 0 to 19
    bool _paused; // STORAGE[0x2] bytes 20 to 20
    
    
    // Events
    Unpaused(address);
    Paused(address);
    Initialized(address);
    PauserChanged(address, address);
    OwnerChanged(address, address);
    ControllerRemoved(address, address);
    
    function 0x1a1da075(uint256 varg0, uint256 varg1) public nonPayable { 
        require(msg.data.length - 4 >= 64);
        require(varg0 <= uint64.max);
        require(4 + varg0 + 31 < msg.data.length);
        require(varg0.length <= uint64.max);
        require(4 + varg0 + (varg0.length << 6) + 32 <= msg.data.length);
        require(_isController[msg.sender], Error('caller is not a controller'));
        require(!_paused, Error('contract is paused'));
        v0 = v1 = 0;
        while (v0 < varg0.length) {
            v2 = msg.data.length;
            assert(v0 < varg0.length);
            require((v0 << 6) + varg0.data + 32 - ((v0 << 6) + varg0.data) >= 32);
            require(varg0[v0] == address(varg0[v0]));
            v3, /* uint256 */ v4 = address(varg0[v0]).call().value(msg.data[32 + ((v0 << 6) + varg0.data)]).gas(varg1);
            if (RETURNDATASIZE() == 0) {
                v5 = v6 = 96;
            } else {
                v5 = v7 = new bytes[](RETURNDATASIZE());
                RETURNDATACOPY(v7.data, 0, RETURNDATASIZE());
            }
            if (!v3) {
                v8 = this.balance;
                if (v8 >= msg.data[32 + ((v0 << 6) + varg0.data)]) {
                    require((v0 << 6) + varg0.data + 32 - ((v0 << 6) + varg0.data) >= 32);
                    require(varg0[v0] == address(varg0[v0]));
                    if (MEM[v5] >= 100) {
                        require(MEM[v5 + 4] >= 32);
                        v9 = v10 = MEM[64];
                        require(MEM[v5 + 36] <= uint32.max + 1);
                        require(v5 + 36 + MEM[v5 + 36] + 32 <= v5 + 36 + MEM[v5 + 4]);
                        require(!((v5 + 36 + MEM[v5 + 4] < MEM[v5 + 36 + MEM[v5 + 36]] + (v5 + 36 + MEM[v5 + 36] + 32)) | (MEM[v5 + 36 + MEM[v5 + 36]] > uint32.max + 1)));
                        MEM[v10] = MEM[v5 + 36 + MEM[v5 + 36]];
                        v11 = v12 = 0;
                        while (v11 < MEM[v5 + 36 + MEM[v5 + 36]]) {
                            MEM[v11 + (32 + v10)] = MEM[v11 + (32 + (v5 + 36 + MEM[v5 + 36]))];
                            v11 += 32;
                        }
                        v13 = v14 = MEM[v5 + 36 + MEM[v5 + 36]] + (32 + v10);
                        if (0x1f & MEM[v5 + 36 + MEM[v5 + 36]]) {
                            MEM[v14 - (0x1f & MEM[v5 + 36 + MEM[v5 + 36]])] = ~((uint8.max + 1) ** (32 - (0x1f & MEM[v5 + 36 + MEM[v5 + 36]])) - 1) & MEM[v14 - (0x1f & MEM[v5 + 36 + MEM[v5 + 36]])];
                            v13 = 32 + (v14 - (0x1f & MEM[v5 + 36 + MEM[v5 + 36]]));
                        }
                        MEM[64] = v13;
                    } else {
                        v9 = 'no reason string provided';
                    }
                    v15 = v16 = 0;
                    MEM[MEM[64]] = msg.data[32 + ((v0 << 6) + varg0.data)];
                    MEM[MEM[64] + 32] = v0;
                    MEM[MEM[64] + 64] = 96;
                    MEM[MEM[64] + 96] = MEM[v9];
                    while (v15 < MEM[v9]) {
                        MEM[128 + (v15 + MEM[64])] = MEM[32 + (v15 + v9)];
                        v15 += 32;
                    }
                    if (v15 > MEM[v9]) {
                        MEM[MEM[64] + MEM[v9] + 128] = v16;
                    }
                    emit 0xdc386723e55a1ab06e0a64036ce7bb4fd1e1aea21f6def62d2d577e9d12f9dfc(address(varg0[v0]));
                } else {
                    require((v0 << 6) + varg0.data + 32 - ((v0 << 6) + varg0.data) >= 32);
                    require(varg0[v0] == address(varg0[v0]));
                    MEM[MEM[64]] = msg.data[32 + ((v0 << 6) + varg0.data)];
                    MEM[MEM[64] + 32] = v0;
                    MEM[MEM[64] + 64] = 96;
                    MEM[MEM[64] + 96] = 31;
                    MEM[MEM[64] + 128] = 'transfer amount exceeds balance';
                    emit 0xdc386723e55a1ab06e0a64036ce7bb4fd1e1aea21f6def62d2d577e9d12f9dfc(address(varg0[v0]));
                }
            }
            v0 += 1;
        }
        exit;
    }
    
    function 0x12d4(address varg0) private { 
        require(varg0, Error('account is the zero address'));
        require(this != varg0, Error('account is this contract'));
        emit OwnerChanged(_owner, varg0);
        _owner = varg0;
        return ;
    }
    
    function setPauser(address varg0) public nonPayable { 
        require(msg.data.length - 4 >= 32);
        require(msg.sender == _owner, Error('caller is not the owner'));
        emit PauserChanged(_pauser, varg0);
        _pauser = varg0;
    }
    
    function 0x1472(address varg0) private { 
        require(varg0, Error('account is the zero address'));
        require(this != varg0, Error('account is this contract'));
        require(!_isController[varg0], Error('account is already a controller'));
        emit 0x9703263c91de41f96b822b3995609acf9858ba081d151c4e7ec3398085ae326(varg0, _owner);
        _isController[varg0] = 1;
        return ;
    }
    
    function unpause() public nonPayable { 
        require(msg.sender == _pauser, Error('caller is not the pauser'));
        _paused = 0;
        emit Unpaused(_pauser);
    }
    
    function 0x45c23df2(address varg0, uint256 varg1, uint256 varg2) public nonPayable { 
        require(msg.data.length - 4 >= 96);
        require(varg1 <= uint64.max);
        require(4 + varg1 + 31 < msg.data.length);
        require(varg1.length <= uint64.max);
        require(4 + varg1 + (varg1.length << 6) + 32 <= msg.data.length);
        require(_isController[msg.sender], Error('caller is not a controller'));
        require(!_paused, Error('contract is paused'));
        v0 = v1 = 0;
        while (v0 < varg1.length) {
            v2 = msg.data.length;
            assert(v0 < varg1.length);
            require((v0 << 6) + varg1.data + 32 - ((v0 << 6) + varg1.data) >= 32);
            require(varg1[v0] == address(varg1[v0]));
            MEM[64] = MEM[64] + 100;
            v3 = v4 = MEM[64] + 32;
            v5 = v6 = MEM[64];
            while (v7 >= 32) {
                MEM[v5] = MEM[v3];
                v7 = v7 - 32;
                v5 += 32;
                v3 += 32;
            }
            MEM[v5] = MEM[v3] & ~((uint8.max + 1) ** (32 - v7) - 1) | MEM[v5] & (uint8.max + 1) ** (32 - v7) - 1;
            v8, /* uint256 */ v9, /* uint256 */ v10 = varg0.transfer(address(varg1[v0]), 0xa9059cbb00000000000000000000000000000000000000000000000000000000 | uint224(address(varg1[v0])), msg.data[32 + ((v0 << 6) + varg1.data)]).gas(varg2);
            if (RETURNDATASIZE() == 0) {
                v11 = v12 = 96;
            } else {
                v11 = v13 = new bytes[](RETURNDATASIZE());
                RETURNDATACOPY(v13.data, 0, RETURNDATASIZE());
            }
            if (!v8) {
                v14 = v15 = 0;
                if (MEM[v11] >= 100) {
                    require(MEM[v11 + 4] >= 32);
                    v16 = v17 = MEM[64];
                    require(MEM[v11 + 36] <= uint32.max + 1);
                    require(v11 + 36 + MEM[v11 + 36] + 32 <= v11 + 36 + MEM[v11 + 4]);
                    require(!((v11 + 36 + MEM[v11 + 4] < MEM[v11 + 36 + MEM[v11 + 36]] + (v11 + 36 + MEM[v11 + 36] + 32)) | (MEM[v11 + 36 + MEM[v11 + 36]] > uint32.max + 1)));
                    MEM[v17] = MEM[v11 + 36 + MEM[v11 + 36]];
                    v18 = v19 = 0;
                    while (v18 < MEM[v11 + 36 + MEM[v11 + 36]]) {
                        MEM[v18 + (32 + v17)] = MEM[v18 + (32 + (v11 + 36 + MEM[v11 + 36]))];
                        v18 += 32;
                    }
                    v20 = v21 = MEM[v11 + 36 + MEM[v11 + 36]] + (32 + v17);
                    if (0x1f & MEM[v11 + 36 + MEM[v11 + 36]]) {
                        MEM[v21 - (0x1f & MEM[v11 + 36 + MEM[v11 + 36]])] = ~((uint8.max + 1) ** (32 - (0x1f & MEM[v11 + 36 + MEM[v11 + 36]])) - 1) & MEM[v21 - (0x1f & MEM[v11 + 36 + MEM[v11 + 36]])];
                        v20 = 32 + (v21 - (0x1f & MEM[v11 + 36 + MEM[v11 + 36]]));
                    }
                    MEM[64] = v20;
                } else {
                    v16 = 'no reason string provided';
                }
            } else {
                v22 = v23 = MEM[v11] > 0;
                if (v23) {
                    require(MEM[v11] >= 32);
                    v22 = !MEM[v10];
                }
                if (!v22) {
                    v14 = 1;
                    v16 = v24 = MEM[64];
                    MEM[64] = 32 + v24;
                    MEM[v24] = 0;
                } else {
                    v14 = v25 = 0;
                    v16 = v26 = 'false returned';
                }
            }
            if (!v14) {
                require((v0 << 6) + varg1.data + 32 - ((v0 << 6) + varg1.data) >= 32);
                require(varg1[v0] == address(varg1[v0]));
                v27 = v28 = 0;
                MEM[MEM[64]] = msg.data[32 + ((v0 << 6) + varg1.data)];
                MEM[MEM[64] + 32] = v0;
                MEM[MEM[64] + 64] = 96;
                MEM[MEM[64] + 96] = MEM[v16];
                while (v27 < MEM[v16]) {
                    MEM[128 + (v27 + MEM[64])] = MEM[32 + (v27 + v16)];
                    v27 += 32;
                }
                if (v27 > MEM[v16]) {
                    MEM[MEM[64] + MEM[v16] + 128] = v28;
                }
                emit 0xb188237eb0771568342dc85d228544faf9ace28e6a2895296b14044755415146(varg0, address(varg1[v0]));
            }
            v0 += 1;
        }
        exit;
    }
    
    function paused() public nonPayable { 
        return _paused;
    }
    
    function pause() public nonPayable { 
        require(msg.sender == _pauser, Error('caller is not the pauser'));
        _paused = 1;
        emit Paused(address(0x10000000000000000000000000000000000000000 | 0xffffffffffffffffffffff00ffffffffffffffffffffffffffffffffffffffff & STORAGE[0x2]));
    }
    
    function owner() public nonPayable { 
        return _owner;
    }
    
    function pauser() public nonPayable { 
        return _pauser;
    }
    
    function changeOwner(address newOwner) public nonPayable { 
        require(msg.data.length - 4 >= 32);
        require(msg.sender == _owner, Error('caller is not the owner'));
        0x12d4(newOwner);
    }
    
    function addController(address controller) public nonPayable { 
        require(msg.data.length - 4 >= 32);
        require(msg.sender == _owner, Error('caller is not the owner'));
        0x1472(controller);
    }
    
    function isController(address _value) public nonPayable { 
        require(msg.data.length - 4 >= 32);
        return _isController[_value];
    }
    
    function initialize(address varg0, address _caller, address _account) public nonPayable { 
        require(msg.data.length - 4 >= 96);
        require(!_initialized, Error('already initialized'));
        0x12d4(varg0);
        if (_caller) {
            0x1472(_caller);
        }
        if (_account) {
            emit PauserChanged(_pauser, _account);
            _pauser = _account;
        }
        _initialized = 1;
        emit Initialized(msg.sender);
    }
    
    function 0xca350aa6(uint256 varg0, uint256 varg1) public nonPayable { 
        require(msg.data.length - 4 >= 64);
        require(varg0 <= uint64.max);
        require(4 + varg0 + 31 < msg.data.length);
        require(varg0.length <= uint64.max);
        require(4 + varg0 + varg0.length * 96 + 32 <= msg.data.length);
        require(_isController[msg.sender], Error('caller is not a controller'));
        require(!_paused, Error('contract is paused'));
        v0 = v1 = 0;
        while (v0 < varg0.length) {
            v2 = msg.data.length;
            assert(v0 < varg0.length);
            require(32 + (96 * v0 + varg0.data) + 32 - (32 + (96 * v0 + varg0.data)) >= 32);
            require(msg.data[32 + (96 * v0 + varg0.data)] == address(msg.data[32 + (96 * v0 + varg0.data)]));
            require(96 * v0 + varg0.data + 32 - (96 * v0 + varg0.data) >= 32);
            require(varg0[v0] == address(varg0[v0]));
            MEM[64] = MEM[64] + 100;
            v3 = v4 = MEM[64] + 32;
            v5 = v6 = MEM[64];
            while (v7 >= 32) {
                MEM[v5] = MEM[v3];
                v7 = v7 - 32;
                v5 += 32;
                v3 += 32;
            }
            MEM[v5] = MEM[v3] & ~((uint8.max + 1) ** (32 - v7) - 1) | MEM[v5] & (uint8.max + 1) ** (32 - v7) - 1;
            v8, /* uint256 */ v9, /* uint256 */ v10 = address(varg0[v0]).transfer(address(msg.data[32 + (96 * v0 + varg0.data)]), 0xa9059cbb00000000000000000000000000000000000000000000000000000000 | uint224(address(msg.data[32 + (96 * v0 + varg0.data)])), msg.data[96 * v0 + varg0.data + 64]).gas(varg1);
            if (RETURNDATASIZE() == 0) {
                v11 = v12 = 96;
            } else {
                v11 = v13 = new bytes[](RETURNDATASIZE());
                RETURNDATACOPY(v13.data, 0, RETURNDATASIZE());
            }
            if (!v8) {
                v14 = v15 = 0;
                if (MEM[v11] >= 100) {
                    require(MEM[v11 + 4] >= 32);
                    v16 = v17 = MEM[64];
                    require(MEM[v11 + 36] <= uint32.max + 1);
                    require(v11 + 36 + MEM[v11 + 36] + 32 <= v11 + 36 + MEM[v11 + 4]);
                    require(!((v11 + 36 + MEM[v11 + 4] < MEM[v11 + 36 + MEM[v11 + 36]] + (v11 + 36 + MEM[v11 + 36] + 32)) | (MEM[v11 + 36 + MEM[v11 + 36]] > uint32.max + 1)));
                    MEM[v17] = MEM[v11 + 36 + MEM[v11 + 36]];
                    v18 = v19 = 0;
                    while (v18 < MEM[v11 + 36 + MEM[v11 + 36]]) {
                        MEM[v18 + (32 + v17)] = MEM[v18 + (32 + (v11 + 36 + MEM[v11 + 36]))];
                        v18 += 32;
                    }
                    v20 = v21 = MEM[v11 + 36 + MEM[v11 + 36]] + (32 + v17);
                    if (0x1f & MEM[v11 + 36 + MEM[v11 + 36]]) {
                        MEM[v21 - (0x1f & MEM[v11 + 36 + MEM[v11 + 36]])] = ~((uint8.max + 1) ** (32 - (0x1f & MEM[v11 + 36 + MEM[v11 + 36]])) - 1) & MEM[v21 - (0x1f & MEM[v11 + 36 + MEM[v11 + 36]])];
                        v20 = 32 + (v21 - (0x1f & MEM[v11 + 36 + MEM[v11 + 36]]));
                    }
                    MEM[64] = v20;
                } else {
                    v16 = 'no reason string provided';
                }
            } else {
                v22 = v23 = MEM[v11] > 0;
                if (v23) {
                    require(MEM[v11] >= 32);
                    v22 = !MEM[v10];
                }
                if (!v22) {
                    v14 = 1;
                    v16 = v24 = MEM[64];
                    MEM[64] = 32 + v24;
                    MEM[v24] = 0;
                } else {
                    v14 = v25 = 0;
                    v16 = v26 = 'false returned';
                }
            }
            if (!v14) {
                require(96 * v0 + varg0.data + 64 - (96 * v0 + varg0.data + 32) >= 32);
                require(msg.data[96 * v0 + varg0.data + 32] == address(msg.data[96 * v0 + varg0.data + 32]));
                require(96 * v0 + varg0.data + 32 - (96 * v0 + varg0.data) >= 32);
                require(varg0[v0] == address(varg0[v0]));
                v27 = v28 = 0;
                MEM[MEM[64]] = msg.data[64 + (96 * v0 + varg0.data)];
                MEM[MEM[64] + 32] = v0;
                MEM[MEM[64] + 64] = 96;
                MEM[MEM[64] + 96] = MEM[v16];
                while (v27 < MEM[v16]) {
                    MEM[128 + (v27 + MEM[64])] = MEM[32 + (v27 + v16)];
                    v27 += 32;
                }
                if (v27 > MEM[v16]) {
                    MEM[MEM[64] + MEM[v16] + 128] = v28;
                }
                emit 0xb188237eb0771568342dc85d228544faf9ace28e6a2895296b14044755415146(address(varg0[v0]), address(msg.data[96 * v0 + varg0.data + 32]));
            }
            v0 += 1;
        }
        exit;
    }
    
    function removeController(address controller) public nonPayable { 
        require(msg.data.length - 4 >= 32);
        require(msg.sender == _owner, Error('caller is not the owner'));
        require(_isController[controller], Error('account is not a controller'));
        emit ControllerRemoved(controller, _owner);
        _isController[controller] = 0;
    }
    
    function receive() public payable { 
    }
    
    function initialized() public nonPayable { 
        return _initialized;
    }
    
    // Note: The function selector is not present in the original solidity code.
    // However, we display it for the sake of completeness.
    
    function __function_selector__( function_selector) public payable { 
        MEM[64] = 128;
        if (msg.data.length < 4) {
            require(!msg.data.length);
            receive();
        } else if (0x8da5cb5b > function_selector >> 224) {
            if (0x3f4ba83a > function_selector >> 224) {
                if (0x158ef93e == function_selector >> 224) {
                    initialized();
                } else if (0x1a1da075 == function_selector >> 224) {
                    0x1a1da075();
                } else {
                    require(0x2d88af4a == function_selector >> 224);
                    setPauser(address);
                }
            } else if (0x3f4ba83a == function_selector >> 224) {
                unpause();
            } else if (0x45c23df2 == function_selector >> 224) {
                0x45c23df2();
            } else if (0x5c975abb == function_selector >> 224) {
                paused();
            } else {
                require(0x8456cb59 == function_selector >> 224);
                pause();
            }
        } else if (0xb429afeb > function_selector >> 224) {
            if (0x8da5cb5b == function_selector >> 224) {
                owner();
            } else if (0x9fd0506d == function_selector >> 224) {
                pauser();
            } else if (0xa6f9dae1 == function_selector >> 224) {
                changeOwner(address);
            } else {
                require(0xa7fc7a07 == function_selector >> 224);
                addController(address);
            }
        } else if (0xb429afeb == function_selector >> 224) {
            isController(address);
        } else if (0xc0c53b8b == function_selector >> 224) {
            initialize(address,address,address);
        } else if (0xca350aa6 == function_selector >> 224) {
            0xca350aa6();
        } else {
            require(0xf6a74ed7 == function_selector >> 224);
            removeController(address);
        }
    }
}
