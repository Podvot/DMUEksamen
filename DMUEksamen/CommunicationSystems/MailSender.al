codeunit 50123 "Mail Sender"
{
    procedure SendPendingMails()
    var
        Mail: Record "Mail Message";
        SMTP: Codeunit "SMTP Mail";
    begin
        if Mail.FindSet() then
            repeat
                if Mail.Status = Mail.Status::Pending then begin
                    SMTP.CreateMessage(
                        'System Notification', // FromName
                        'noreply@Bikeshop.com', // FromAddress
                        Mail."To Address", // To
                        Mail.Subject, // Subject
                        Mail.Body, // Body
                        false // Not HTML
                    );
                    SMTP.Send();

                    Mail.Status := Mail.Status::Sent;
                    Mail.Modify();
                end;
            until Mail.Next() = 0;
    end;
}
