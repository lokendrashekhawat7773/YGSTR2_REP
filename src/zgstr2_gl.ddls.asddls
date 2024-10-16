@AbapCatalog.sqlViewName: 'ZGLDOCUMENT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GSTR2_GL_CDS'
define view ZGSTR2_GL 
as select distinct from I_OperationalAcctgDocItem as a  
   left outer join I_JournalEntry   as b on b.CompanyCode        = a.CompanyCode
                                        and b.FiscalYear         = a.FiscalYear
                                        and b.AccountingDocument = a.AccountingDocument    
                                  //      and ( A.FinancialAccountType = 'K'   ) 
                                    //     and  b.IsReversed = 'x'
   left outer join I_JournalEntry   as f on f.CompanyCode        = a.CompanyCode
                                        and f.FiscalYear         = a.FiscalYear
                                        and f.AccountingDocument = a.AccountingDocument    
                                        and  f.IsReversed <> ' '
                                
    left outer join I_OperationalAcctgDocItem as C on  C.CompanyCode       = a.CompanyCode
                                                 and C.FiscalYear         = a.FiscalYear  
                                                 and C.AccountingDocument = a.AccountingDocument    
                                                 and ( C.FinancialAccountType = 'D' and C.SpecialGLCode <> 'A'  ) //or C.FinancialAccountType = 'K'  )  
   left outer join I_Supplier            as    D on  D.Supplier = C.Supplier 
   left outer join I_Customer            as    G on  G.Customer = C.Customer
   left outer join YTAX_CODECDS           as   E on  E.Taxcode = a.TaxCode                                                                                                              
  left outer join I_OperationalAcctgDocItem   as h on h.CompanyCode        = a.CompanyCode
                                        and h.FiscalYear         = a.FiscalYear
                                        and h.AccountingDocument = a.AccountingDocument    
                                        and ( h.GLAccount = '1500000111' or h.GLAccount = '1500000121' or h.GLAccount = '1500000131' 
                                        or h.GLAccount = '1500000161' or h.GLAccount = '1500000171' 
                                        or h.GLAccount = '1500000112' or h.GLAccount = '1500000122' or
                                        h.GLAccount = '1500000132' or h.GLAccount = '1500000162' or h.GLAccount = '1500000172' ) 

{
key a.AccountingDocument as FiDocument,
key a.FiscalYear as FiscalYear ,
    a.TaxItemAcctgDocItemRef as FiDocumentItem ,
    a.DocumentDate , 
    a.TransactionCurrency,
    a.CompanyCode,
    a.AssignmentReference as Refrence_No  ,
    a.AccountingDocumentType  ,
    a.PostingDate,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    a.AmountInCompanyCodeCurrency as  TaxableValue,
    @Semantics.amount.currencyCode: 'TransactionCurrency'   
   ( (  a.AmountInCompanyCodeCurrency ) + (a.TaxBaseAmountInTransCrcy) ) as InvoceValue ,
    (  a.TaxBaseAmountInTransCrcy  ) as Gross_amount,
    a.TaxCode ,  
    @Semantics.amount.currencyCode: 'TransactionCurrency'  
    case a.GLAccount
    when '2732800000' then ( a.AmountInCompanyCodeCurrency ) end as cgst,
    case a.GLAccount
    when '2732800000' then ( a.AmountInCompanyCodeCurrency ) end as sgst,
    case a.GLAccount
    when '2733000000' then ( a.AmountInCompanyCodeCurrency ) end as igst,
    
     
  // case a.TransactionTypeDetermination
 //  when  'JII' then ( a.AmountInCompanyCodeCurrency ) end as igst ,
  // case a.TransactionTypeDetermination
  // when  'JIC' then ( a.AmountInCompanyCodeCurrency ) end as cgst,
   //case a.TransactionTypeDetermination
  // when  'JIS' then ( a.AmountInCompanyCodeCurrency ) end as Sgst,
     a.GLAccount,
     a.DebitCreditCode,
   //  a.IsNegativePosting,
     b.AccountingDocumentHeaderText,
     b.DocumentReferenceID,
     f.IsReversed,
     f.ReversalReferenceDocument,
   
     case C.Supplier when ' ' then
     ( C.Customer ) else ( C.Supplier ) end  as PARTYcODE, 
   //  C.Customer as CUSTOMER, 
     a.IN_GSTPlaceOfSupply as PLACE_SUPPLY,
     case ( D.IN_GSTSupplierClassification ) when ' ' then 
          ( G.CustomerClassification ) else ( D.IN_GSTSupplierClassification ) end as  IN_GSTSupplierClassification,     
     case ( D.SupplierName ) when ' ' then 
          ( G.CustomerName ) else  ( D.SupplierName ) end    as PartyName,
     case ( D.TaxNumber3 ) when ' ' then 
          ( G.TaxNumber3 ) else  ( D.TaxNumber3 ) end  as  GstIn,
     case ( D.Region ) when ' ' then 
          ( G.Region ) else  ( D.Region ) end    as  State,                                                      
     E.gstrate as TaxRate,
     E.Taxcodedescription,
     h.GLAccount as glaccount1,
     case ( h.GLAccount ) 
     when '1500000111 ' then 'AXIS CC 88450 - INCO'
     when '1500000121'  then  'BOB CC 00013 - INCOM'
     when '1500000131 ' then 'PNB CC 10484 - INCOM'
     when '1500000161 ' then 'SBI CC 63132 - INCOM'
     when '1500000171 ' then 'SBI CC 41297 - INCOM'
     when '1500000112 ' then 'AXIS CC 88450 - OUTG'
     when '1500000122 ' then 'BOB CC 00013 - OUTGO'
     when '1500000132 ' then 'PNB CC 10484 - OUTGO'
     when '1500000162 ' then 'SBI CC 63132 - OUTGO'
     when '1500000172 ' then 'SBI CC 41297 - OUTGO'
     when '4600000015 ' then 'BANK CHARGES-EXP'
     else
     ' '
     end as gldescription
}
   where                 
                 ( a.AccountingDocumentType =  'SA' or 
                   a.AccountingDocumentType =  'DZ' or 
                   a.AccountingDocumentType =  'KZ'  )
                    and
                  ( a.GLAccount = '2732800000' or
                 //   a.GLAccount = '2732900000' or
                    a.GLAccount = '2733000000'  )
                    
                    and a.GLAccount != '4600000015'
                   
         /*   and

            ( a.TransactionTypeDetermination = 'JII' or 
              a.TransactionTypeDetermination = 'JIC' or 
              a.TransactionTypeDetermination = 'JIS'  ) */
           
         

         
