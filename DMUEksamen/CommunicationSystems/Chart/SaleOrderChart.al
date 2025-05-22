page 50131 SaleOrderChart
{
    PageType = Card;
    UsageCategory = Administration;
    ApplicationArea = All;
    Caption = 'Sale Order Chart';

    layout
    {
        area(Content)
        {
            usercontrol(Chart; "Microsoft.Dynamics.Nav.Client.BusinessChart")
            {
                ApplicationArea = All;
                trigger AddInReady()
                var
                    Buffer: Record "Business Chart Buffer" temporary;
                    SalesHeader: Record "Sales Header";
                    SalesLine: Record "Sales Line";
                    Customer: Record Customer;
                    CustomerOrders: Dictionary of [Code[20], Decimal];
                    CustomerNo: Code[20];
                    Quantity: Decimal;
                    i: Integer;

                begin
                    Buffer.Initialize();
                    Buffer.AddMeasure('Open Sales Orders', 1, Buffer."Data Type"::Decimal, Buffer."Chart Type"::Pie);
                    Buffer.SetXAxis('Customer', Buffer."Data Type"::String);

                    SalesHeader.SetFilter("Sell-to Customer No.", '01121212|IC1030|20339921');

                    if SalesHeader.FindSet(false, false) then
                        repeat
                            if (SalesHeader."Document Type" = SalesHeader."Document Type"::Order) and
                                (SalesHeader.Status = SalesHeader.Status::Open) then begin

                                SalesLine.SetRange("Document Type", SalesHeader."Document Type");
                                SalesLine.SetRange("Document No.", SalesHeader."No.");
                                SalesLine.SetFilter("No.", '1000|1001|1100');

                                Quantity := 0;

                                if SalesLine.FindSet() then
                                    repeat
                                        Quantity += SalesLine.Quantity;
                                    until SalesLine.Next() = 0;

                                if Quantity <> 0 then begin
                                    CustomerNo := SalesHeader."Sell-to Customer No.";
                                    if CustomerOrders.ContainsKey(CustomerNo) then
                                        CustomerOrders.Set(CustomerNo, CustomerOrders.Get(CustomerNo) + Quantity)
                                    else
                                        CustomerOrders.Add(CustomerNo, Quantity);
                                end;
                            end;
                        until SalesHeader.Next() = 0;

                    foreach CustomerNo in CustomerOrders.Keys do begin
                        if Customer.Get(CustomerNo) then begin
                            Buffer.AddColumn(Customer.Name);
                            Buffer.SetValueByIndex(0, i, CustomerOrders.Get(CustomerNo));
                            i += 1;
                        end;
                    end;

                    Buffer.Update(CurrPage.Chart);
                end;
            }
        }
    }
}