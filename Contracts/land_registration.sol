pragma solidity ^0.4.18;

import "./safemath.sol";



contract land_registry {
    
    using SafeMath for uint256;

    struct Land{
        string landAddress;
        uint256 area;
        uint256 value;
    }
    
    uint256 valueMultiplier;
    
    function setValueMultiplier() public {
        valueMultiplier=1;
    }
    
    Land[] public lands;
    
    mapping(uint=>address) landToOwner;
    
    function checkLandAvailable(string _landAddress, uint _area) view returns(bool){
        
        for(uint i=0;i<lands.length;i++){
            if(keccak256(lands[i].landAddress)==keccak256(_landAddress) && lands[i].area==_area){
                return false;
            }
            else if (keccak256(lands[i].landAddress)==keccak256(_landAddress)){
                return false;
            }
        }
        
        return true;
    }
    
    function _calcVal(uint256 _area)internal view returns(uint256){
        return SafeMath.mul(_area, valueMultiplier);
    }
    
    function _createLand(string _landAddress, uint _area) internal returns(uint){
        uint id=lands.push(Land(_landAddress, _area, _calcVal(_area)))-1;
        return id;
    }
    
    function registerLand(string _landAddress, uint _area) public{
        require(checkLandAvailable(_landAddress,_area)==true);
        uint id = _createLand(_landAddress,_area);
        landToOwner[id]=msg.sender;
        
    }
    
    
    
}