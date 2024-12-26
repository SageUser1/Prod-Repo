page 50009 "Email Body Setup"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Email Bodies";

    layout
    {
        area(Content)
        {
            repeater(Details)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = all;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = all;
                }
                field("Email Editor"; Rec."Email Editor")
                {
                    ApplicationArea = all;
                    MultiLine = true;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}