pageextension 50023 TeamMembActPageExt extends "Team Member Activities"
{
    layout
    {
        modify("Current Time Sheet")
        {
            Visible = false;
        }
        addafter("Current Time Sheet")
        {
            cuegroup("Current Time Sheet 2")
            {
                Caption = 'Current Time Sheet';
                actions
                {
                    action(OpenCurrentTimeSheet)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Open My Current Time Sheet';
                        Image = TileBrickCalendar;
                        ToolTip = 'Open the time sheet for the current period. Current period is based on work date set in my settings.';
                        trigger OnAction()
                        var
                            TimeSheetHeader: Record "Time Sheet Header";
                            FeatureTelemetry: Codeunit "Feature Telemetry";
                            TimeSheetCard: Page "Time Sheet Card - 15D";
                            TimeSheetList: Page "Time Sheet List - 15D";
                            TimeSheetManagement2: Codeunit "Time Sheet Management";
                        begin
                            TimeSheetManagement2.FilterTimeSheets(TimeSheetHeader, TimeSheetHeader.FieldNo("Owner User ID"), true);
                            TimeSheetCard.SetTableView(TimeSheetHeader);
                            if TimeSheetHeader.Get(TimeSheetHeader.FindCurrentTimeSheetNo(TimeSheetHeader.FieldNo("Owner User ID"))) then begin
                                TimeSheetCard.SetRecord(TimeSheetHeader);
                                TimeSheetCard.Run();
                            end else begin
                                TimeSheetHeader.Reset();
                                TimeSheetManagement2.FilterTimeSheets(TimeSheetHeader, TimeSheetHeader.FieldNo("Owner User ID"), true);
                                TimeSheetList.SetTableView(TimeSheetHeader);
                                TimeSheetList.SetRecord(TimeSheetHeader);
                                TimeSheetList.Run();
                            end;
                            FeatureTelemetry.LogUsage('0000JQU', 'NewTimeSheetExperience', 'Current Time Sheet opened from Self-Service part of the Role Center');
                        end;
                    }
                }
            }
        }
        // Add changes to page layout here
        modify("New Time Sheets")
        {
            Visible = false;
        }
        modify("Open Time Sheets")
        {
            Visible = false;
        }
        addafter("New Time Sheets")
        {
            field("New Time Sheets 2"; Rec."New Time Sheets")
            {
                ApplicationArea = Basic, Suite;
                DrillDownPageID = "Time Sheet List - 15D";
                ToolTip = 'Specifies the number of time sheets that are currently assigned to you, without lines.';
            }
            field("Open Time Sheets 2"; Rec."Open Time Sheets")
            {
                ApplicationArea = Basic, Suite;
                DrillDownPageID = "Time Sheet List - 15D";
                ToolTip = 'Specifies the number of time sheets that are currently assigned to you, have open lines and not submitted for approval.';
            }
        }
        modify("Submitted Time Sheets")
        {
            Visible = false;
        }
        modify("Rejected Time Sheets")
        {
            Visible = false;
        }
        modify("Approved Time Sheets")
        {
            Visible = false;
        }
        addafter("Submitted Time Sheets")
        {
            field("Submitted Time Sheets 2"; Rec."Submitted Time Sheets")
            {
                ApplicationArea = Basic, Suite;
                DrillDownPageID = "Time Sheet List - 15D";
                ToolTip = 'Specifies the number of time sheets that you have submitted for approval but are not yet approved.';
            }
            field("Rejected Time Sheets 2"; Rec."Rejected Time Sheets")
            {
                ApplicationArea = Basic, Suite;
                DrillDownPageID = "Time Sheet List - 15D";
                ToolTip = 'Specifies the number of time sheets that you submitted for approval but were rejected.';
            }
            field("Approved Time Sheets 2"; Rec."Approved Time Sheets")
            {
                ApplicationArea = Basic, Suite;
                DrillDownPageID = "Time Sheet List - 15D";
                ToolTip = 'Specifies the number of time sheets that have been approved.';
            }
        }

    }

    actions
    {
        // Add changes to page actions here

    }

    var
        myInt: Integer;
}