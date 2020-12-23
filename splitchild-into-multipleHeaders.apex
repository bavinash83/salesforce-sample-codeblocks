List<SBUX_B2B_AutoShipLine__c> allLines = [SELECT Id 
                                           FROM SBUX_B2B_AutoShipLine__c W
                                           HERE SBUX_B2B_AutoshipHeader__c = '<headerId>' 
                                           ORDER BY SBUX_B2B_StoreAttributeValue__c];

SBUX_B2B_AutoShipHeader__c newHeader = new SBUX_B2B_AutoShipHeader__c(Id='newHeaderID');
Integer storesToMove = 10;

List<SBUX_B2B_AutoShipLine__c> linesToUpdate = new List<SBUX_B2B_AutoShipLine__c>();
List<String> storesMoved = new List<String>();

for (SBUX_B2B_AutoShipLine__c line : allLines) {
    if (storesMoved.contains(line.SBUX_B2B_StoreAttributeValue__c)){
        line.SBUX_B2B_AutoshipHeader__c = newHeader.id;
        linesToUpdate.add(line);
    } else if (storesMoved.size() < storesToMove){
        storesMoved.add(line.SBUX_B2B_StoreAttributeValue__c);
        line.SBUX_B2B_AutoshipHeader__c = newHeader.id;
        linesToUpdate.add(line);
    } else {
        break;
    }
}

update linesToUpdate;
