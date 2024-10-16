@AbapCatalog.sqlViewName: 'ZGSTR2B2C'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GSTR2 REPORT B2C'
define view YGSTR2_B2C_CDS
  as select from    I_OperationalAcctgDocItem as a
    left outer  join             I_OperationalAcctgDocItem as b on(
                                          b.AccountingDocument = a.AccountingDocument 
                                        and b.FinancialAccountType = 'K' and b.TaxItemAcctgDocItemRef = a.TaxItemAcctgDocItemRef 
                                        and b.AccountingDocumentType <> 'AA' and b.FinancialAccountType <> 'A'  )
    left outer join I_Supplier            as    C on ( a.Supplier = C.Supplier )
    left outer join YTAX_CODECDS          as    D on ( a.TaxCode = D.Taxcode )
    left outer join I_JournalEntry        as    E on ( a.AccountingDocument = E.AccountingDocument and E.AccountingDocumentHeaderText <> '' and E.DocumentReferenceID <> ' ' )
    left outer join I_JournalEntry        as    F on ( a.AccountingDocument = F.AccountingDocument  and  F.IsReversed <> ' ')
    left outer join I_OperationalAcctgDocItem  as G on ( G.AccountingDocument = a.AccountingDocument and G.AccountingDocumentType = 'AA' and G.FinancialAccountType = 'A' )
    left outer join I_OperationalAcctgDocItem  as h on ( h.AccountingDocument = a.AccountingDocument and G.FinancialAccountType = 'S' 
                                                        or G.FinancialAccountType = 'S'  and G.AccountingDocumentType = 'RE' 
                                                        or G.AccountingDocumentType = 'KA' or G.AccountingDocumentType = 'KR' )

{
  key a.AccountingDocument                                    as FiDocument,
  key a.FiscalYear                                            as FiscalYear,
      a.TaxItemAcctgDocItemRef                                as FiDocumentItem,
      a.AccountingDocumentItem,
      a.DocumentDate,
      a.TransactionCurrency,
      left(  a.OriginalReferenceDocument  , 10 )              as Mironumber,
      right( a.OriginalReferenceDocument  , 4 )               as MiroYear,
      a.AssignmentReference                                   as Refrence_No,
      a.AccountingDocumentType,
      a.PostingDate,
      a.CompanyCode,
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
      a.IsNegativePosting,
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
      F.IsReversed,
      F.ReversalReferenceDocument,
      G.IN_HSNOrSACCode                                        as hsnsac_code
      


}
where
           a.GLAccount != '3201000000' and  a.GLAccount != '4301400000' 
      and  (  a.TaxCode = 'G0' or  a.TaxCode = 'V0' or ( a.AccountingDocumentType = 'CP' and a.TaxCode = ' ' )
      or ( a.AccountingDocumentType = 'CR' and a.TaxCode = ' ' ) 
      or ( a.AccountingDocumentType = 'KZ' and a.TaxCode = ' ' ) or ( a.AccountingDocumentType = 'SA' and a.TaxCode = ' ' )
      or ( a.AccountingDocumentType = 'HP' and a.TaxCode = ' ' ) or ( a.AccountingDocumentType = 'HR' and a.TaxCode = ' ' )  )  
                     
       
