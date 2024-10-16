@AbapCatalog.sqlViewName: 'ZEXEMPTED'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GSTR2 EXEMPTED SUPLIER'
define view YGSTR2_EXEMPTED_SUP as select from I_OperationalAcctgDocItem  as A
        left outer join I_Supplier as B on B.Supplier = A.Supplier
{
     key A.AccountingDocument,                                    
     key A.FiscalYear,                                           
      B.IN_GSTSupplierClassification,
      B.SupplierName,                                          
      B.SupplierFullName,                                     
      B.TaxNumber3,                                           
      B.Region,
      B.Supplier                                                
    
} where A.FinancialAccountType = 'K' and B.Supplier <> '' and A.TaxCode = 'V0'
