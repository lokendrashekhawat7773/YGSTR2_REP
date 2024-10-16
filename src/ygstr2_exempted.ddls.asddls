//@AbapCatalog.viewEnhancementCategory: [#NONE]
//@AccessControl.authorizationCheck: #NOT_REQUIRED
//@EndUserText.label: 'Exempted or Cash Documents'
//@Metadata.ignorePropagatedAnnotations: true
//@ObjectModel.usageType:{
//    serviceQuality: #X,
//    sizeCategory: #S,
//    dataClass: #MIXED
//}
@AbapCatalog.sqlViewName: 'ZGSTR21'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Exempted or Cash Documents'

define view  YGSTR2_EXEMPTED as select from I_OperationalAcctgDocItem as a

    inner join  I_OperationalAcctgDocItem as    b on( b.AccountingDocument = a.AccountingDocument 
                                                      and a.CompanyCode = b.CompanyCode and a.FiscalYear = b.FiscalYear
                                                      and ( a.GLAccount <> '0040503170' 
                                                      and   a.GLAccount <> '0030100090'
                                                      and   a.GLAccount <> '0030000030' ) )

    left outer join YGSTR2_EXEMPTED_SUP   as    C on ( b.AccountingDocument = C.AccountingDocument and b.FiscalYear = a.FiscalYear )

    left outer join YTAX_CODECDS          as    D on ( a.TaxCode = D.Taxcode )
    inner join I_JournalEntry             as    E on ( a.AccountingDocument = E.AccountingDocument and a.FiscalYear = E.FiscalYear 
                                                      and a.CompanyCode = E.CompanyCode  )
    left outer join I_JournalEntry        as    F on ( a.AccountingDocument = F.AccountingDocument // and  F.IsReversed <> '' 
                                                      and a.CompanyCode = F.CompanyCode and a.FiscalYear = F.FiscalYear  )
                                                      
    left outer join I_JournalEntry        as    G on ( a.AccountingDocument = G.AccountingDocument // and  G.IsReversal <> '' 
                                                      and a.CompanyCode = G.CompanyCode and a.FiscalYear = G.FiscalYear) 
    inner join I_BusinessUserBasic        as    t on ( t.UserID = E.AccountingDocCreatedByUser )    
                                                                                                   
{
  key a.AccountingDocument                                    as FiDocument,
  key a.FiscalYear                                            as FiscalYear,
      a.TaxItemAcctgDocItemRef                                as FiDocumentItem,
      a.AccountingDocumentItem,                                
      a.DocumentDate,
      a.ProfitCenter,
      a.TransactionCurrency,
      left(  a.OriginalReferenceDocument  , 10 )              as Mironumber,
      right( a.OriginalReferenceDocument  , 4 )               as MiroYear,
      a.AssignmentReference                                   as Refrence_No,
      a.AccountingDocumentType,
      a.PostingDate,
      a.CompanyCode,
      a.TransactionTypeDetermination,
      a.IN_HSNOrSACCode                                       as HsnCode,
      a.GLAccount,
      b.AssignmentReference ,
      
     @Semantics.amount.currencyCode: 'TransactionCurrency'
      a.TaxBaseAmountInCoCodeCrcy                             as InvoceValue,
     @Semantics.amount.currencyCode: 'TransactionCurrency' 
      a.TaxBaseAmountInCoCodeCrcy                             as TaxableValue,
     @Semantics.amount.currencyCode: 'TransactionCurrency' 
      a.AmountInCompanyCodeCurrency                           as Gross_amount,
      
      C.Supplier                                              as PARTYcODE,
      b.IN_GSTPlaceOfSupply                                   as PlaceofSupply,
      a.FinancialAccountType,
      C.IN_GSTSupplierClassification,
      C.SupplierName                                          as PartyName,
      C.SupplierFullName                                      as PartyAdd,
      C.TaxNumber3                                            as GstIn,
      C.Region                                                as State,
       
      D.gstrate as TaxRate,
      D.Taxcodedescription,
      E.AccountingDocumentHeaderText,
      E.DocumentReferenceID,
      F.IsReversed,
      F.ReversalReferenceDocument,
      G.IsReversal,
      a.BusinessPlace,
      a.BaseUnit,
     @Aggregation.default: #SUM
     @Semantics: { quantity : {unitOfMeasure: 'BaseUnit'} }
      a.Quantity,      
      E.AccountingDocCreatedByUser,
      t.PersonFullName,
      a.TaxCode
     
}
//where ( (  a.GLAccount <> '0040503170'  or  a.GLAccount <> '0030100090' ) 
   where ( a.AccountingDocumentType =  'RE' 
     or a.AccountingDocumentType =  'KR'
     or a.AccountingDocumentType =  'KG'
     or a.AccountingDocumentType =  'SK' )            
    and ( a.TaxCode = 'V0' and a.FinancialAccountType = 'S' and a.DebitCreditCode = 'S' )
//    )

 