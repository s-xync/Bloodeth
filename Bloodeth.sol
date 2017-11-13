pragma solidity ^0.4.8;

contract Bloodeth{
    address owner;
    uint BLOODCOST;
    struct bloodBank{
        bytes16 bbname;
        uint accountBalance;
        uint apos;
        uint aneg;
        uint bpos;
        uint bneg;
        uint abpos;
        uint abneg;
        uint opos;
        uint oneg;
    }
    mapping (address => bloodBank) bloodBanks;
    address[] bbaddresses;
    event bbInfo(
        bytes16 bbname,
        uint accountBalance,
        uint apos,
        uint aneg,
        uint bpos,
        uint bneg,
        uint abpos,
        uint abneg,
        uint opos,
        uint oneg
    );
    
    event bloodCostInfo(
        uint bloodCost
    );
    
    event bloodRequestInfo(
        bytes16 bbname,
        uint bloodType
    );
    
    function Bloodeth() public{
        owner=msg.sender;
        BLOODCOST=3000;
        bloodCostInfo(BLOODCOST);
    }
    
    function getBBdetails(address _bbaddress) public constant returns(bytes16,uint,uint,uint,uint,uint,uint,uint,uint,uint){
        var tempBloodBank=bloodBanks[_bbaddress];
        return (tempBloodBank.bbname,tempBloodBank.accountBalance,tempBloodBank.apos,tempBloodBank.aneg,tempBloodBank.bpos,tempBloodBank.bneg,tempBloodBank.abpos,tempBloodBank.abneg,tempBloodBank.opos,tempBloodBank.oneg);
    }
    
    function getBBaddresses() public constant returns(address[]){
        return bbaddresses;
    }
    
    function setBloodCost(uint _bloodCost) public onlyOwner{
        if(_bloodCost>0){
            BLOODCOST=_bloodCost;
        }
        bloodCostInfo(BLOODCOST);
    }

    
    function addBloodBank(address _bbaddress,bytes16 _bbname) onlyOwner public constant returns(address[]){
        if(_bbname.length>0){
            var tempBloodBank=bloodBanks[_bbaddress];
            bbaddresses.push(_bbaddress) -1;
            tempBloodBank.bbname=_bbname;
            tempBloodBank.accountBalance=50000;
            tempBloodBank.apos=0;
            tempBloodBank.aneg=0;
            tempBloodBank.bpos=0;
            tempBloodBank.bneg=0;
            tempBloodBank.abpos=0;
            tempBloodBank.abneg=0;
            tempBloodBank.opos=0;
            tempBloodBank.oneg=0;
            bbInfo(_bbname,tempBloodBank.accountBalance,tempBloodBank.apos,tempBloodBank.aneg,tempBloodBank.bpos,tempBloodBank.bneg,tempBloodBank.abpos,tempBloodBank.abneg,tempBloodBank.opos,tempBloodBank.oneg);
            return getBBaddresses();
        }
        
    }
    
    function removeBloodBank(address _bbaddress) onlyOwner public constant returns(address[]){
        bool flag=false;
        uint index=0;
        for(uint i=0;i<bbaddresses.length;i++){
            if(bbaddresses[i]==_bbaddress){
                index=i;
                flag=true;
                break;
            }
        }
        if(flag==true){
            for(uint j = index; i<bbaddresses.length-1; i++){
                bbaddresses[j] = bbaddresses[j+1];
            }
            delete bbaddresses[bbaddresses.length-1];
            bbaddresses.length--;
            var tempBloodBank=bloodBanks[_bbaddress];
            tempBloodBank.bbname="";
            tempBloodBank.accountBalance=0;
            tempBloodBank.apos=0;
            tempBloodBank.aneg=0;
            tempBloodBank.bpos=0;
            tempBloodBank.bneg=0;
            tempBloodBank.abpos=0;
            tempBloodBank.abneg=0;
            tempBloodBank.opos=0;
            tempBloodBank.oneg=0;
        }
        return getBBaddresses();
        
    }
    
   modifier onlyOwner {
       require(msg.sender == owner);
       _;
   }
   
   modifier onlyBB {
        bool flag=false;
        for(uint i=0;i<bbaddresses.length;i++){
            if(bbaddresses[i]==msg.sender){
                flag=true;
                break;
            }
        }
        require(flag==true);
        _;
    }
    
    function addMoneyToAccount(uint _amount) public onlyBB{
        var tempBloodBank=bloodBanks[msg.sender];
        if(_amount>0){
            tempBloodBank.accountBalance+=_amount;
        }
        bbInfo(tempBloodBank.bbname,tempBloodBank.accountBalance,tempBloodBank.apos,tempBloodBank.aneg,tempBloodBank.bpos,tempBloodBank.bneg,tempBloodBank.abpos,tempBloodBank.abneg,tempBloodBank.opos,tempBloodBank.oneg);
    }
    
    function addBlood(uint _option) public onlyBB{
        var tempBloodBank=bloodBanks[msg.sender];
        if(_option>=1 && _option<=8){
            if(_option==1){
                tempBloodBank.apos+=1;
            }else if(_option==2){
                tempBloodBank.aneg+=1;
            }else if(_option==3){
                tempBloodBank.bpos+=1;
            }else if(_option==4){
                tempBloodBank.bneg+=1;
            }else if(_option==5){
                tempBloodBank.abpos+=1;
            }else if(_option==6){
                tempBloodBank.abneg+=1;
            }else if(_option==7){
                tempBloodBank.opos+=1;
            }else if(_option==8){
                tempBloodBank.oneg+=1;
            }
        }
        bbInfo(tempBloodBank.bbname,tempBloodBank.accountBalance,tempBloodBank.apos,tempBloodBank.aneg,tempBloodBank.bpos,tempBloodBank.bneg,tempBloodBank.abpos,tempBloodBank.abneg,tempBloodBank.opos,tempBloodBank.oneg);
    }
    
    function requestBlood(uint _option) public onlyBB{
        var tempBloodBank=bloodBanks[msg.sender];
        if(_option>=1 && _option<=8){
            if(_option==1){
                if(tempBloodBank.apos>0){
                    tempBloodBank.apos-=1;
                    bloodRequestInfo(tempBloodBank.bbname,1);
                }else if(tempBloodBank.aneg>0){
                    tempBloodBank.aneg-=1;
                    bloodRequestInfo(tempBloodBank.bbname,2);
                }else if(tempBloodBank.opos>0){
                    tempBloodBank.opos-=1;
                    bloodRequestInfo(tempBloodBank.bbname,7);
                }else if(tempBloodBank.oneg>0){
                    tempBloodBank.oneg-=1;
                    bloodRequestInfo(tempBloodBank.bbname,8);
                }else{
                    requestBloodFromOthers(1);
                }
            }else if(_option==2){
                if(tempBloodBank.aneg>0){
                    tempBloodBank.aneg-=1;
                    bloodRequestInfo(tempBloodBank.bbname,2);
                }else if(tempBloodBank.oneg>0){
                    tempBloodBank.oneg-=1;
                    bloodRequestInfo(tempBloodBank.bbname,8);
                }else{
                    requestBloodFromOthers(2);
                }
            }else if(_option==3){
                if(tempBloodBank.bpos>0){
                    tempBloodBank.bpos-=1;
                    bloodRequestInfo(tempBloodBank.bbname,3);
                }else if(tempBloodBank.bneg>0){
                    tempBloodBank.bneg-=1;
                    bloodRequestInfo(tempBloodBank.bbname,4);
                }else if(tempBloodBank.opos>0){
                    tempBloodBank.opos-=1;
                    bloodRequestInfo(tempBloodBank.bbname,7);
                }else if(tempBloodBank.oneg>0){
                    tempBloodBank.oneg-=1;
                    bloodRequestInfo(tempBloodBank.bbname,8);
                }else{
                    requestBloodFromOthers(3);
                }
            }else if(_option==4){
                if(tempBloodBank.bneg>0){
                    tempBloodBank.bneg-=1;
                    bloodRequestInfo(tempBloodBank.bbname,4);
                }else if(tempBloodBank.oneg>0){
                    tempBloodBank.oneg-=1;
                    bloodRequestInfo(tempBloodBank.bbname,8);
                }else{
                    requestBloodFromOthers(4);
                }
            }else if(_option==5){
                if(tempBloodBank.abpos>0){
                    tempBloodBank.abpos-=1;
                    bloodRequestInfo(tempBloodBank.bbname,5);
                }else if(tempBloodBank.abneg>0){
                    tempBloodBank.abneg-=1;
                    bloodRequestInfo(tempBloodBank.bbname,6);
                }else if(tempBloodBank.apos>0){
                    tempBloodBank.apos-=1;
                    bloodRequestInfo(tempBloodBank.bbname,1);
                }else if(tempBloodBank.aneg>0){
                    tempBloodBank.aneg-=1;
                    bloodRequestInfo(tempBloodBank.bbname,2);
                }else if(tempBloodBank.bpos>0){
                    tempBloodBank.bpos-=1;
                    bloodRequestInfo(tempBloodBank.bbname,3);
                }else if(tempBloodBank.bneg>0){
                    tempBloodBank.bneg-=1;
                    bloodRequestInfo(tempBloodBank.bbname,4);
                }else if(tempBloodBank.opos>0){
                    tempBloodBank.opos-=1;
                    bloodRequestInfo(tempBloodBank.bbname,7);
                }else if(tempBloodBank.oneg>0){
                    tempBloodBank.oneg-=1;
                    bloodRequestInfo(tempBloodBank.bbname,8);
                }else{
                    requestBloodFromOthers(5);
                }
            }else if(_option==6){
                if(tempBloodBank.abneg>0){
                    tempBloodBank.abneg-=1;
                    bloodRequestInfo(tempBloodBank.bbname,6);
                }else if(tempBloodBank.aneg>0){
                    tempBloodBank.aneg-=1;
                    bloodRequestInfo(tempBloodBank.bbname,2);
                }else if(tempBloodBank.bneg>0){
                    tempBloodBank.bneg-=1;
                    bloodRequestInfo(tempBloodBank.bbname,4);
                }else if(tempBloodBank.oneg>0){
                    tempBloodBank.oneg-=1;
                    bloodRequestInfo(tempBloodBank.bbname,8);
                }else{
                    requestBloodFromOthers(6);
                }
            }else if(_option==7){
                if(tempBloodBank.opos>0){
                    tempBloodBank.opos-=1;
                    bloodRequestInfo(tempBloodBank.bbname,7);
                }else if(tempBloodBank.oneg>0){
                    tempBloodBank.oneg-=1;
                    bloodRequestInfo(tempBloodBank.bbname,8);
                }else{
                    requestBloodFromOthers(7);
                }
            }else if(_option==8){
                if(tempBloodBank.oneg>0){
                    tempBloodBank.oneg-=1;
                    bloodRequestInfo(tempBloodBank.bbname,8);
                }else{
                    requestBloodFromOthers(8);
                }
            }
        }
    }
    
    function requestBloodFromOthers(uint _option) private onlyBB{
        var requestedBloodBank=bloodBanks[msg.sender];
        if(requestedBloodBank.accountBalance>BLOODCOST){
            for(uint i=0;i<bbaddresses.length;i++){
                address tempbbAddress=bbaddresses[i];
                var tempBloodBank=bloodBanks[tempbbAddress];
                if(_option>=1 && _option<=8){
                    if(_option==1){
                        if(tempBloodBank.apos>0){
                            tempBloodBank.apos-=1;
                            requestedBloodBank.accountBalance-=BLOODCOST;
                            tempBloodBank.accountBalance+=BLOODCOST;
                            bloodRequestInfo(tempBloodBank.bbname,1);
                            break;
                        }else if(tempBloodBank.aneg>0){
                            tempBloodBank.aneg-=1;
                            requestedBloodBank.accountBalance-=BLOODCOST;
                            tempBloodBank.accountBalance+=BLOODCOST;
                            bloodRequestInfo(tempBloodBank.bbname,2);
                            break;
                        }else if(tempBloodBank.opos>0){
                            tempBloodBank.opos-=1;
                            requestedBloodBank.accountBalance-=BLOODCOST;
                            tempBloodBank.accountBalance+=BLOODCOST;
                            bloodRequestInfo(tempBloodBank.bbname,7);
                            break;
                        }else if(tempBloodBank.oneg>0){
                            tempBloodBank.oneg-=1;
                            requestedBloodBank.accountBalance-=BLOODCOST;
                            tempBloodBank.accountBalance+=BLOODCOST;
                            bloodRequestInfo(tempBloodBank.bbname,8);
                            break;
                        }else{
                            bloodRequestInfo("XXXXXXXXXX",0);
                        }
                    }else if(_option==2){
                        if(tempBloodBank.aneg>0){
                            tempBloodBank.aneg-=1;
                            requestedBloodBank.accountBalance-=BLOODCOST;
                            tempBloodBank.accountBalance+=BLOODCOST;
                            bloodRequestInfo(tempBloodBank.bbname,2);
                            break;
                        }else if(tempBloodBank.oneg>0){
                            tempBloodBank.oneg-=1;
                            requestedBloodBank.accountBalance-=BLOODCOST;
                            tempBloodBank.accountBalance+=BLOODCOST;
                            bloodRequestInfo(tempBloodBank.bbname,8);
                            break;
                        }else{
                            bloodRequestInfo("XXXXXXXXXX",0);
                        }
                    }else if(_option==3){
                        if(tempBloodBank.bpos>0){
                            tempBloodBank.bpos-=1;
                            requestedBloodBank.accountBalance-=BLOODCOST;
                            tempBloodBank.accountBalance+=BLOODCOST;
                            bloodRequestInfo(tempBloodBank.bbname,3);
                            break;
                        }else if(tempBloodBank.bneg>0){
                            tempBloodBank.bneg-=1;
                            requestedBloodBank.accountBalance-=BLOODCOST;
                            tempBloodBank.accountBalance+=BLOODCOST;
                            bloodRequestInfo(tempBloodBank.bbname,4);
                            break;
                        }else if(tempBloodBank.opos>0){
                            tempBloodBank.opos-=1;
                            requestedBloodBank.accountBalance-=BLOODCOST;
                            tempBloodBank.accountBalance+=BLOODCOST;
                            bloodRequestInfo(tempBloodBank.bbname,7);
                            break;
                        }else if(tempBloodBank.oneg>0){
                            tempBloodBank.oneg-=1;
                            requestedBloodBank.accountBalance-=BLOODCOST;
                            tempBloodBank.accountBalance+=BLOODCOST;
                            bloodRequestInfo(tempBloodBank.bbname,8);
                            break;
                        }else{
                            bloodRequestInfo("XXXXXXXXXX",0);
                        }
                    }else if(_option==4){
                        if(tempBloodBank.bneg>0){
                            tempBloodBank.bneg-=1;
                            requestedBloodBank.accountBalance-=BLOODCOST;
                            tempBloodBank.accountBalance+=BLOODCOST;
                            bloodRequestInfo(tempBloodBank.bbname,4);
                            break;
                        }else if(tempBloodBank.oneg>0){
                            tempBloodBank.oneg-=1;
                            requestedBloodBank.accountBalance-=BLOODCOST;
                            tempBloodBank.accountBalance+=BLOODCOST;
                            bloodRequestInfo(tempBloodBank.bbname,8);
                            break;
                        }else{
                            bloodRequestInfo("XXXXXXXXXX",0);
                        }
                    }else if(_option==5){
                        if(tempBloodBank.abpos>0){
                            tempBloodBank.abpos-=1;
                            requestedBloodBank.accountBalance-=BLOODCOST;
                            tempBloodBank.accountBalance+=BLOODCOST;
                            bloodRequestInfo(tempBloodBank.bbname,5);
                            break;
                        }else if(tempBloodBank.abneg>0){
                            tempBloodBank.abneg-=1;
                            requestedBloodBank.accountBalance-=BLOODCOST;
                            tempBloodBank.accountBalance+=BLOODCOST;
                            bloodRequestInfo(tempBloodBank.bbname,6);
                            break;
                        }else if(tempBloodBank.apos>0){
                            tempBloodBank.apos-=1;
                            requestedBloodBank.accountBalance-=BLOODCOST;
                            tempBloodBank.accountBalance+=BLOODCOST;
                            bloodRequestInfo(tempBloodBank.bbname,1);
                            break;
                        }else if(tempBloodBank.aneg>0){
                            tempBloodBank.aneg-=1;
                            requestedBloodBank.accountBalance-=BLOODCOST;
                            tempBloodBank.accountBalance+=BLOODCOST;
                            bloodRequestInfo(tempBloodBank.bbname,2);
                            break;
                        }else if(tempBloodBank.bpos>0){
                            tempBloodBank.bpos-=1;
                            requestedBloodBank.accountBalance-=BLOODCOST;
                            tempBloodBank.accountBalance+=BLOODCOST;
                            bloodRequestInfo(tempBloodBank.bbname,3);
                            break;
                        }else if(tempBloodBank.bneg>0){
                            tempBloodBank.bneg-=1;
                            requestedBloodBank.accountBalance-=BLOODCOST;
                            tempBloodBank.accountBalance+=BLOODCOST;
                            bloodRequestInfo(tempBloodBank.bbname,4);
                            break;
                        }else if(tempBloodBank.opos>0){
                            tempBloodBank.opos-=1;
                            requestedBloodBank.accountBalance-=BLOODCOST;
                            tempBloodBank.accountBalance+=BLOODCOST;
                            bloodRequestInfo(tempBloodBank.bbname,7);
                            break;
                        }else if(tempBloodBank.oneg>0){
                            tempBloodBank.oneg-=1;
                            requestedBloodBank.accountBalance-=BLOODCOST;
                            tempBloodBank.accountBalance+=BLOODCOST;
                            bloodRequestInfo(tempBloodBank.bbname,8);
                            break;
                        }else{
                            bloodRequestInfo("XXXXXXXXXX",0);
                        }
                    }else if(_option==6){
                        if(tempBloodBank.abneg>0){
                            tempBloodBank.abneg-=1;
                            requestedBloodBank.accountBalance-=BLOODCOST;
                            tempBloodBank.accountBalance+=BLOODCOST;
                            bloodRequestInfo(tempBloodBank.bbname,6);
                            break;
                        }else if(tempBloodBank.aneg>0){
                            tempBloodBank.aneg-=1;
                            requestedBloodBank.accountBalance-=BLOODCOST;
                            tempBloodBank.accountBalance+=BLOODCOST;
                            bloodRequestInfo(tempBloodBank.bbname,2);
                            break;
                        }else if(tempBloodBank.bneg>0){
                            tempBloodBank.bneg-=1;
                            requestedBloodBank.accountBalance-=BLOODCOST;
                            tempBloodBank.accountBalance+=BLOODCOST;
                            bloodRequestInfo(tempBloodBank.bbname,4);
                            break;
                        }else if(tempBloodBank.oneg>0){
                            tempBloodBank.oneg-=1;
                            requestedBloodBank.accountBalance-=BLOODCOST;
                            tempBloodBank.accountBalance+=BLOODCOST;
                            bloodRequestInfo(tempBloodBank.bbname,8);
                            break;
                        }else{
                            bloodRequestInfo("XXXXXXXXXX",0);
                        }
                    }else if(_option==7){
                        if(tempBloodBank.opos>0){
                            tempBloodBank.opos-=1;
                            requestedBloodBank.accountBalance-=BLOODCOST;
                            tempBloodBank.accountBalance+=BLOODCOST;
                            bloodRequestInfo(tempBloodBank.bbname,7);
                            break;
                        }else if(tempBloodBank.oneg>0){
                            tempBloodBank.oneg-=1;
                            requestedBloodBank.accountBalance-=BLOODCOST;
                            tempBloodBank.accountBalance+=BLOODCOST;
                            bloodRequestInfo(tempBloodBank.bbname,8);
                            break;
                        }else{
                            bloodRequestInfo("XXXXXXXXXX",0);
                        }
                    }else if(_option==8){
                        if(tempBloodBank.oneg>0){
                            tempBloodBank.oneg-=1;
                            requestedBloodBank.accountBalance-=BLOODCOST;
                            tempBloodBank.accountBalance+=BLOODCOST;
                            bloodRequestInfo(tempBloodBank.bbname,8);
                            break;
                        }else{
                            bloodRequestInfo("XXXXXXXXXX",0);
                        }
                    }
                }
            }
        }
    }
}