report 50008 "Charge Activity by Employee"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = LayoutName;
    dataset
    {
        dataitem("Time Sheet Header"; "Time Sheet Header")
        {
            RequestFilterFields = "Resource No.";
            column(CompInfoPicture; CompInfo.Picture) { }
            column(CompInfoName; CompInfo.Name) { }
            column(CompInfoAdd; CompInfo.Address) { }
            column(CompInfoAdd2; CompInfo."Address 2") { }
            column(CompInfopostCode; CompInfo."Post Code") { }
            column(ReportCaptlbl; ReportCaptlbl) { }
            column(EmplyNamelbl; EmplyNamelbl) { }
            column(AccountIDlbl; AccountIDlbl) { }
            column(OrgIDlbl; OrgIDlbl) { }
            column(ProjectIDlbl; ProjectIDlbl) { }
            column(HoursDatelbl; HoursDatelbl) { }
            column(EnteredHourslbl; EnteredHourslbl) { }
            column(CommentsLbl; CommentsLbl) { }
            column(Resource_No_; "Resource No.")
            {

            }
            column(Resource_Name; "Resource Name")
            {

            }


            dataitem("Time Sheet Detail"; "Time Sheet Detail")
            {
                DataItemLink = "Time Sheet No." = field("No.");
                RequestFilterFields = Date;
                column(Date; Date)
                {

                }
                column(Job_No_; "Job No.")
                {

                }
                column(Quantity; Quantity)
                {

                }
                column(ResacctID; projPostGrp."Resource Costs Applied Account")
                {

                }

                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                begin
                    if Project.get("Time Sheet Detail"."Job No.") THEN begin
                        IF projPostGrp.get(Project."Job Posting Group") THEN;
                    end;
                end;
            }
            trigger OnAfterGetRecord()
            var
                myInt: Integer;
            begin
                Clear(Res);
                IF Res.get("Resource No.") then;

            end;
        }
    }

    requestpage
    {
        AboutTitle = 'Teaching tip title';
        AboutText = 'Teaching tip content';
        layout
        {
            area(Content)
            {
                group(Action)
                {

                }
            }
        }

    }

    rendering
    {
        layout(LayoutName)
        {
            Type = RDLC;
            LayoutFile = './SRC/Cust-Obj/Reports/Layout/Timesheet.rdl';
        }
    }

    var
        Res: Record Resource;
        CompInfo: Record "Company Information";
        ReportCaptlbl: Label 'Charge Activity by Employee';
        EmplyNamelbl: Label 'Employee Name';
        AccountIDlbl: Label 'Account ID';
        OrgIDlbl: Label 'Ord ID';
        ProjectIDlbl: Label 'Project ID';
        HoursDatelbl: Label 'Hours Date';
        EnteredHourslbl: Label 'Entered Hours';
        CommentsLbl: Label 'Comments';
        Project: Record Job;
        projPostGrp: Record "Job Posting Group";

    trigger OnInitReport()
    var
        myInt: Integer;
    begin
        CompInfo.get();
        CompInfo.CalcFields(Picture);
    end;

}