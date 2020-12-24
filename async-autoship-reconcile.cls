List<Store__c> allStores = [SELECT Id, Store_Number__c, Country__c FROM Store__c];

Map<String, String> storeCountryMap = new Map<String, String>(); 

for (Store__c s : allStores){
    storeCountryMap.put(s.Store_Number__c,s.Country__c);
}

List<SBUX_B2B_AutoShipLine__c> allLines = [
        SELECT
                CreatedById,
                CreatedDate,
                CurrencyIsoCode,
                Id,
                IsDeleted,
                LastActivityDate,
                LastModifiedById,
                LastModifiedDate,
                LastReferencedDate,
                LastViewedDate,
                Name,
                RecordTypeId,
                SBUX_B2B_AssortmentSize__c,
                SBUX_B2B_AutoshipHeader__c,
                SBUX_B2B_ExternalID__c,
                SBUX_B2B_ItemSKU__c,
                SBUX_B2B_ItemSKU_Summary__c,
                SBUX_B2B_LineQty__c,
                SBUX_B2B_LSCategory__c,
                SBUX_B2B_Orderable_UOM__c,
                SBUX_B2B_Primary_UOM__c,
                SBUX_B2B_Primary_UOM_Qty__c,
                SBUX_B2B_SKU_Number__c,
                SBUX_B2B_StoreAttribute__c,
                SBUX_B2B_StoreAttributeValue__c,
                SystemModstamp
        FROM SBUX_B2B_AutoShipLine__c
        WHERE SBUX_B2B_AutoshipHeader__c IN ('a2S1U0000031FI8','a2S1U0000031FIm','a2S1U0000031FIr')
];

SBUX_B2B_AutoShipHeader__c originalHeader = [
        SELECT
                CreatedById,
                CreatedDate,
                CurrencyIsoCode,
                Id,
                IsDeleted,
                LastActivityDate,
                LastModifiedById,
                LastModifiedDate,
                LastReferencedDate,
                LastViewedDate,
                Name,
                OwnerId,
                SBUX_B2B_AutoshipStatus__c,
                SBUX_B2B_AutoshipType__c,
                SBUX_B2B_Description__c,
                SBUX_B2B_FirstShipDate__c,
                SBUX_B2B_FreightTerms__c,
                SBUX_B2B_LongLeadFirstShipDate__c,
                SBUX_B2B_OrderType__c,
                SBUX_B2B_PromoEnd__c,
                SBUX_B2B_PromoLaunch__c,
                SBUX_B2B_ShipPriority__c,
                SystemModstamp
        FROM SBUX_B2B_AutoShipHeader__c
        WHERE Id = 'a2S1U0000031FI8'
];

SBUX_B2B_AutoShipHeader__c newHeader = originalHeader.clone();
newHeader.SBUX_B2B_Description__c = String.valueOf(Math.random());
newHeader.SBUX_B2B_AutoshipStatus__c = 'Draft';
insert newHeader;

List<SBUX_B2B_AutoShipLine__c> linesToInsert = new List<SBUX_B2B_AutoShipLine__c>();

for (SBUX_B2B_AutoShipLine__c line : allLines){
    if (line.SBUX_B2B_StoreAttributeValue__c != null && storeCountryMap.get(line.SBUX_B2B_StoreAttributeValue__c).equalsIgnoreCase('CA')){
        SBUX_B2B_AutoShipLine__c clonedLine = line.clone();
        clonedLine.SBUX_B2B_AutoshipHeader__c = newHeader.Id;
        clonedLine.SBUX_B2B_ExternalID__c = null;
        linesToInsert.add(clonedLine);
    }
}

insert  linesToInsert;
