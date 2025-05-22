page 50136 "Mail Message View"
{
    PageType = List;
    SourceTable = "Mail Message";
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(ID; Rec.ID) { }
                field(ToAddress; Rec.ToAddress) { }
                field(Subject; Rec.Subject) { }
                field(Body; Rec.Body) { }
                field(Status; Rec.Status) { }
                field(CreatedAt; Rec.CreatedAt) { }
            }
        }
    }
}
