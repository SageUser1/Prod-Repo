pageextension 50001 "Resource Card Ext" extends "Resource Card"
{
    layout
    {
        modify("Direct Unit Cost")
        {
            Visible = false;
        }
        modify("Indirect Cost %")
        {
            Visible = false;
        }
        modify("Price/Profit Calculation")
        {
            Visible = false;
        }
        modify("Profit %")
        {
            Visible = false;
        }
        modify("Default Deferral Template Code")
        {
            visible = false;
        }
        modify("Automatic Ext. Texts")
        {
            Visible = false;
        }
        modify("IC Partner Purch. G/L Acc. No.")
        {
            visible = false;
        }


        addlast(General)
        {
            field("Sub-Contracting Resource"; Rec."Sub-Contracting Resource")
            {
                ApplicationArea = all;
            }
            field("Sub-Con. Resource Vendor"; Rec."Sub-Con. Resource Vendor")
            {
                ApplicationArea = all;
                Editable = Rec."Sub-Contracting Resource";

            }
            field("Sub-Con. Resource Vendor Name"; Rec."Sub-Con. Resource Vendor Name")
            {
                ApplicationArea = all;
                Editable = Rec."Sub-Contracting Resource";
            }
            field("Resource Category"; Rec."Resource Category")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        addafter(CreateTimeSheets)
        {
            action(CreateTimeSheets15D)
            {
                ApplicationArea = Jobs;
                Caption = 'Create Time Sheets-15D';
                Ellipsis = true;
                Image = NewTimesheet;
                ToolTip = 'Create new time sheets for the resource.';
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    CreateTimeSheets2();
                end;
            }
            action("Base Calender")
            {
                ApplicationArea = all;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                image = ShowList;
                RunObject = page "Base Calendar List";
            }
            action("Leave Info")
            {
                ApplicationArea = all;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                image = ShowList;

                trigger OnAction()
                var
                    PTO: Record "PTO Details";
                begin
                    IF Rec."Resource Group No." = 'W2' THEN BEGIN
                        PTO.Reset();
                        PTO.SetRange("Resource No.", rec."No.");
                        page.RunModal(0, PTO);
                    End Else
                        Error('You dont have permissions to view this.');
                end;
            }
        }
    }


    procedure CreateTimeSheets2()
    var
        Resource: Record Resource;
        IsHandled: Boolean;
    begin
        IsHandled := false;


        rec.TestField("Use Time Sheet", true);
        Resource.Get(Rec."No.");
        Resource.SetRecFilter();
        REPORT.RunModal(REPORT::"Create Time Sheets - 15 Days", true, false, Resource);
    end;
}