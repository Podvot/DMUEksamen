report 50140 "Run Stock Checker"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;

    trigger OnPreReport()
    var
        StockChecker: Codeunit "Stock Checker";
    begin
        StockChecker.RunCheck();
        Message('Lagerstatus er kontrolleret, og beskeder er oprettet hvis nødvendigt.');
    end;
}