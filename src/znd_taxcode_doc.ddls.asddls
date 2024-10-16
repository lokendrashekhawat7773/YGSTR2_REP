@AbapCatalog.sqlViewName: 'ZNDDOC_REP'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'DOCUMENTS FOR ND TAXCODES'
define view ZND_TAXCODE_DOC as select from ZND_DOCUMENTS
{
  key FiDocument,
  key FiscalYear,
  FiDocumentItem,
  AccountingDocumentItem,
  DocumentDate,
  ProfitCenter,
  TransactionCurrency,
  Mironumber,
  MiroYear,
  Refrence_No,
  AccountingDocumentType,
  PostingDate,
  CompanyCode,
  TransactionTypeDetermination,
  HsnCode,
  AssignmentReference,
  
      @Semantics.amount.currencyCode: 'TransactionCurrency'
   sum( case 
            when TaxableValue < 0 
            then TaxableValue * -1 
            else TaxableValue end ) as TaxableValue,
            
            
       @Semantics.amount.currencyCode: 'TransactionCurrency'
   sum( case 
            when InvoceValue < 0 
            then InvoceValue * -1 
            else InvoceValue end ) as InvoceValue,
            
            
         @Semantics.amount.currencyCode: 'TransactionCurrency'
   sum( case 
            when Gross_amount < 0 
            then Gross_amount * -1 
            else Gross_amount end ) as Gross_amount,                
  
  
//  TaxableValue,
//  InvoceValue,
//  Gross_amount,
  TaxCode,
  DebitCreditCode,
  IsNegativePosting,
  igst,
  cgst,
  Sgst,
  RCM_igst,
  RCM_cgst,
  RCM_Sgst,
  PARTYcODE,
  PlaceofSupply,
  FinancialAccountType,
  IN_GSTSupplierClassification,
  PartyName,
  PartyAdd,
  GstIn,
  State,
  TaxRate,
  Taxcodedescription,
  AccountingDocumentHeaderText,
  DocumentReferenceID,
  IsReversed,
  ReversalReferenceDocument,
  IsReversal,
  BusinessPlace,
  Quantity,
  BaseUnit  
}
 group by
 
  FiDocument,
  FiscalYear,
  FiDocumentItem,
  AccountingDocumentItem,
  DocumentDate,
  ProfitCenter,
  TransactionCurrency,
  Mironumber,
  MiroYear,
  Refrence_No,
  AccountingDocumentType,
  PostingDate,
  CompanyCode,
  TransactionTypeDetermination,
  HsnCode,
  AssignmentReference,
  TaxableValue,
  InvoceValue,
  Gross_amount,
  TaxCode,
  DebitCreditCode,
  IsNegativePosting,
  igst,
  cgst,
  Sgst,
  RCM_igst,
  RCM_cgst,
  RCM_Sgst,
  PARTYcODE,
  PlaceofSupply,
  FinancialAccountType,
  IN_GSTSupplierClassification,
  PartyName,
  PartyAdd,
  GstIn,
  State,
  TaxRate,
  Taxcodedescription,
  AccountingDocumentHeaderText,
  DocumentReferenceID,
  IsReversed,
  ReversalReferenceDocument,
  IsReversal,
  BusinessPlace,
  Quantity,
  BaseUnit  


