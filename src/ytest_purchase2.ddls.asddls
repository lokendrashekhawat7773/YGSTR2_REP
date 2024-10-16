@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'YGSTR2_REPORT'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity YTEST_PURCHASE2 as select from YTEST_PUR1 as a inner join 
       I_OperationalAcctgDocItem as b on a.FiDocumentItem = b.TaxItemAcctgDocItemRef and a.FiDocument = b.AccountingDocument
       and b.PurchasingDocument is not initial  

{
    key a.FiDocument,
    key a.FiscalYear,
    a.FiDocumentItem,
    a.DocumentDate,
    a.TransactionCurrency  ,
    a.Mironumber,
    a.MiroYear,
    a.Refrence_No,
    a.AccountingDocumentType,
     @Semantics.amount.currencyCode: 'TransactionCurrency'
    a.InvoceValue ,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    a.TaxableValue,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    a.Gross_amount,
    a.TaxCode,   
   @Semantics.amount.currencyCode: 'TransactionCurrency'  
     sum(a.igst)                      as IGST,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    sum(a.cgst)                      as CGST,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    sum(a.Sgst)                      as SGST,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
     sum(a.RCM_igst)                 as RCMI,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    sum(a.RCM_cgst)                   as RCMC,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    sum(a.RCM_Sgst)                   as RCMS,
    a.PARTYcODE,
    a.PlaceofSupply,
    a.PartyName,
    a.GstIn,
    a.State,
    a.TaxRate ,
    b.PurchasingDocument ,
    b.PurchasingDocumentItem ,
    b.Product ,
    b.IN_HSNOrSACCode as HsnCode,
    b.PostingDate,
    
//     ,
//   @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'   
   @Semantics.quantity.unitOfMeasure: 'BaseUnit'
    b.Quantity as poquantity,
    b.BaseUnit
    
}
  group by
  
    a.FiDocument,
    a.FiscalYear,
    a.FiDocumentItem,
    a.DocumentDate,
    a.TransactionCurrency  ,
    a.Mironumber,
    a.MiroYear,
    a.Refrence_No,
    a.AccountingDocumentType,
    a.InvoceValue ,
    a.TaxableValue,
    a.Gross_amount,
    a.TaxCode, 
    a.PARTYcODE,
    a.PlaceofSupply,
    a.PartyName,
    a.GstIn,
    a.State,
    a.TaxRate ,
    b.PurchasingDocument ,
    b.PurchasingDocumentItem ,
    b.Product ,
    b.IN_HSNOrSACCode ,
    b.PostingDate,
    b.Quantity ,
    b.BaseUnit
 
