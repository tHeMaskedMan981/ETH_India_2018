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
    
    Land[] public lands;
    
    mapping(uint=>address) landToOwner;
    mapping(address=>uint) totalValueOfOwner;
    
    event registerLandEvent(uint id, string _landAddress, uint  _area, uint _value);
    
    function setValueMultiplier(uint _arg) public {
        valueMultiplier=_arg;
    }

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
    
    function _createLand(string _landAddress, uint _area) internal returns(uint _id, uint _value){
        uint value=_calcVal(_area);
        uint id=lands.push(Land(_landAddress, _area, value))-1;
        return (id, value) ;
    }
    
    function registerLand(string _landAddress, uint _area) public{
        require(checkLandAvailable(_landAddress,_area)==true);
        (uint id, uint value) = _createLand(_landAddress,_area);
        landToOwner[id]=msg.sender;
        totalValueOfOwner[msg.sender]=totalValueOfOwner[msg.sender].add(value);
        emit registerLandEvent(id, _landAddress, _area, value);
    }
    
    
    
}