// SPDX-License-Identifier: UNLICENSED
pragma solidity version ^0.8.28;

contract SecretBid {

    string goods_name;
    uint bid_deadline;

    constructor(string _goods_name, uint _bid_deadline) {
        require(
            block.timestamp < _bid_deadline,
            "Bid deadline should be in the future"
        );

        goods_name = _goods_name;
        bid_deadline = _bid_deadline;
    }

    

}
