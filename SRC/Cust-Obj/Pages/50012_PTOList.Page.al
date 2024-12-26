page 50012 "Leave Management"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "PTO Details";

    layout
    {
        area(Content)
        {
            repeater(Details)
            {
                field(Year; Rec.Year)
                {
                    ApplicationArea = all;
                }
                field(Month; Rec.Month)
                {
                    ApplicationArea = all;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = all;
                }
                field("Resource No."; Rec."Resource No.")
                {
                    ApplicationArea = all;
                }
                field("Resource Name"; Rec."Resource Name")
                {
                    ApplicationArea = all;
                }
                field("Leave Type"; Rec."Leave Type")
                {
                    ApplicationArea = all;
                }
                field("Opening Balance"; Rec."Opening Balance")
                {
                    ApplicationArea = all;
                }
                field("Current Year Holidays"; Rec."Current Year Balance")
                {
                    ApplicationArea = all;
                }
                field("Current. Utilized"; Rec."Current. Utilized")
                {
                    ApplicationArea = all;
                }
                field("Available Leaves"; Rec."Available Leaves")
                {
                    ApplicationArea = all;
                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(Import)
            {
                ApplicationArea = all;
                Image = UpdateXML;
                Caption = 'Import';
                trigger OnAction()
                begin
                    ReadExcelSheet();
                    ImportExcelData();
                end;
            }
        }
    }

    procedure ReadExcelSheet()
    var
        FileMgt: Codeunit "File Management";
        IStream: InStream;
        FromFile: Text[100];
        UploadExcelMsg: Label 'Please select the File.';
        FileName: Text;
        SheetName: text;
        NoFileFoundMsg: Label 'Nothinhg found.';
    begin
        UploadIntoStream(UploadExcelMsg, '', '', FromFile, IStream);
        if FromFile <> '' then begin
            FileName := FileMgt.GetFileName(FromFile);
            SheetName := TempExcelBuffer.SelectSheetsNameStream(IStream);
        end else
            Error(NoFileFoundMsg);
        TempExcelBuffer.Reset();
        TempExcelBuffer.DeleteAll();
        TempExcelBuffer.OpenBookStream(IStream, SheetName);
        TempExcelBuffer.ReadSheet();
    end;

    procedure ImportExcelData()
    var
        SOImportBuffer: Record "PTO Details";
        RowNo: Integer;
        ColNo: Integer;
        MaxRowNo: Integer;
        YearNo: Integer;
        MonthNo: Integer;
    begin
        RowNo := 0;
        ColNo := 0;
        MaxRowNo := 0;

        TempExcelBuffer.Reset();
        if TempExcelBuffer.FindLast() then begin
            MaxRowNo := TempExcelBuffer."Row No.";
        end;

        for RowNo := 2 to MaxRowNo do begin
            Evaluate(YearNo, GetValueAtCell(RowNo, 1));
            Evaluate(MonthNo, GetValueAtCell(RowNo, 2));
            SOImportBuffer.RESET;
            SOImportBuffer.SetRange(Year, YearNo);
            SOImportBuffer.SetRange(Month, MonthNo);
            SOImportBuffer.SetRange("Employee No.", GetValueAtCell(RowNo, 3));
            SOImportBuffer.SetRange("Leave Type", GetValueAtCell(RowNo, 5));
            IF NOT SOImportBuffer.FINDFIRST THEN BEGIN
                SOImportBuffer.Init();
                Evaluate(SOImportBuffer.Year, GetValueAtCell(RowNo, 1));
                Evaluate(SOImportBuffer.Month, GetValueAtCell(RowNo, 2));
                Evaluate(SOImportBuffer."Employee No.", GetValueAtCell(RowNo, 3));
                Evaluate(SOImportBuffer."Leave Type", GetValueAtCell(RowNo, 5));
                SOImportBuffer.Insert();
            END ELSE
                IF SOImportBuffer.FINDFIRST THEN;
            Evaluate(SOImportBuffer."Resource No.", GetValueAtCell(RowNo, 4));
            SOImportBuffer.Validate("Resource No.");
            Evaluate(SOImportBuffer."Opening Balance", GetValueAtCell(RowNo, 6));
            Evaluate(SOImportBuffer."Current Year Balance", GetValueAtCell(RowNo, 7));
            SOImportBuffer.Validate("Current Year Balance");
            SOImportBuffer.CalcFields("Current. Utilized");
            SOImportBuffer."Available Leaves" := SOImportBuffer."Opening Balance" + SOImportBuffer."Current Year Balance" - SOImportBuffer."Current. Utilized";
            SOImportBuffer.Modify();
        end;
        Message(ExcelImportSucess);
    end;

    local procedure GetValueAtCell(RowNo: Integer; ColNo: Integer): Text
    begin

        TempExcelBuffer.Reset();
        If TempExcelBuffer.Get(RowNo, ColNo) then
            exit(TempExcelBuffer."Cell Value as Text")
        else
            exit('');
    end;

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        Rec."Available Leaves" := Rec."Opening Balance" + rec."Current Year Balance" - Rec."Current. Utilized";
    end;

    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        ExcelImportSucess: Label 'Imported Succesfully.';

}