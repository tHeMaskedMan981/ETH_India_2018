pragma solidity^0.4.18;

import "./erc20_token.sol";
import "./land_registration.sol";
contract landTransactions is land_registry, ERC20Interface{
    mapping (uint => address) landApprovals;
    
    function totalSupply() public constant returns (uint){
        
    }
    
    function balanceOf(address _landOwner) public constant returns (uint _balance){
        return totalValueOfOwner[_landOwner];
    }
    
    function _transfer(address _from, address _to, uint _landId) private {
        totalValueOfOwner[_to]=totalValueOfOwner[_to].add(lands[_landId].value);
        totalValueOfOwner[_from]=totalValueOfOwner[_from].sub(lands[_landId].value);
        landToOwner[_landId]=_to;
        
        emit Transfer(_from, _to, lands[_landId].landAddress);
    }
    
    function transfer(address _to, uint _landId) public returns(bool){
        _transfer(msg.sender, _to, _landId);
        return true;
    }
    
    function approve(address _to, uint _landId) public returns (bool success){
        landApprovals[_landId]=_to;
        emit Approval(msg.sender, _to, lands[_landId].landAddress);
        return true;
    }
    
    function transferFrom(address _from, address _to, uint _landId) public returns (bool success){
        require(landApprovals[_landId]==_to);
        _transfer(_from, _to, _landId);
        
        return true;
    }
    
    
    
}
