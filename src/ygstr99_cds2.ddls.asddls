@AbapCatalog.sqlViewName: 'YGSTR2IMPORT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cds For Ygstr2 Import Purg Report'
define view YGSTR99_CDS2 as select from    I_OperationalAcctgDocItem as a  
                           
{ 
  key a.AccountingDocument                                    as FiDocument,
  key a.FiscalYear                                            as FiscalYear,
  key a.CompanyCode                                           as CompanyCode,
      a.TaxItemAcctgDocItemRef                                as FiDocumentItem,
      a.AccountingDocumentItem,
      a.DocumentDate,
      a.TransactionCurrency,
      left(  a.OriginalReferenceDocument  , 10 )              as Mironumber,
      right( a.OriginalReferenceDocument  , 4 )               as MiroYear,
      a.AccountingDocumentType,
      a.PostingDate,
      a.TransactionTypeDetermination,
      a.PurchasingDocument,
      a.PurchasingDocumentItem,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      a.WithholdingTaxAmount,
      a.OriginalReferenceDocument 
     

}

