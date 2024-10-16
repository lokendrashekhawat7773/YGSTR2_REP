@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GLACCOUNT'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity YGSTR2_GL_FI_N as select from ZGSTR2_GL 

{
      key FiDocument,
      key FiscalYear,
      FiDocumentItem,
      DocumentDate,
      TransactionCurrency,
      CompanyCode,
      Refrence_No,
      AccountingDocumentType,
      PostingDate,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      sum( TaxableValue )  as   TaxableValue,
   //  case when ( sum( TaxableValue ) < 0 ) then sum( ( TaxableValue ) * -1 ) else  sum( TaxableValue ) end as   TaxableValue,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      Gross_amount ,
     // case when Gross_amount < 0 then Gross_amount * -1 else Gross_amount end                  as Gross_amount ,
   //   Gross_amount,
      TaxCode,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      InvoceValue ,
     // case when InvoceValue < 0 then InvoceValue * -1 else InvoceValue end                  as InvoceValue ,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      sum( igst )            as IGST,
  //    case when ( sum( igst ) < 0 ) then ( sum( igst ) * -1 ) else sum( igst ) end           as IGST,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      sum( cgst )            as CGST,
    //  case when ( sum( cgst ) < 0 ) then ( sum( cgst  ) * -1 ) else sum( cgst  ) end         as CGST, 
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      sum( sgst )            as SGST,                                                
    //  case when ( sum( Sgst  ) < 0 ) then ( sum( Sgst ) * -1 ) else sum( Sgst ) end          as SGST ,   
      GLAccount,
      DebitCreditCode,
  //    IsNegativePosting,
      IsReversed,
      AccountingDocumentHeaderText,
      DocumentReferenceID,
      ReversalReferenceDocument,
      PARTYcODE,
      PLACE_SUPPLY,
      IN_GSTSupplierClassification,
      PartyName,
      GstIn,
      State,
      TaxRate,
      Taxcodedescription,
      glaccount1,
      gldescription
}
   group by
   

FiDocument,
FiscalYear,
FiDocumentItem,         
DocumentDate,           
TransactionCurrency  ,  
CompanyCode,              
Refrence_No,            
AccountingDocumentType, 
InvoceValue ,
Gross_amount,
TaxCode,
PostingDate,
GLAccount,
DebitCreditCode,
//IsNegativePosting,
IsReversed,
AccountingDocumentHeaderText,
DocumentReferenceID, 
ReversalReferenceDocument,
PARTYcODE,                
PLACE_SUPPLY,
IN_GSTSupplierClassification,
PartyName,
GstIn,
State,
TaxRate,
Taxcodedescription,
glaccount1, 
gldescription 
