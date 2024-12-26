pageextension 50024 JobListPageExt extends "Job List"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        Usersetup: Record "User Setup";

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        Usersetup.GET(UserId);
    end;

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        IF Usersetup."Project manager" THEN
            Rec.SETRANGE(Rec."Project Manager", Usersetup."User ID")
    end;
}