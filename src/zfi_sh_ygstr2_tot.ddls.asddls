@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'YGSTR2_REPORT'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity  zfi_sh_ygstr2_tot as select from ZFI_sh_ygstr2

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
     @Semantics.amount.currencyCode: 'TransactionCurrency'
  //  case when b.Quantity = 0 then a.TaxableValue 
    //  else a.InvoceValue  end  as InvoceValue,
   // a.InvoceValue ,
    InvoceValue,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
   TaxableValue as
   TaxableValue,
  //b.AmountInCompanyCodeCurrency as TaxableValue,
   @Semantics.amount.currencyCode: 'TransactionCurrency'
    Gross_amount,
    TaxCode,   
   @Semantics.amount.currencyCode: 'TransactionCurrency'  
    sum(IGST)                       as IGST,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    sum(CGST)                      as CGST,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    sum(SGST)                      as SGST,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    sum(RCMI) as RCMI,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    sum(RCMC) as RCMC,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    sum(RCMS) as RCMS,
    PARTYcODE,
    PlaceofSupply,
    PartyName,
    GstIn,
    State,
    TaxRate ,
    PurchasingDocument ,
    PurchasingDocumentItem ,
    Product ,
    HsnCode,
    PostingDate,
    
//     ,
//   @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'   
   @Semantics.quantity.unitOfMeasure: 'BaseUnit'
    poquantity,
    BaseUnit
   } group by FiDocument, FiscalYear,
    FiDocumentItem,
    DocumentDate,
    TransactionCurrency  ,
    Mironumber,
    MiroYear,
    Refrence_No,
    AccountingDocumentType,InvoceValue,TaxableValue,Gross_amount,
        TaxCode,   
        PARTYcODE,
    PlaceofSupply,
    PartyName,
    GstIn,
    State,
    TaxRate ,
    PurchasingDocument ,
    PurchasingDocumentItem ,
    Product ,
    HsnCode,
    PostingDate,
    poquantity,
    BaseUnit
    
