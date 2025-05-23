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
            //Bruger Microsoft's indbyggede integration til at lave en chart
            usercontrol(Chart; "Microsoft.Dynamics.Nav.Client.BusinessChart")
            {
                ApplicationArea = All;
                trigger AddInReady()
                var
                    //Business Chart Buffer SKAL have temporary fordi man ikke kan bruge BCB normalt
                    //Bruger SalesHeader/Line til at finde vores produkter og hvor mange der er blevet solgt
                    //Bruger Customer til at allokere kundens navn på ordrene
                    //COrders bruger dictionary til at blive sat ind i en liste for vores graf
                    //CNo bruges til at tælle op hvor mange ordrer der er blevet lavet
                    //Quantity bruges til at blive vist på grafen når man holder over et punkt
                    //i er til når vi skal lave en foreach når ordrerne bliver sat ind i grafen
                    Buffer: Record "Business Chart Buffer" temporary;
                    SalesHeader: Record "Sales Header";
                    SalesLine: Record "Sales Line";
                    Customer: Record Customer;
                    CustomerOrders: Dictionary of [Code[20], Decimal];
                    CustomerNo: Code[20];
                    Quantity: Decimal;
                    i: Integer;

                begin
                    //Initalizerer og sætter nogle parametrer for hvad vi prøver at vise
                    Buffer.Initialize();
                    Buffer.AddMeasure('Open Sales Orders', 1, Buffer."Data Type"::Decimal, Buffer."Chart Type"::Pie);
                    Buffer.SetXAxis('Customer', Buffer."Data Type"::String);

                    //Sætter et filter for hvilke kunder vi viser frem i grafen
                    SalesHeader.SetFilter("Sell-to Customer No.", '01121212|IC1030|20339921');

                    repeat
                        //Checker at hvad vi arbejder med er en ordrer og om ordren har status: Open
                        if (SalesHeader."Document Type" = SalesHeader."Document Type"::Order) and
                            (SalesHeader.Status = SalesHeader.Status::Open) then begin

                            //Range og Filter bruges begge til at limitere hvad der vises i grafen
                            SalesLine.SetRange("Document Type", SalesHeader."Document Type");
                            SalesLine.SetRange("Document No.", SalesHeader."No.");
                            SalesLine.SetFilter("No.", '1000|1001|1100');

                            //Går gennem hver record i SalesLine og laves SL.Quantity en del af vores Quantity variabel
                            repeat
                                Quantity := SalesLine.Quantity;
                            until SalesLine.Next() = 0;

                            //if statement bliver ved så længe Quantity ikke er = 0
                            //Bruges til at hvis en kunde har lavet flere ordrer at alle kundens ordrer bliver sat sammen til en
                            if Quantity <> 0 then begin
                                CustomerNo := SalesHeader."Sell-to Customer No.";
                                if CustomerOrders.ContainsKey(CustomerNo) then
                                    CustomerOrders.Set(CustomerNo, CustomerOrders.Get(CustomerNo) + Quantity)
                                else
                                    CustomerOrders.Add(CustomerNo, Quantity);
                            end;
                        end;
                    until SalesHeader.Next() = 0;

                    //Laver selve grafen ved at putte ordrene ind i et forloop der bagefter displayer vores graf
                    foreach CustomerNo in CustomerOrders.Keys do begin
                        if Customer.Get(CustomerNo) then begin
                            Buffer.AddColumn(Customer.Name);
                            Buffer.SetValueByIndex(0, i, CustomerOrders.Get(CustomerNo));
                            i += 1;
                        end;
                    end;

                    //Slutter med at opdatere den page vi er på som er vores graf
                    Buffer.Update(CurrPage.Chart);
                end;
            }
        }
    }
}