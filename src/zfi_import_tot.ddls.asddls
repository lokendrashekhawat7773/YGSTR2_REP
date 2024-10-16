@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'YGSTR2_REPORT'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity  ZFI_IMPORT_TOT as select from ygstr_import

{
    key FiDocument,
    key FiscalYear,
    FiDocumentItem,
    DocumentDate,
    TransactionCurrency  ,
    Mironumber,
    MiroYear,
    Refrence_No,
    AccountingDocumentType,
    PostingDate,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    InvoceValue,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    TaxableValue ,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    Gross_amount,
    TaxCode,   
    @Semantics.amount.currencyCode: 'TransactionCurrency'  
  //  igst,
    sum(igst)                      as IGST,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
  //  igst1
    sum(igst1)                      as IGST1,
  /*  @Semantics.amount.currencyCode: 'TransactionCurrency'
    sum(SGST)                      as SGST,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    sum(RCMI) as rcmi, 
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    sum(RCMC) as rcmc,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    sum(RCMS) as rcms,  */
    PARTYcODE,
    PlaceofSupply,
    PartyName,
    GstIn,
    State,
    TAXRATE
  /*  TaxRate ,
    PurchasingDocument ,
    PurchasingDocumentItem ,
    Product ,
    HsnCode,
    PostingDate,  
    @Semantics.quantity.unitOfMeasure: 'BaseUnit'
    poquantity,
    BaseUnit   */
}

group by   FiDocument,
           FiscalYear,
           FiDocumentItem,         
DocumentDate,           
TransactionCurrency  ,  
Mironumber,             
MiroYear,               
Refrence_No,            
AccountingDocumentType, 
PostingDate,
InvoceValue ,
TaxableValue,
Gross_amount,
TaxCode,
/*IGST,
//CGST,
//SGST,
//RCMI,
//RCMC,
//RCMS,*/
PARTYcODE,                
PlaceofSupply,            
PartyName,                
GstIn,                    
State,                    
TAXRATE                 
/*PurchasingDocument ,      
PurchasingDocumentItem ,  
Product ,                 
HsnCode,                  
PostingDate,
poquantity,
BaseUnit                 
*/
