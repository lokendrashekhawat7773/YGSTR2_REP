@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'YGSTR2_RCM_CDS'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity  ygstr2_rcm_cds as select distinct from 
 YGSTR2_HSN as a inner join 
       I_OperationalAcctgDocItem as b on a.FiDocumentItem = b.TaxItemAcctgDocItemRef and a.FiDocument = b.AccountingDocument
//       and b.PurchasingDocument is not initial  
     inner join zfi_sh_ygstr2_tot as C on C.HsnCode = b.IN_HSNOrSACCode 

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
     a.igst                      as IGST,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    a.cgst                      as CGST,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    a.Sgst                      as SGST,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
     a.RCM_igst                 as RCMI,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    a.RCM_cgst                   as RCMC,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    a.RCM_Sgst                   as RCMS,
              
       
       
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
 
