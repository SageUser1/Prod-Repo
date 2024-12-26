table 50003 "Sub-Con Invoice Processed"
{
    DataClassification = CustomerContent;
    Caption = 'Sub-Con Invoice Processed';

    fields
    {
        field(1; "Document No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(2; "Vendor No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Vendor;
        }
        field(3; "Vendor Name"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(4; "Vendor Invoice No."; Code[30])
        {
            DataClassification = CustomerContent;
        }
        field(5; "Posting Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(6; Month; Enum "Recurrence - Month")
        {
            Caption = 'Month';
            DataClassification = CustomerContent;
        }
        field(7; Year; Integer)
        {
            Caption = 'Year';
            DataClassification = CustomerContent;

        }
        field(8; "Job No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(9; "Job Task No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(10; Description; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(11; "Line Type"; Enum "Job Planning Line Line Type")
        {
            DataClassification = CustomerContent;
        }
        field(12; Type; Enum "Job Planning Line Type")
        {
            Caption = 'Type';
        }
        field(13; "No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(14; Quantity; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(15; "Unit Cost"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(16; "Line Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(17; "Qty. Transfer to Purch. Inv"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(18; "Qty. Transferred to Purch. Inv"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(19; "Qty. Purchase Invoiced"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(20; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(21; "No. Series"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(22; "Job Task Line No."; Integer)
        {

        }
        field(23; "Sub-Con Invoice No."; Code[20])
        {

        }
        field(24; "Sub-Con Invoice Line No."; Integer)
        {

        }
        field(25; "Remaining Qty."; Decimal)
        {

        }
    }

    keys
    {
        key(Key1; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }
}