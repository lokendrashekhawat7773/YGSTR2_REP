 @AbapCatalog.sqlViewName: 'ZND_DOC'
 @AbapCatalog.compiler.compareFilter: true
// @AbapCatalog.preserveKey: true
 @AccessControl.authorizationCheck: #NOT_REQUIRED
 @EndUserText.label: 'For ND tax code documents'
 define view ZND_DOCUMENTS as select distinct from I_OperationalAcctgDocItem as a
    left outer join I_OperationalAcctgDocItem as b on( b.AccountingDocument = a.AccountingDocument 
                                  and a.CompanyCode = b.CompanyCode and a.FiscalYear = b.FiscalYear
                                  and b.GLAccount <> '40503170' and a.FinancialAccountType = 'S')                                 
    
    inner join I_OperationalAcctgDocItem as S on( S.AccountingDocument = a.AccountingDocument 
                                  and S.CompanyCode = a.CompanyCode and S.FiscalYear = a.FiscalYear
//                                  and S.GLAccount <> '40503170' 
                                  and S.FinancialAccountType = 'K')  
                                                                
    left outer join I_Supplier   as C on ( S.Supplier = C.Supplier )
    
    left outer join YTAX_CODECDS as D on ( a.TaxCode = D.Taxcode )
    
    inner join I_JournalEntry    as E on ( a.AccountingDocument = E.AccountingDocument and a.FiscalYear = E.FiscalYear 
                                  and a.CompanyCode = E.CompanyCode  )                                                     
  
    left outer join I_JournalEntry as F on ( a.AccountingDocument = F.AccountingDocument  and  F.IsReversed <> 'X' 
                                  and a.CompanyCode = F.CompanyCode and a.FiscalYear = F.FiscalYear  )                                                     
  
    left outer join I_JournalEntry as G on ( a.AccountingDocument = G.AccountingDocument  and  G.IsReversal <> 'X' 
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
      a.GLAccount,
      left(  a.OriginalReferenceDocument  , 10 )              as Mironumber,
      right( a.OriginalReferenceDocument  , 4 )               as MiroYear,
      a.AssignmentReference                                   as Refrence_No,
      a.AccountingDocumentType,
      a.PostingDate,
      a.CompanyCode,
      a.TransactionTypeDetermination,
      a.IN_HSNOrSACCode                                       as HsnCode,
      b.AssignmentReference ,
                     
     @Semantics.amount.currencyCode: 'TransactionCurrency'
      case a.TaxCode   
      when  'Z1' then ( a.OriglTaxBaseAmountInCoCodeCrcy * 5  )   
      when  'Z2' then ( a.OriglTaxBaseAmountInCoCodeCrcy * 12 ) 
      when  'Z3' then ( a.OriglTaxBaseAmountInCoCodeCrcy * 18 ) 
      when  'Z4' then ( a.OriglTaxBaseAmountInCoCodeCrcy * 28 )
      when  'ZA' then ( a.OriglTaxBaseAmountInCoCodeCrcy * 5  )
      when  'ZB' then ( a.OriglTaxBaseAmountInCoCodeCrcy * 12 )
      when  'ZC' then ( a.OriglTaxBaseAmountInCoCodeCrcy * 18 )
      when  'ZD' then ( a.OriglTaxBaseAmountInCoCodeCrcy * 28 )
      else
      ( a.OriglTaxBaseAmountInCoCodeCrcy ) end           as  GST_AMOUNT,
      
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      case a.TaxCode   
      when  'Z1' then ( a.OriglTaxBaseAmountInCoCodeCrcy * 5 )       
      when  'Z2' then ( a.OriglTaxBaseAmountInCoCodeCrcy * 12 ) 
      when  'Z3' then ( a.OriglTaxBaseAmountInCoCodeCrcy * 18 ) 
      when  'Z4' then ( a.OriglTaxBaseAmountInCoCodeCrcy * 28 )
      else
      ( a.OriglTaxBaseAmountInCoCodeCrcy ) end                  as cgst_sgst,
  
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      case b.TaxCode        
      when  'ZA' then ( a.OriglTaxBaseAmountInCoCodeCrcy * 5  ) 
      when  'ZB' then ( a.OriglTaxBaseAmountInCoCodeCrcy * 12 ) 
      when  'ZC' then ( a.OriglTaxBaseAmountInCoCodeCrcy * 18 )
      when  'ZD' then ( a.OriglTaxBaseAmountInCoCodeCrcy * 28 )
      else
      ( a.OriglTaxBaseAmountInCoCodeCrcy ) end                  as IGST_AMOUNT,
       
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      ( a.OriglTaxBaseAmountInCoCodeCrcy  +  a.AmountInCompanyCodeCurrency  )   as Gross_amount,
      
       @Semantics.amount.currencyCode: 'TransactionCurrency'
      case a.TaxCode   
      when  'Z1' then ( a.AmountInCompanyCodeCurrency )   
      when  'Z2' then ( a.AmountInCompanyCodeCurrency ) 
      when  'Z3' then ( a.AmountInCompanyCodeCurrency ) 
      when  'Z4' then ( a.AmountInCompanyCodeCurrency )
      when  'ZA' then ( a.AmountInCompanyCodeCurrency )
      when  'ZB' then ( a.AmountInCompanyCodeCurrency )
      when  'ZC' then ( a.AmountInCompanyCodeCurrency )
      when  'ZD' then ( a.AmountInCompanyCodeCurrency )
      else
      ( a.AmountInCompanyCodeCurrency ) end           as InvoceValue,
      
    @Semantics.amount.currencyCode: 'TransactionCurrency'
      case a.TaxCode   
      when  'Z1' then ( D.gstrate)   
      when  'Z2' then ( D.gstrate ) 
      when  'Z3' then ( D.gstrate ) 
      when  'Z4' then ( D.gstrate )
      when  'ZA' then ( D.gstrate )
      when  'ZB' then ( D.gstrate )
      when  'ZC' then ( D.gstrate )
      when  'ZD' then ( D.gstrate )
      else
      ( a.AmountInCompanyCodeCurrency ) end           as TaxRate,
         
      a.OriglTaxBaseAmountInCoCodeCrcy                as TaxableValue,
      a.TaxCode,
      a.DebitCreditCode,
      a.IsNegativePosting,
      
      case a.TransactionTypeDetermination
      when  'JRI' then ( a.AmountInCompanyCodeCurrency ) end  as RCM_igst,
      case a.TransactionTypeDetermination
      when  'JRC' then ( a.AmountInCompanyCodeCurrency ) end  as RCM_cgst,
      case a.TransactionTypeDetermination
      when  'JRS' then ( a.AmountInCompanyCodeCurrency ) end  as RCM_Sgst,

      @Semantics.amount.currencyCode: 'TransactionCurrency'      
      case 
      when a.TaxCode = 'Z1' or  a.TaxCode = 'Z2' or
           a.TaxCode = 'Z3' or  a.TaxCode = 'Z4'  then ( a.OriglTaxBaseAmountInCoCodeCrcy * D.gstrate  ) end as Sgst,
      case 
      when a.TaxCode = 'ZA' or  a.TaxCode = 'ZB' or
           a.TaxCode = 'ZC' or  a.TaxCode = 'ZD'  then ( a.OriglTaxBaseAmountInCoCodeCrcy * D.gstrate ) end as Igst,     
      case 
      when a.TaxCode = 'Z1' or  a.TaxCode = 'Z2' or
           a.TaxCode = 'Z3' or  a.TaxCode = 'Z4'  then ( a.OriglTaxBaseAmountInCoCodeCrcy * D.gstrate ) end as Cgst,

          
      S.Supplier                                              as PARTYcODE,
      S.IN_GSTPlaceOfSupply                                   as PlaceofSupply,
      a.FinancialAccountType,
      C.IN_GSTSupplierClassification,
      C.SupplierName                                          as PartyName,
      C.SupplierFullName                                      as PartyAdd,
      C.TaxNumber3                                            as GstIn,
      C.Region                                                as State,     
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
 }
 where
    C.IN_GSTSupplierClassification = '' and b.GLAccount != '40503170'  and a.AssignmentReference != ''
    and b.FinancialAccountType = 'S' 
    and b.TaxCode != 'V0'
    and ( F.IsReversed != 'X' or G.IsReversal != 'X' )
    and ( b.TaxCode = 'Z1' or b.TaxCode = 'Z2' or b.TaxCode = 'Z3' or b.TaxCode = 'Z4'
       or b.TaxCode = 'ZA' or b.TaxCode = 'ZB' or b.TaxCode = 'ZC' or b.TaxCode = 'ZD' )
    
  
  
  
  
  
  
