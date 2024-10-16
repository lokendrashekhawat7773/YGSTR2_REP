@AbapCatalog.sqlViewName: 'ZGSTR2_B2C'
//@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'YGSTR2_B2C_FI_N'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
    }
define view ZGSTR2_B2C_FI_N1 as select from ZGSTR2_B2C_CDS1
{
   key FiDocument,
   key FiscalYear,
    FiDocumentItem,
    DocumentDate,
    AccountingDocumentItem, 
    TransactionCurrency  ,
    Mironumber,
    MiroYear,
    Refrence_No,
    AccountingDocumentType,
    PostingDate,
    HsnCode,
    HSNSAC_CODE,
    AssignmentReference,
    CompanyCode,
    BusinessPlace, 
    GLAccount,
   //  sum( TAXAMOUNT ) as  TAXAMOUNT,
   // TaxableValue,
  //  @Semantics.amount.currencyCode: 'TransactionCurrency'
    //Gross_amount ,
    TaxCode,   
  /*  @Semantics.amount.currencyCode: 'TransactionCurrency' 
  //   igst,
    sum( igst )                     as IGST,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    // cgst,
    sum( cgst )                     as CGST,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
  //   Sgst, 
    sum( Sgst )                     as SGST,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
  //  RCM_igst   as   RCMI,
    sum( RCM_igst )                 as RCMI,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
 //  RCM_cgst      as   RCMC,
    sum(RCM_cgst)                   as RCMC,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
  //  RCM_Sgst    as  RCMS,
    sum(RCM_Sgst)                   as RCMS,*/
    PARTYcODE,
    PlaceofSupply,
   // FinancialAccountType,
    IN_GSTSupplierClassification,
    PartyName,
    GstIn,
    State,
    TaxRate,
    Taxcodedescription,
    AccountingDocumentHeaderText,
    DocumentReferenceID,
    IsReversed,
    ReversalReferenceDocument,
    AccountingDocCreatedByUser,
    PersonFullName,
    
 //   @Semantics.amount.currencyCode: 'TransactionCurrency'
 //  case 
 //  when ( sum(InvoceValue) < 0 )
 //  then ( sum( InvoceValue ) * -1 ) 
 // else sum( InvoceValue ) end as InvoceValue,
   
    @Semantics.amount.currencyCode: 'TransactionCurrency'
   sum( case 
            when InvoceValue < 0 
            then InvoceValue * -1 
            else InvoceValue end ) as InvoceValue,
   
//@Semantics.amount.currencyCode: 'TransactionCurrency'
  //  case when ( sum( InvoceValue ) < 0 ) then ( sum( InvoceValue ) * -1 ) else sum( InvoceValue ) end        as InvoceValue,
   
 // sum(InvoceValue)  as    InvoceValue,
  //  @Semantics.amount.currencyCode: 'TransactionCurrency'
  //  case when ( sum( TAXAMOUNT ) < 0 ) then ( sum( TAXAMOUNT ) * -1 ) else sum( TAXAMOUNT) end as TAXAMOUNT
  
  @Semantics.amount.currencyCode: 'TransactionCurrency'
  sum( case
           when TAXAMOUNT < 0
           then TAXAMOUNT * -1
           else TAXAMOUNT end ) as TAXAMOUNT  
    
}
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
    HsnCode,
    HSNSAC_CODE,
    AssignmentReference,
    GLAccount,
  //  InvoceValue,
    //TaxableValue,
    //Gross_amount,
    TaxCode,
    PARTYcODE,
    PlaceofSupply,
   // FinancialAccountType,
    IN_GSTSupplierClassification,   
    PartyName,
    GstIn,
    State,
    TaxRate,
    Taxcodedescription,
    AccountingDocumentHeaderText,
    DocumentReferenceID,
    IsReversed,
    CompanyCode,
    BusinessPlace,
    ReversalReferenceDocument,
    AccountingDocCreatedByUser,
    PersonFullName
    
    
   
