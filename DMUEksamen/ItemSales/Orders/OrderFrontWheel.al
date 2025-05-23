report 50102 OrderFrontWheel
{
    Caption = 'Sales order for item ID: 1100';
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;

    trigger OnPreReport()
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        Customer: Record Customer;
        Item: Record Item;
        SalesHeaderNo: Code[20];
        CustomerNo: Code[20];
    begin
        //Vælger en specifik kunde i forhold til deres i CustomerList til at lave en ordre
        //og sender en fejl hvis den valgte kunde ikke kunne findes
        if not Customer.Get('20339921') then
            Error('Could not find any customers');

        //Checker om kunden vi har valgt findes og sender en besked tilbage med deres navn
        CustomerNo := Customer."No.";
        Message('Selected customer: %1 (%2)', CustomerNo, Customer.Name);

        //Finder produktet der her ID 1100
        //og giver en error hvis produktet med ID 1100 ikke kunne findes
        if not Item.Get('1100') then
            Error('Item 1100 could not be found.');

        //Laver Sales header
        //Vælger hvilken slags type det bliver brugt
        //Validerer hvilken kunde der bliver solgt til
        SalesHeader.Init();
        SalesHeader."Document Type" := SalesHeader."Document Type"::Order;
        SalesHeader.Validate("Sell-to Customer No.", CustomerNo);
        SalesHeader.Insert(true);
        SalesHeaderNo := SalesHeader."No.";

        //Laver Sales line
        //Vælger hvilken type der bliver brugt
        //Finder hvilken line nr. produktet har
        //Validerer om SalesLine type er korrekt og Item's ID nr.
        //Validerer hvor mange af produktet der bliver solgt 
        SalesLine.Init();
        SalesLine."Document Type" := SalesLine."Document Type"::Order;
        SalesLine."Document No." := SalesHeader."No.";
        SalesLine."Line No." := 10000;
        SalesLine.Validate(Type, SalesLine.Type::Item);
        SalesLine.Validate("No.", Item."No.");
        SalesLine.Validate(Quantity, 10);
        SalesLine.Insert(true);

        //Giver en besked inde I dynamics når ordren er blevet lavet.
        Message('Sales ordrer nr. %1 er blevet lavet af kunde ID: %2 Navn: %3 med produkt ID: %4 Navn: %5, Mængde: %6', SalesHeaderNo, CustomerNo, Customer.Name, Item."No.", Item.Description, SalesLine.Quantity);
    end;
}