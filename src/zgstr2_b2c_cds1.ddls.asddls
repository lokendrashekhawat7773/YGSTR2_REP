@AbapCatalog.sqlViewName: 'ZGSTR2B2C1'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GSTR2 REPORT B2C'
define view ZGSTR2_B2C_CDS1  as select from    I_OperationalAcctgDocItem as a
    inner join             I_OperationalAcctgDocItem as b on(
                                          b.AccountingDocument = a.AccountingDocument 
                                                    and b.FinancialAccountType = 'K' and b.TaxItemAcctgDocItemRef = a.TaxItemAcctgDocItemRef 
                                                    and b.AccountingDocumentType <> 'AA' and b.FinancialAccountType <> 'A' 
                                                     and b.FiscalYear = a.FiscalYear and a.CompanyCode = b.CompanyCode and b.GLAccount <> '40503170' )
    left outer join I_Supplier            as    C on ( a.Supplier = C.Supplier  )                                                      
    left outer join YTAX_CODECDS          as    D on ( a.TaxCode = D.Taxcode )
    left outer join I_JournalEntry        as    E on ( a.AccountingDocument = E.AccountingDocument //and E.AccountingDocumentHeaderText <> '' 
                                                     and a.FiscalYear = E.FiscalYear and a.CompanyCode = E.CompanyCode and E.DocumentReferenceID <> ' ' )
    left outer join I_JournalEntry        as    F on ( a.AccountingDocument = F.AccountingDocument  and  F.IsReversed = ' ' 
                                                      and a.CompanyCode = F.CompanyCode and a.FiscalYear = F.FiscalYear)
    left outer  join  I_OperationalAcctgDocItem  as G on ( G.AccountingDocument = a.AccountingDocument //and G.AccountingDocumentType = 'AA' 
                                                      and a.FiscalYear = G.FiscalYear and G.FinancialAccountType = 'A' 
                                                      and a.CompanyCode = G.CompanyCode )
                                                     
    left outer join I_OperationalAcctgDocItem  as h on ( h.AccountingDocument = a.AccountingDocument and h.FinancialAccountType = 'S' 
//                                                      and h.AccountingDocumentType = 'RE' or h.AccountingDocumentType = 'KG'
//                                                   or h.AccountingDocumentType = 'KA' or h.AccountingDocumentType = 'KR'
                                                     and h.CompanyCode = a.CompanyCode and h.FiscalYear = a.FiscalYear )
    inner join I_BusinessUserBasic as t on ( t.UserID = E.AccountingDocCreatedByUser )

{
  key a.AccountingDocument                                    as FiDocument,
  key a.FiscalYear                                            as FiscalYear,
      a.TaxItemAcctgDocItemRef                                as FiDocumentItem,
      a.AccountingDocumentItem,                               
      a.DocumentDate,
      a.TransactionCurrency,
      a.GLAccount,
      left(  a.OriginalReferenceDocument  , 10 )              as Mironumber,
      right( a.OriginalReferenceDocument  , 4 )               as MiroYear,
      a.AssignmentReference                                   as Refrence_No,
      a.AccountingDocumentType,
      a.PostingDate,
      a.CompanyCode,
      a.BusinessPlace,
      a.TransactionTypeDetermination,
      a.IN_HSNOrSACCode                                       as HsnCode,
      a.AssignmentReference ,
   
     @Semantics.amount.currencyCode: 'TransactionCurrency'
     case G.FinancialAccountType when 'A' then
      ( G.AmountInCompanyCodeCurrency  ) else
      ( b.AmountInCompanyCodeCurrency  ) end as InvoceValue,
      
       @Semantics.amount.currencyCode: 'TransactionCurrency'
     ( b.WithholdingTaxAmount ) as TAXAMOUNT,
     
     
     
      a.TaxCode,
      a.IsNegativePosting as NEGITIVE ,
      a.Supplier                                              as PARTYcODE,
      a.IN_GSTPlaceOfSupply                                   as PlaceofSupply,
      a.FinancialAccountType,
      C.IN_GSTSupplierClassification,
      C.SupplierName                                          as PartyName,
      C.TaxNumber3                                            as GstIn,
      C.Region                                                as State,
      
      D.gstrate as TaxRate,
      D.Taxcodedescription,
      E.AccountingDocumentHeaderText,
      E.DocumentReferenceID,
      case when  F.ReversalReferenceDocument is not null then 'X'
      else
      F.IsReversed end as  IsReversed,
     // F.IsReversed,
      F.ReversalReferenceDocument,
      h.IN_HSNOrSACCode                                       as HSNSAC_CODE,
      E.AccountingDocCreatedByUser,
      t.PersonFullName
      


}
 where  C.IN_GSTSupplierClassification = '0' and a.AccountingDocumentType != 'KZ'
  and (    h.AccountingDocumentType = 'RE' 
        or h.AccountingDocumentType = 'KG'  
        or h.AccountingDocumentType = 'KR' ) //or h.AccountingDocumentType = 'KA' 
  and ( F.IsReversed != 'X' or F.IsReversal != 'X' ) and b.GLAccount != '40503170'


//  a.TaxCode = 'Z1' or a.TaxCode = 'Z2'or a.TaxCode = 'Z3'
//  or a.TaxCode = 'Z4' or a.TaxCode = 'ZA' or a.TaxCode = 'ZB'
//  or a.TaxCode = 'ZC'or a.TaxCode = 'ZD' 
//           a.GLAccount != '3201000000' and  a.GLAccount != '4301400000' 
//      and  (  a.TaxCode = 'G0' or  a.TaxCode = 'V0' 
//      or ( a.AccountingDocumentType = 'CP' and a.TaxCode = ' ' )
//      or ( a.AccountingDocumentType = 'CR' and a.TaxCode = ' ' ) 
//      or ( a.AccountingDocumentType = 'SA' and a.TaxCode = ' ' )
//      or ( a.AccountingDocumentType = 'HP' and a.TaxCode = ' ' ) 
//      or ( a.AccountingDocumentType = 'HR' and a.TaxCode = ' ' )  )  
                     
       
