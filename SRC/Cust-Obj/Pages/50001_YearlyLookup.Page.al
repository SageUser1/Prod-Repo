page 50001 "Yearly Lookup"
{
    ApplicationArea = All;
    Caption = 'Yearly Lookup';
    PageType = List;
    SourceTable = "Date";
    SourceTableView = where("Period Type" = const(Year));
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Period Type"; Rec."Period Type")
                {
                    ToolTip = 'Specifies the value of the Period Type field.';
                }
                field("Period No."; Rec."Period No.")
                {
                    ToolTip = 'Specifies the value of the Period No. field.';
                }
            }
        }
    }
}
