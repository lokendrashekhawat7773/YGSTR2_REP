@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'YGSTR2_REPORT'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZFI_sh_ygstr2 as select distinct from YGSTR2_HSN as a
   left outer join 
       I_OperationalAcctgDocItem as b on  a.FiDocument = b.AccountingDocument and
                                          a.FiDocumentItem = b.TaxItemAcctgDocItemRef
                                           and  a.CompanyCode = b.CompanyCode 
                                           and a.FiscalYear = b.FiscalYear
       
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
  //  case when b.Quantity = 0 then a.TaxableValue 
    //  else a.InvoceValue  end  as InvoceValue,
   // a.InvoceValue ,
   b.AmountInCompanyCodeCurrency  as InvoceValue,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
   a.TaxableValue,
  //b.AmountInCompanyCodeCurrency as TaxableValue,
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
    
   // @Semantics.amount.currencyCode: 'TransactionCurrency'
     // case a.TransactionCurrency
      // when  'RCMI' THEN ( A.TaxableValue ) 
       //when 'RCMS' THEN ( A.TaxableValue )
       //when 'RCMC' THEN ( A.TaxableValue)
       //ELSE
       
       
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
    where
    (
     b.AccountingDocumentType = 'KG'
     or b.AccountingDocumentType = 'KR' 
     
    ) and b.IN_HSNOrSACCode <> ''
    

 
