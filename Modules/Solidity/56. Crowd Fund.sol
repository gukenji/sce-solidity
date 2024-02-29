// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
/* Implement a crowd funding contract.

User creates a campaign to raise funds, setting start time, end time and goal (amount to raise).

Other users can pledge to the campaign. This will transfer tokens into the contract.

If the goal is reached before the campaign ends, the campaign is successful. Campaign creator can claim the funds.

Otherwise, the goal was not reached in time, users can withdraw their pledge.
*/ 

interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function allowance(
        address owner,
        address spender
    ) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Approval(address indexed owner, address indexed spender, uint256 amount);
}
contract ERC20 is IERC20 {
    uint256 public totalSupply = 1000;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance; // owner approves a spender to spend X amount
    string public name = "Test Token";
    string public symbol = "TEST";
    uint8 public decimals = 18; // how many zeros are needed to represent 1 erc20 token

    constructor() {
        balanceOf[msg.sender] = totalSupply;
    }

    function transfer(address recipient, uint256 amount)
        external
        returns (bool)
    {
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender,spender,amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount)
        external
        returns (bool)
    {
        allowance[sender][msg.sender] -= amount;
        balanceOf[sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }

    function mint(uint256 amount) external {
        // code
        balanceOf[msg.sender] += amount;
        totalSupply += amount;
        emit Transfer(address(0), msg.sender, amount);
    }

    function burn(uint256 amount) external {
        // code
        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;
        emit Transfer(msg.sender, address(0), amount);
    }
}

contract CrowdFund {
    event Launch(
        uint256 id,
        address indexed creator,
        uint256 goal,
        uint32 startAt,
        uint32 endAt
    );
    event Cancel(uint256 id);
    event Pledge(uint256 indexed id, address indexed caller, uint256 amount);
    event Unpledge(uint256 indexed id, address indexed caller, uint256 amount);
    event Claim(uint256 id);
    event Refund(uint256 id, address indexed caller, uint256 amount);

    struct Campaign {
        // Creator of campaign
        address creator;
        // Amount of tokens to raise 
        uint256 goal;
        // Total amount pledged
        uint256 pledged;
        // Timestamp of start of campaign
        uint32 startAt;
        // Timestamp of end of campaign
        uint32 endAt;
        // True if goal was reached and creator has claimed the tokens.
        bool claimed;
    }

    IERC20 public immutable token;
    // Total count of campaigns created.
    // It is also used to generate id for new campaigns.
    uint256 public count;
    // Mapping from id to Campaign
    mapping(uint256 => Campaign) public campaigns;
    // Mapping from campaign id => pledger => amount pledged
    mapping(uint256 => mapping(address => uint256)) public pledgedAmount;

    constructor(address _token) {
        token = IERC20(_token);
    }

    function launch(uint256 goal, uint32 startAt, uint32 endAt) external {
        // code
        require(startAt >= block.timestamp && startAt <= endAt, "incorrect start date");
        require(endAt <=block.timestamp + 90 days, "incorrect end date");
        count++;
        campaigns[count] = Campaign({
            creator: msg.sender,
            goal: goal,
            pledged: 0,
            startAt: startAt,
            endAt: endAt,
            claimed: false
        });
        emit Launch(count, msg.sender, goal, startAt, endAt);
    }

    function cancel(uint256 id) external {
        // code
        Campaign memory campaign = campaigns[id];
        require(msg.sender == campaign.creator, "not the creator");
        require(campaign.startAt > block.timestamp, "campaign already started");
        delete campaigns[id];
        emit Cancel(id);
    }

    function pledge(uint256 id, uint256 amount) external {
        // code
        Campaign storage campaign = campaigns[id];
        // storage because we need to update campaign struct
        require(campaign.startAt <= block.timestamp, "campaign not started");
        require(campaign.endAt >= block.timestamp, "campaign already ended");
        campaign.pledged += amount;
        pledgedAmount[id][msg.sender] += amount;
        token.transferFrom(msg.sender, address(this), amount);
        emit Pledge(id, msg.sender, amount);
    }

    function unpledge(uint256 id, uint256 amount) external {
        // code
        Campaign storage campaign = campaigns[id];
        require(campaign.endAt >= block.timestamp, "campaign already ended");
        campaign.pledged -= amount;
        pledgedAmount[id][msg.sender] -= amount;
        token.transfer(msg.sender,amount);
        emit Unpledge(id, msg.sender, amount);

    }

    function claim(uint256 id) external {
        // code
        Campaign storage campaign = campaigns[id];
        require(msg.sender == campaign.creator, "not creator");
        require(block.timestamp > campaign.endAt, "not ended");
        require(campaign.pledged >= campaign.goal, "pledged < goal");
        require(campaign.claimed == false, "campaign already claimed");
        campaign.claimed = true;
        token.transfer(msg.sender, campaign.pledged);
        emit Claim(id);
    }

    function refund(uint256 id) external {
        // code
        Campaign storage campaign = campaigns[id];
        require(block.timestamp > campaign.endAt, "not ended");
        require(campaign.pledged < campaign.goal, "pledged >= goal");
        uint bal = pledgedAmount[id][msg.sender];
        pledgedAmount[id][msg.sender] = 0 ; // resetting to prevent reentrancy effect
        token.transfer(msg.sender,bal);
        emit Refund(id, msg.sender, bal);

    }
}
