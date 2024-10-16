@AbapCatalog.sqlViewName: 'ZGSTR2'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GSTR2 REPORT'
define view YGSTR2
  as select from    I_OperationalAcctgDocItem as a
    inner join      I_OperationalAcctgDocItem as b on( b.AccountingDocument = a.AccountingDocument and b.FinancialAccountType = 'K'
                                                      and a.CompanyCode = b.CompanyCode and a.FiscalYear = b.FiscalYear
                                                      and b.GLAccount != '40503170' )
    left outer join I_Supplier            as    C on ( b.Supplier = C.Supplier )
    left outer join YTAX_CODECDS          as    D on ( a.TaxCode = D.Taxcode )
    inner join I_JournalEntry        as    E on ( a.AccountingDocument = E.AccountingDocument and a.FiscalYear = E.FiscalYear 
                                                      and a.CompanyCode = E.CompanyCode  )
    left outer join I_JournalEntry        as    F on ( a.AccountingDocument = F.AccountingDocument  and  F.IsReversed <> '' 
                                                      and a.CompanyCode = F.CompanyCode and a.FiscalYear = F.FiscalYear  )
                                                      
    left outer join I_JournalEntry        as    G on ( a.AccountingDocument = G.AccountingDocument  and  G.IsReversal <> '' 
                                                      and a.CompanyCode = G.CompanyCode and a.FiscalYear = G.FiscalYear) 
    inner join I_BusinessUserBasic as t on ( t.UserID = E.AccountingDocCreatedByUser )    
                                                                                                   


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
      
     
    //  a.TaxBaseAmountInCoCodeCrcy                             as InvoceValue,
     
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      case a.TransactionTypeDetermination   
      when  'JRI' then ( a.TaxBaseAmountInCoCodeCrcy ) // * 0  )       
      when  'JRC' then ( a.TaxBaseAmountInCoCodeCrcy ) //* 0  )
      when  'JRS' then ( a.TaxBaseAmountInCoCodeCrcy ) //* 0 )
      when  'JII' then ( a.TaxBaseAmountInCoCodeCrcy )
      when  'JIC' then ( a.TaxBaseAmountInCoCodeCrcy )
      when  'JIS' then ( a.TaxBaseAmountInCoCodeCrcy ) 
      else
      ( a.TaxBaseAmountInCoCodeCrcy ) end                  as TaxableValue,
      
 @Semantics.amount.currencyCode: 'TransactionCurrency'
      case a.TransactionTypeDetermination
      when  'JII' then ( a.AmountInCompanyCodeCurrency  )
      when  'JIC' then ( a.AmountInCompanyCodeCurrency * 2 )
      when  'JIS' then ( a.AmountInCompanyCodeCurrency * 2 )
      when  'JRC' then ( a.AmountInCompanyCodeCurrency * 2 )
      when  'JRS' then ( a.AmountInCompanyCodeCurrency * 2 )
      when  'JRI' then ( a.AmountInCompanyCodeCurrency * 2 )
      else
      ( b.AmountInCompanyCodeCurrency  ) end                  as InvoceValue,
 @Semantics.amount.currencyCode: 'TransactionCurrency'
             case a.TransactionTypeDetermination
          when  'JII' then (  ( a.TaxBaseAmountInCoCodeCrcy  ) + ( a.AmountInCompanyCodeCurrency  )  )
          when  'JIC' then (  ( a.TaxBaseAmountInCoCodeCrcy  ) + ( a.AmountInCompanyCodeCurrency * 2 )  )
          when  'JIS' then (  ( a.TaxBaseAmountInCoCodeCrcy  ) + ( a.AmountInCompanyCodeCurrency * 2 )  )          
          when  'JRC' then (  ( a.TaxBaseAmountInCoCodeCrcy * 0 ) + ( a.AmountInCompanyCodeCurrency * 2 )  )         
          when  'JRS' then (  ( a.TaxBaseAmountInCoCodeCrcy *  0 ) + ( a.AmountInCompanyCodeCurrency * 2 )  )
          when  'JRI' then (  ( a.TaxBaseAmountInCoCodeCrcy *  0 ) + ( a.AmountInCompanyCodeCurrency * 2 )  )
           else
         (  a.AmountInCompanyCodeCurrency ) end  as Gross_amount ,
      //  a.AmountInCompanyCodeCurrency as TaxableValue ,
      //   ( a.TaxBaseAmountInCoCodeCrcy + a.AmountInCompanyCodeCurrency ) as Gross_amount,
      a.TaxCode,
      a.DebitCreditCode,
      a.IsNegativePosting,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      
      case 
      when a.TransactionTypeDetermination = 'JII' or  a.GLAccount = '0021400120'  then ( a.AmountInCompanyCodeCurrency ) end as igst,
      case 
      when a.TransactionTypeDetermination = 'JIC' or a.GLAccount = '0021400100' then ( a.AmountInCompanyCodeCurrency ) end  as cgst,
      case 
      when a.TransactionTypeDetermination = 'JIS' or a.GLAccount = '0021400110' then ( a.AmountInCompanyCodeCurrency ) end  as Sgst,
      
//      case a.TransactionTypeDetermination
//      when  'JII'  then ( a.AmountInCompanyCodeCurrency ) end as igst,               
//      case a.TransactionTypeDetermination
//      when  'JIC' then ( a.AmountInCompanyCodeCurrency ) end  as cgst,
//      case a.TransactionTypeDetermination
//      when  'JIS' then ( a.AmountInCompanyCodeCurrency ) end  as Sgst,
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
      a.Quantity,
      a.BaseUnit,
      E.AccountingDocCreatedByUser,
      t.PersonFullName
   
   
   //   case a.TransactionTypeDetermination
   //   when  'JIC' then ( D.gstrate * 2 )
   //   when  'JIS' then ( D.gstrate * 2 )
  //    when  'JRC' then ( D.gstrate * 2 )
  //    when  'JRS' then ( D.gstrate * 2 )
  //    else
 //     ( D.gstrate  ) end      as TaxRate


}
where
  a.AccountingDocumentItemType = 'T' and a.IsNegativePosting is initial
  and  b.AccountingDocumentType != 'KA' and b.GLAccount != '40503170'
