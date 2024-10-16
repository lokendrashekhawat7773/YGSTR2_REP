@AbapCatalog.sqlViewName: 'YGSTR_IMPORT1'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GSTR2 REPORT'
define view ygstr_import
  as select from    I_OperationalAcctgDocItem as a 
     inner join I_OperationalAcctgDocItem as b on b.CompanyCode        = a.CompanyCode
                                                and b.FiscalYear         = a.FiscalYear
                                                and b.AccountingDocument = a.AccountingDocument    
                                                and  b.FinancialAccountType = 'K'
     left outer join I_Supplier  as C on( C.Supplier = b.Supplier  ) 
     left outer join YTAX_CODECDS as D on( D.Taxcode = a.TaxCode )
     left outer join I_JournalEntry   as e on e.AccountingDocument = a.AccountingDocument


{
  key a.AccountingDocument                                    as FiDocument,
  key a.FiscalYear                                            as FiscalYear,
      a.TaxItemAcctgDocItemRef                                as FiDocumentItem,
      a.DocumentDate,
      a.TransactionCurrency,
      left(  a.OriginalReferenceDocument  , 10 )              as Mironumber,
      right( a.OriginalReferenceDocument  , 4 )               as MiroYear,
      a.AssignmentReference                                   as Refrence_No,
      a.AccountingDocumentType,
      a.PostingDate,
      a.CompanyCode,
      a.IN_HSNOrSACCode                                       as HsnCode,     
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      a.TaxBaseAmountInCoCodeCrcy                             as InvoceValue,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
    (  ( a.TaxBaseAmountInCoCodeCrcy  ) + ( a.AmountInCompanyCodeCurrency  )  )  as Gross_amount ,      
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      case a.TransactionTypeDetermination
      when  'JII' then ( a.AmountInCompanyCodeCurrency ) end as igst,
      case a.TransactionTypeDetermination
      when  'JIM' then ( a.AmountInCompanyCodeCurrency ) end as igst1,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      a.AmountInCompanyCodeCurrency as TaxableValue , 
      a.TaxCode,
      b.Supplier                                              as PARTYcODE,
      b.IN_GSTPlaceOfSupply                                   as PlaceofSupply,
      b.FinancialAccountType,
      C.SupplierName                                          as PartyName,
      C.TaxNumber3                                            as GstIn,
      C.Region                                                as State,
      C.SupplierAccountGroup                                  as SupplierGroup,
      D.gstrate      as TAXRATE,
      e.DocumentReferenceID


}
  where 
         a.AccountingDocumentItemType = 'T' and
     (   a.TaxCode = 'I1' or
         a.TaxCode = 'I2' or
         a.TaxCode = 'I3' or
         a.TaxCode = 'I4' )
   /*  a.AccountingDocumentItemType = 'T' or
  (a.FinancialAccountType = 'S'  and a.FinancialAccountType = 'K') or   
  (a.TransactionTypeDetermination = 'JIM' and a.TransactionTypeDetermination = 'JII') 
//  a.TaxCode like 'I%' */
  
  
