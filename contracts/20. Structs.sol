// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

contract Structs {
    struct Car {
        string model;
        uint year;
        address owner;
    }

    Car public car;
    Car[] public cars;
    mapping(address => Car[]) public carsByOwner;

    function examples() external {
        Car memory toyota = Car("toyota", 1990, msg.sender);

        Car memory lambo = Car({model:"lamborghini", year: 1980, owner: msg.sender});

        Car memory tesla;
        tesla.model = "tesla";
        tesla.year = 1910;
        tesla.owner = msg.sender;


        cars.push(toyota);
        cars.push(lambo);
        cars.push(tesla);

        cars.push(Car("Ferrari", 1920, msg.sender));

        Car storage _car = cars[0];
        _car.year = 1930;

        delete _car.owner;
        delete cars[1];
    }
}