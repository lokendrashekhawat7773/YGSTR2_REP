@AbapCatalog.sqlViewName: 'ZJVDOC'
@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GSTR2 JV Documents'
define view ZJV_DOC as select from I_OperationalAcctgDocItem as a  
   left outer join I_JournalEntry   as b on b.CompanyCode        = a.CompanyCode
                                        and b.FiscalYear         = a.FiscalYear
                                        and b.AccountingDocument = a.AccountingDocument    
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
    a.GLAccount

    

}
