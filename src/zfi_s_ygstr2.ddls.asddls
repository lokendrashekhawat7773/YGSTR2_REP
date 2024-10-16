@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'YGSTR2_REPORT'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZFI_S_YGSTR2 as select from YGSTR2
{
    key FiDocument,
    key FiscalYear,
    FiDocumentItem,
    DocumentDate,
    AccountingDocumentItem,
    TransactionCurrency,
    Mironumber,
    MiroYear,
    Refrence_No,
    AccountingDocumentType,
    CompanyCode,
    BusinessPlace,
    PostingDate,
    ProfitCenter,
    GLAccount,
    @Semantics: { quantity : {unitOfMeasure: 'BaseUnit'} }
    Quantity,
    BaseUnit,
    HsnCode,
    AssignmentReference,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    InvoceValue,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    TaxableValue,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    Gross_amount ,
    TaxCode,   
    @Semantics.amount.currencyCode: 'TransactionCurrency' 
    sum( igst )                     as IGST,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    sum( cgst )                     as CGST,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    sum( Sgst )                     as SGST,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    sum( RCM_igst )                 as RCMI,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    sum(RCM_cgst)                   as RCMC,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    sum(RCM_Sgst)                   as RCMS,
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
    IsReversal,
    ReversalReferenceDocument,
    AccountingDocCreatedByUser,
    PersonFullName
}
where  IsReversed is null
  group by
  
    FiDocument,
    FiscalYear,
    FiDocumentItem,
    DocumentDate,
    AccountingDocumentItem,
    TransactionCurrency,
    Mironumber,
    MiroYear,
    Refrence_No,
    AccountingDocumentType,
    PostingDate,
    ProfitCenter,
    Quantity,
    BaseUnit,
    HsnCode,
    GLAccount,
    AssignmentReference,
    InvoceValue,
    TaxableValue,
    Gross_amount,
    TaxCode,
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
    IsReversal,
    CompanyCode,
    BusinessPlace,
    ReversalReferenceDocument,
    AccountingDocCreatedByUser,
    PersonFullName 
