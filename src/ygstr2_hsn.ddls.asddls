@AbapCatalog.sqlViewName: 'ZGSTR2_HSN'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GSTR2 REPORT'
define view YGSTR2_HSN
  as select distinct from    I_OperationalAcctgDocItem as a
    inner join      I_OperationalAcctgDocItem as b on(
                                          b.AccountingDocument = a.AccountingDocument
                                      and b.FinancialAccountType = 'K'  )
    left outer join I_Supplier            as    C on ( b.Supplier = C.Supplier )
    left outer join YTAX_CODECDS          as    D on ( a.TaxCode = D.Taxcode )
    left outer join I_JournalEntry        as    E on ( a.AccountingDocument = E.AccountingDocument )


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
      b.AssignmentReference ,
      
     
    //  a.TaxBaseAmountInCoCodeCrcy                             as InvoceValue,
     
      //@Semantics.amount.currencyCode: 'TransactionCurrency'
      //  case a.TransactionTypeDetermination
      // when  'JRI' then ( a.TaxBaseAmountInCoCodeCrcy   )
      // when  'JRC' then ( a.TaxBaseAmountInCoCodeCrcy    )
      // when  'JRS' then ( a.TaxBaseAmountInCoCodeCrcy   )
      // else
      ( a.TaxBaseAmountInCoCodeCrcy )    as InvoceValue,
      
  // @Semantics.amount.currencyCode: 'TransactionCurrency'
    // case a.TransactionTypeDetermination
   //  when  'JIC' then ( a.AmountInCompanyCodeCurrency  )
    // when  'JIS' then ( a.AmountInCompanyCodeCurrency )
   // when  'JRC' then ( a.AmountInCompanyCodeCurrency  )
   // when  'JRS' then ( a.AmountInCompanyCodeCurrency  )
   // when  'JRI' then ( a.TaxBaseAmountInCoCodeCrcy     ) 
    // else
      ( a.AmountInCompanyCodeCurrency  )   as TaxableValue,
 
    (  a.AmountInCompanyCodeCurrency + a.TaxBaseAmountInCoCodeCrcy )   as Gross_amount ,
      //  a.AmountInCompanyCodeCurrency as TaxableValue ,
      //   ( a.TaxBaseAmountInCoCodeCrcy + a.AmountInCompanyCodeCurrency ) as Gross_amount,
      a.TaxCode,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      case a.TransactionTypeDetermination
       when  'JII' then ( a.AmountInCompanyCodeCurrency ) end as igst,
      case a.TransactionTypeDetermination
      when  'JIC' then ( a.AmountInCompanyCodeCurrency ) end  as cgst,
      case a.TransactionTypeDetermination
      when  'JIS' then ( a.AmountInCompanyCodeCurrency ) end  as Sgst,
      case a.TransactionTypeDetermination
      when  'JRI' then ( a.AmountInCompanyCodeCurrency ) end  as RCM_igst,
      case a.TransactionTypeDetermination
      when  'JRC' then ( a.AmountInCompanyCodeCurrency ) end  as RCM_cgst,
      case a.TransactionTypeDetermination
      when  'JRS' then ( a.AmountInCompanyCodeCurrency ) end  as RCM_Sgst,
      b.Supplier                                              as PARTYcODE,
      b.IN_GSTPlaceOfSupply                                   as PlaceofSupply,
      b.FinancialAccountType,
      C.IN_GSTSupplierClassification,
      C.SupplierName                                          as PartyName,
      C.TaxNumber3                                            as GstIn,
      C.Region                                                as State,
      
      D.gstrate as TaxRate,
      E.AccountingDocumentHeaderText,
      E.DocumentReferenceID
   //   case a.TransactionTypeDetermination
   //   when  'JIC' then ( D.gstrate * 2 )
   //   when  'JIS' then ( D.gstrate * 2 )
  //    when  'JRC' then ( D.gstrate * 2 )
  //    when  'JRS' then ( D.gstrate * 2 )
  //    else
 //     ( D.gstrate  ) end      as TaxRate


}
where
  a.AccountingDocumentItemType = 'T'
