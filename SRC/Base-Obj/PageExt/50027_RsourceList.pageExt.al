pageextension 50027 ResoLispageExt extends "Resource List"
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
        IF NOT Usersetup."Show All Resource" THEN
            Rec.SETRANGE(Rec."Time Sheet Owner User ID", Usersetup."User ID")
    end;
}