@AbapCatalog.sqlViewName: 'YJVDOCUMENT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GSTR2 REPORT'
define view YGSTR2_JV_DOCUMENT 
as select  from I_OperationalAcctgDocItem as a  
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
                                                 and C.AccountingDocument = a.AccountingDocument and C.GLAccount != '40503170'  
                                                 and ( C.FinancialAccountType = 'D' or C.FinancialAccountType = 'K'  )  
   left outer join I_Supplier            as    D on  D.Supplier = C.Supplier  
   left outer join I_Customer            as    G on  G.Customer = C.Customer
   inner join YTAX_CODECDS           as   E on  E.Taxcode = a.TaxCode     
   inner join I_BusinessUserBasic as t on ( t.UserID = b.AccountingDocCreatedByUser )                                                                                                         

{
key a.AccountingDocument as FiDocument,
key a.FiscalYear as FiscalYear ,
    a.TaxItemAcctgDocItemRef as FiDocumentItem ,
    a.AccountingDocumentItem,
    a.DocumentDate , 
    a.TransactionCurrency,
    a.CompanyCode,
    a.BusinessPlace,
    a.AssignmentReference as Refrence_No  ,
    a.AccountingDocumentType  ,
    a.PostingDate,
    a.GLAccount,
    
//    @Semantics.amount.currencyCode: 'TransactionCurrency'
//    a.AmountInCompanyCodeCurrency as  TaxableValue,
    
//    @Semantics.amount.currencyCode: 'TransactionCurrency'   
//   ( (  a.AmountInCompanyCodeCurrency ) + (a.TaxBaseAmountInTransCrcy) ) as InvoceValue ,
//    (  a.TaxBaseAmountInTransCrcy  ) as Gross_amount,


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
       else
       ( a.AmountInCompanyCodeCurrency  ) end                  as InvoceValue,

       @Semantics.amount.currencyCode: 'TransactionCurrency'
       case a.TransactionTypeDetermination
       when  'JII' then (  ( a.TaxBaseAmountInCoCodeCrcy  ) + ( a.AmountInCompanyCodeCurrency  )  )
       when  'JIC' then (  ( a.TaxBaseAmountInCoCodeCrcy  ) + ( a.AmountInCompanyCodeCurrency * 2 )  )
       when  'JIS' then (  ( a.TaxBaseAmountInCoCodeCrcy  ) + ( a.AmountInCompanyCodeCurrency * 2 )  )          
       else
       (  a.AmountInCompanyCodeCurrency ) end  as Gross_amount ,


    a.TaxCode ,  
    @Semantics.amount.currencyCode: 'TransactionCurrency'  
   case a.TransactionTypeDetermination
   when  'JII' then ( a.AmountInCompanyCodeCurrency ) end as igst,
   case a.TransactionTypeDetermination
   when  'JIC' then ( a.AmountInCompanyCodeCurrency ) end as cgst,
   case a.TransactionTypeDetermination
   when  'JIS' then ( a.AmountInCompanyCodeCurrency ) end as Sgst,
    // a.GLAccount,
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
     b.AccountingDocCreatedByUser,
     t.PersonFullName
     
  
}
   where                 
                           
//             (     a.AccountingDocumentType =  'DZ' or
//                   a.AccountingDocumentType =  'KZ' or
//                   a.AccountingDocumentType =  'SA' ) 

                   ( a.AccountingDocumentType =  'JV' or a.AccountingDocumentType =  'SA' )
                   
//            and
//
//            ( a.TransactionTypeDetermination = 'JII' or 
//              a.TransactionTypeDetermination = 'JIC' or 
//              a.TransactionTypeDetermination = 'JIS'  )
              
              and a.FinancialAccountType = 'S' and ( a.TaxCode = 'V0'     or a.TaxType = 'V' )
    and        
  (  a.TaxCode = 'P1' or a.TaxCode = 'P2' or a.TaxCode = 'P3' or a.TaxCode = 'P4' or a.TaxCode = 'P5' or a.TaxCode = 'P6' or a.TaxCode = 'P7' or a.TaxCode = 'P8' 
  or a.TaxCode = 'PA' or a.TaxCode = 'PB' or a.TaxCode = 'PC' or a.TaxCode = 'PD' or a.TaxCode = 'PE' or a.TaxCode = 'PF' or a.TaxCode = 'PG' or a.TaxCode = 'PH' 
  or a.TaxCode = 'RA' or a.TaxCode = 'RB' or a.TaxCode = 'RC' or a.TaxCode = 'RD' or a.TaxCode = 'RE' or a.TaxCode = 'RF' or a.TaxCode = 'RG' or a.TaxCode = 'RH'
  or a.TaxCode = 'RI' or a.TaxCode = 'RJ' or a.TaxCode = 'RK' or a.TaxCode = 'RL' or a.TaxCode = 'RM' or a.TaxCode = 'RN' or a.TaxCode = 'RO' or a.TaxCode = 'RP'
  or a.TaxCode = 'RQ' or a.TaxCode = 'RR' or a.TaxCode = 'RS'  
  or a.TaxCode = 'Z1' or a.TaxCode = 'Z2' or a.TaxCode = 'Z3' or a.TaxCode = 'Z4' 
  or a.TaxCode = 'ZA' or a.TaxCode = 'ZB' or a.TaxCode = 'ZC' or a.TaxCode = 'ZD' )
              and ( b.IsReversed != 'X' or b.IsReversal != 'X' )
              and a.GLAccount != '40503170'
         
