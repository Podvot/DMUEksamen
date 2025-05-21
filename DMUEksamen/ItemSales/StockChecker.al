codeunit 50122 "Stock Checker"
{
    Subtype = Normal;

    procedure RunCheck()
    var
        Item: Record Item;
        Mail: Record "Mail Message";
        ItemNos: array[3] of Code[20];
        ItemNo: Code[20];
        Threshold: Decimal;
        Body: Text;
        i: Integer;
    begin
        Threshold := 5;


        ItemNos[1] := '1000';
        ItemNos[2] := '1001';
        ItemNos[3] := '1100';

        for i := 1 to ArrayLen(ItemNos) do begin
            ItemNo := ItemNos[i];

            if Item.Get(ItemNo) then begin
                if Item.Inventory < Threshold then begin
                    Body := StrSubstNo(
                        'Item %1 (%2) is below stock. Inventory: %3 / Limit: %4',
                        Item."No.", Item.Description, Item.Inventory, Threshold);

                    Clear(Mail); // reset memory fully
                    Mail."To Address" := 'warehouse@Bikeshop.com';
                    Mail.Subject := 'LOW STOCK: ' + Item."No.";
                    Mail.Body := Body;
                    Mail.Status := Mail.Status::Pending;
                    Mail."Created At" := CURRENTDATETIME;
                    Mail.Insert(true);

                end;
            end;
        end;
    end;
}
