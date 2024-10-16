@AbapCatalog.sqlViewName: 'ZTEST_PUR1'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GSTR2 REPORT'
define view YTEST_PUR1
  as select from    I_OperationalAcctgDocItem as a
    inner join      I_OperationalAcctgDocItem as b on(
                                          b.AccountingDocument = a.AccountingDocument
                                      and b.FinancialAccountType = 'K'  )
    left outer join I_Supplier            as    C on ( b.Supplier = C.Supplier )
    left outer join YTAX_CODECDS          as    D on ( a.TaxCode = D.Taxcode )
    left outer join I_JournalEntry        as    E on ( a.AccountingDocument = E.AccountingDocument )
    left outer join I_JournalEntry        as    F on ( a.AccountingDocument = F.AccountingDocument)  and ( F.IsReversed <> ' ' or F.IsReversal <> ' ')

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
     
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      case a.TransactionTypeDetermination
       when  'JRI' then ( a.TaxBaseAmountInCoCodeCrcy * 0  )
      when  'JRC' then ( a.TaxBaseAmountInCoCodeCrcy * 0  )
      when  'JRS' then ( a.TaxBaseAmountInCoCodeCrcy * 0 )
      else
      ( a.TaxBaseAmountInCoCodeCrcy ) end                  as InvoceValue,
      
 @Semantics.amount.currencyCode: 'TransactionCurrency'
      case a.TransactionTypeDetermination
      when  'JIC' then ( a.AmountInCompanyCodeCurrency * 2 )
      when  'JIS' then ( a.AmountInCompanyCodeCurrency * 2 )
      when  'JRC' then ( a.AmountInCompanyCodeCurrency * 2 )
      when  'JRS' then ( a.AmountInCompanyCodeCurrency * 2 )
      else
      ( b.AmountInCompanyCodeCurrency  ) end                  as TaxableValue,
 @Semantics.amount.currencyCode: 'TransactionCurrency'
             case a.TransactionTypeDetermination
          when  'JII' then (  ( a.TaxBaseAmountInCoCodeCrcy  ) + ( a.AmountInCompanyCodeCurrency  )  )
          when  'JIC' then (  ( a.TaxBaseAmountInCoCodeCrcy  ) + ( a.AmountInCompanyCodeCurrency * 2 )  )
          when  'JIS' then (  ( a.TaxBaseAmountInCoCodeCrcy  ) + ( a.AmountInCompanyCodeCurrency * 2 )  )          
          when  'JRC' then (  ( a.TaxBaseAmountInCoCodeCrcy * 0 ) + ( a.AmountInCompanyCodeCurrency * 2 )  )         
          when  'JRS' then (  ( a.TaxBaseAmountInCoCodeCrcy *  0 ) + ( a.AmountInCompanyCodeCurrency * 2 )  )
           else
         (  a.AmountInCompanyCodeCurrency ) end  as Gross_amount ,
      //  a.AmountInCompanyCodeCurrency as TaxableValue ,
      //   ( a.TaxBaseAmountInCoCodeCrcy + a.AmountInCompanyCodeCurrency ) as Gross_amount,
      a.TaxCode,
      a.DebitCreditCode,
      a.IsNegativePosting,
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
      D.Taxcodedescription,
      E.AccountingDocumentHeaderText,
      E.DocumentReferenceID,
      F.IsReversed,
      F.ReversalReferenceDocument
      
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
