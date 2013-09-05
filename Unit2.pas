unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin;

type
  TForm2 = class(TForm)
    Label1: TLabel;
    GroupBox1: TGroupBox;
    Edit2: TEdit;
    CheckBox1: TCheckBox;
    SpinEdit1: TSpinEdit;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    Button1: TButton;
    SpinEdit2: TSpinEdit;
    procedure CheckBox1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

uses Unit1;


procedure TForm2.CheckBox1Click(Sender: TObject);
begin
If CheckBox1.Checked=false then
  Form1.Timer2.Enabled:=false;
end;

procedure TForm2.Button1Click(Sender: TObject);
begin
Form2.Close;
end;

end.
