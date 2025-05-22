table 50135 "Mail Message"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; ID; Integer) { AutoIncrement = true; }
        field(2; ToAddress; Text[100]) { }
        field(3; Subject; Text[100]) { }
        field(4; Body; Text[250]) { }
        field(5; Status; Option)
        {
            OptionMembers = Pending,Sent,Failed;
        }
        field(6; CreatedAt; DateTime) { }
    }

    keys
    {
        key(PK; "ID") { Clustered = true; }
    }
}