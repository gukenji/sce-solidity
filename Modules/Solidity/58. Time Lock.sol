// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
// TimeLock is a contract where transactions must be queued for some minimum time before it can be executed.

// It's usually used in DAO to increase transparency. Call to critical functions are restricted to time lock.

// This give users time to take action before the transaction is executed by the time lock.

// For example, TimeLock can be used to increase users' trust that the DAO will not rug pull.

// Here is the contract that will be used to test TimeLock

contract TestTimeLock {
    address public timeLock;
    bool public canExecute;
    bool public executed;

    constructor(address _timeLock) {
        timeLock = _timeLock;
    }

    fallback() external {}

    function func() external payable {
        require(msg.sender == timeLock, "not time lock"); //can only be called by timeLock contract
        require(canExecute, "cannot execute this function");
        executed = true;
    }

    function setCanExecute(bool _canExecute) external {
        canExecute = _canExecute;
    }

    function getTimestamp() external view returns (uint) {
        return block.timestamp +100;
    }
}
// =================================================================================
contract TimeLock {
    error NotOwnerError();
    error AlreadyQueuedError(bytes32 txId);
    error TimestampNotInRangeError(uint256 blockTimestamp, uint256 timestamp);
    error NotQueuedError(bytes32 txId);
    error TimestampNotPassedError(uint256 blockTimestmap, uint256 timestamp);
    error TimestampExpiredError(uint256 blockTimestamp, uint256 expiresAt);
    error TxFailedError();

    event Queue(
        bytes32 indexed txId,
        address indexed target,
        uint256 value,
        string func,
        bytes data,
        uint256 timestamp
    );
    event Execute(
        bytes32 indexed txId,
        address indexed target,
        uint256 value,
        string func,
        bytes data,
        uint256 timestamp
    );
    event Cancel(bytes32 indexed txId);

    uint256 public constant MIN_DELAY = 10; // seconds
    uint256 public constant MAX_DELAY = 1000; // seconds
    uint256 public constant GRACE_PERIOD = 1000; // seconds

    address public owner;
    // tx id => queued
    mapping(bytes32 => bool) public queued;

    modifier onlyOwner() {
        if (msg.sender != owner) {
            revert NotOwnerError();
        }
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    receive() external payable {}

    function getTxId(
        address target,
        uint256 value,
        string calldata func,
        bytes calldata data,
        uint256 timestamp
    ) public pure returns (bytes32) {
        return keccak256(abi.encode(target, value, func, data, timestamp));
    }

    /**
     * @param target Address of contract or account to call
     * @param value Amount of ETH to send
     * @param func Function signature, for example "foo(address,uint256)"
     * @param data ABI encoded data send.
     * @param timestamp Timestamp after which the transaction can be executed.
     */
    function queue(
        address target,
        uint256 value,
        string calldata func,
        bytes calldata data,
        uint256 timestamp
    ) external onlyOwner returns (bytes32 txId)  {
        // code
        // create tx id
        txId = getTxId(target, value, func, data, timestamp);
        // check tx id unique
        if (queued[txId]) {
            revert AlreadyQueuedError(txId);
        }
        // check timestamp
        // - - - | - - - - - - - - - | ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ | - - - - - - - - - 
        //     block            block + min                  block + max
        if (timestamp < block.timestamp + MIN_DELAY || timestamp > block.timestamp + MAX_DELAY) {
            revert TimestampNotInRangeError(block.timestamp, timestamp);
        }
        // queueTx
        queued[txId] = true;
        emit Queue(txId, target, value, func, data, timestamp);
    }

    function execute(
        address target,
        uint256 value,
        string calldata func,
        bytes calldata data,
        uint256 timestamp
    ) external payable onlyOwner returns (bytes memory) {
        // code
        bytes32 txId = getTxId(target, value, func, data, timestamp);
        // check if tx is queued
        if (!queued[txId]) {
            revert NotQueuedError(txId);
        }
        //check block.timestamp > timestamp
        if (block.timestamp < timestamp) {
            revert TimestampNotPassedError(block.timestamp, timestamp);
        }
        // - - - - - - -  |  ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~  | - - - - - - - - - - - - - - - - 
        //             timestamp            timestamp + grace period
        if (block.timestamp > timestamp + GRACE_PERIOD) {
            revert TimestampExpiredError(block.timestamp, timestamp + GRACE_PERIOD);
        }
        
        queued[txId] = false;

        bytes memory d;
        if (bytes(func).length > 0 ) { // if we have some function
            // d = func selector + data
            d = abi.encodePacked(bytes4(keccak256(bytes(func))), data);

        } else {
            d = data;
        }
        // execute the tx
        (bool success, bytes memory res) = target.call{value: value}(d);
        if (!success) {
            revert TxFailedError();
        }
        emit Execute(txId, target, value, func, data , timestamp);
        return res;

    }

    function cancel(bytes32 txId) external onlyOwner {
        // code
        if (!queued[txId]) {
            revert NotQueuedError(txId);
        }
        queued[txId] = false;
        emit Cancel(txId);

    }
}
