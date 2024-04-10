// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;

contract BasicMath {
    function adder(uint _a, uint _b) external pure returns (uint sum, bool error){
        uint max = type(uint).max;
        uint min = type(uint).min;
        if(_a >= max || _b >= max) {
            return (0, true);
        }

        uint res = _a + _b;
        if(res <= max && res >= min) {
            return (res, false);
        } else {
            return (res, true);
        }
    }

    function subtractor(uint _a, uint _b) external pure returns (uint difference, bool error){
        if(_a >= _b) {
            uint diff = _a - _b;
            uint max = type(uint).max;
            uint min = type(uint).min;

            if(diff <= max && diff >= min) {
                return (diff, false);
            } else {
                return (diff, true);
            }
        } else {
            return (0, true);
        }
    }
}
