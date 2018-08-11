pragma solidity^0.4.18;

import "./land_registration.sol";

contract ERC20Interface {
    function totalSupply() public constant returns (uint);
    function balanceOf(address _landOwner) public constant returns (uint balance);
    function allowance(address _landOwner, address _spender) public constant returns (uint remaining);
    function transfer(address _to, uint _landId) public returns (bool success);
    function approve(address _spender, uint _landId) public returns (bool success);
    function transferFrom(address _from, address _to, uint _landId) public returns (bool success);

    event Transfer(address indexed _from, address indexed _to, string _landAddress);
    event Approval(address indexed _landOwner, address indexed _spender, string _landAddress);
}