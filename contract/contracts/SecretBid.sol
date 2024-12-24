// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

contract SecretBid {

    struct Bidder {
        uint first_bade;
        uint second_bade;
        bytes32 first_bid_hash;
        uint second_bid_price;
    }

    bytes32 public goods_name;
    uint public first_bid_deadline;
    uint public second_bid_deadline;
    address payable public goods_owner;
    bool over = false;

    mapping (address => Bidder) public bidders;
    address[] public bidderAddresses;
    
    event EndBid(address winner, uint price);

    constructor(
        bytes32 _goods_name,
        address payable _goods_owner, 
        uint _first_bid_deadline, 
        uint _second_bid_deadline
    ) {
        require(
            block.timestamp < _first_bid_deadline,
            "First bid deadline should be in the future"
        );
        require(
            block.timestamp < _second_bid_deadline,
            "Second bid deadline should be in the future"
        );

        goods_name = _goods_name;
        goods_owner = _goods_owner;
        first_bid_deadline = _first_bid_deadline;
        second_bid_deadline = _second_bid_deadline;
    }

    function firstBid(bytes32 bid_hash) public {
        require(
            block.timestamp < first_bid_deadline,
            "First bid deadline has been ended"
        );
        
        require(
            bidders[msg.sender].first_bade == 0,
            "You have bade"
        );

        bidders[msg.sender] = Bidder({
           first_bade: 1,
           second_bade: 0,
           first_bid_hash: bid_hash,
           second_bid_price: 0  
        });
    }

    function secondBid(bytes32 bid_hash) public payable {
        require(
            block.timestamp > first_bid_deadline,
            "Second bid not started"
        );
        require(
            block.timestamp < second_bid_deadline,
            "Second bid deadline has been ended"
        );

        require(
            bidders[msg.sender].second_bade == 0,
            "You have bade"
        );

        bytes32 first_bid_hash = bidders[msg.sender].first_bid_hash;
        require(
            first_bid_hash == bid_hash,
            "Your second bid hash should be equal first bid hash"
        );


        uint price = msg.value;

        bytes32 calculatedHash = keccak256(abi.encodePacked(msg.sender, price));
        require(
            calculatedHash == first_bid_hash,
            "Your second bid hash not match your price"
        );

        bidders[msg.sender].second_bid_price = price;
        bidders[msg.sender].second_bade = 1;
        bidderAddresses.push(msg.sender);
    }

    function harmmerDown() external {
        require(
            block.timestamp > second_bid_deadline,
            "The bid not ended"
        );

        require(
            over == false,
            "The bid have been ended"
        );

        uint maxPrice = 0;
        address maxPriceAddress = address(0);


        for (uint256 i = 0; i < bidderAddresses.length; i ++) {
            address bidderAddress = bidderAddresses[i];
            Bidder memory bidder = bidders[bidderAddress];
            if (bidder.second_bid_price > maxPrice) {
                maxPrice = bidder.second_bid_price;
                maxPriceAddress = bidderAddress;
            }
        }

        over = true;
        emit EndBid(maxPriceAddress, maxPrice);
        goods_owner.transfer(maxPrice);

        for (uint256 i = 0; i < bidderAddresses.length; i ++) {
            address bidderAddress = bidderAddresses[i];
            Bidder memory bidder = bidders[bidderAddress];
            if (bidderAddress != maxPriceAddress) {
                goods_owner.transfer(bidder.second_bid_price);
            }
        }

        
    }

    

}
