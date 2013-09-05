unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Grids, XPMan, mmsystem,ShellAPI,
  Menus, jpeg, WSocket,StrUtils;


type
  TForm1 = class(TForm)
    Button1: TButton;
    WSocket1: TWSocket;
    Timer1: TTimer;
    XPManifest1: TXPManifest;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    modname: TLabel;
    Label3: TLabel;
    hostname: TLabel;
    Label4: TLabel;
    mapname: TLabel;
    Label5: TLabel;
    players: TLabel;
    Label6: TLabel;
    lefttime: TLabel;
    GroupBox2: TGroupBox;
    t1: TLabel;
    t2: TLabel;
    Label9: TLabel;
    t1n: TLabel;
    t2n: TLabel;
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    gametype: TLabel;
    ComboBox1: TComboBox;
    Label8: TLabel;
    Timer2: TTimer;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    About1: TMenuItem;
    Start1: TMenuItem;
    Image1: TImage;
    Button2: TButton;
    N2: TMenuItem;
    procedure Button1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure WSocket1DataAvailable(Sender: TObject; ErrCode: Word);
    procedure parseit(str:String);
    function parcing(param,strt:String):String;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Timer2Timer(Sender: TObject);
    procedure ComboBox1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    Procedure Ic(n:Integer;Icon:TIcon);
    procedure N1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
  protected
  procedure ControlWindow(var Msg: TMessage); message WM_SYSCOMMAND;
  procedure IconMouse(var Msg: TMessage); message WM_USER + 1; 
  private
    { Private declarations }

  public
    { Public declarations }
  end;

  tplayer=record
  team:Boolean;
  name,hash:String;
  score,kills,deaths,ping:Integer;
  end;


var
  Form1: TForm1;
  wtmps,premap,trtip,bfmod,bftyp: String;
  plrs: Byte;
  numb:Byte;
  trayed:Boolean;
  
implementation

{$R *.dfm}

uses Unit2;

procedure TForm1.Button1Click(Sender: TObject);
var i,t:byte;
chk:Boolean;
madr:String;
mport:Integer;
begin
If button1.Caption='Start' then
  begin
  t:=Pos(':',ComboBox1.Text);
  if (t>0) then
    begin
    madr:=MidStr(ComboBox1.Text,1,t-1);
    mport:=StrToInt(MidStr(ComboBox1.Text,t+1,99));
    end else
    begin
    mport:=Form2.SpinEdit2.Value;
    madr:=ComboBox1.Text;
    end;

  WSocket1.Proto:= 'udp';
  WSocket1.Addr:=madr;
  WSocket1.Port:=IntToStr(mport);
  WSocket1.LocalAddr:= '0.0.0.0';
  WSocket1.LocalPort:= '23005';
  Image1.Visible:=true;
  try
  WSocket1.Connect;
  except
  exit;
  end;
  chk:=true;
  numb:=20;
  for i:=0 to ComboBox1.Items.Count do
    if combobox1.Items[i]=ComboBox1.Text then chk:=false;
  if chk=true then
  ComboBox1.Items.Add(ComboBox1.Text);

  Button1.Caption:='Stop';
  Start1.Caption:='Stop';
  Timer1.Enabled:=true;
  end else
  begin
  Image1.Picture.LoadFromFile('img\no.jpg');
  trtip:='Монитор остановлен';
  Ic(3,Application.Icon);
  premap:='';
  Timer2.Enabled:=false;
  Label8.Caption:='';
  gametype.caption:='';
  lefttime.caption:='';
  hostname.Caption:='';
  mapname.Caption:='';
  modname.Caption:='';
  players.Caption:='';
  t1.Caption:='Команда 1';
  t1n.Caption:='';
  t2.Caption:='Команда 2';
  t2n.Caption:='';
  Timer1.Enabled:=false;
  WSocket1.Close;
  Button1.Caption:='Start';
  Start1.Caption:='Start';
  plrs:=0;
  StringGrid1.RowCount:=2;
  StringGrid2.RowCount:=2;
  for i:=0 to 4 do
    begin
    StringGrid1.Rows[1][i]:='';
    StringGrid2.Rows[1][i]:='';
    end;
  end;
end;






function TForm1.parcing(param, strt: String): String;
var
i,f:integer;           //   Функция для извлечения конкретного параметра
tmp:String;
tm:Boolean;
begin
tm:=true;
f:=pos(param,strt);
if f>0 then
  begin
  i:=f+length(param)+1;
  while tm do
    begin
    tmp:=tmp+strt[i];
    if strt[i+1]='\' then tm:=false;
    i:=i+1;
    end;
  end;
result:=tmp;
end;






procedure TForm1.parseit(str: String);
var tmp,smin,ssec:String;
min,sec,i,j:Byte;                //   Основная функция для извлечения из запроса
osp,alp:Byte;                  //  полезных данных. Использует parcing
all:integer;
allplrs: array[0..64] of tplayer;
tmppl: tplayer;
begin

tmp:=parcing('gameId',str);      // Извлекаем ID игры
if length(tmp)>0 then
begin
bfmod:=tmp;
if tmp='dc_final' then modname.Caption:='Desert Combat Final' else
if tmp='bf1942' then modname.Caption:='Battlefield 1942' else
modname.Caption:=tmp;
end;

tmp:=parcing('gametype',str);     // Извлекаем тип
if length(tmp)>0 then
begin
bftyp:=tmp;
if tmp='conquest' then gametype.Caption:='Conquest' else
if tmp='ctf' then gametype.Caption:='CTF, захват флага.' else
modname.Caption:=tmp;
end;


tmp:=parcing('hostname',str);    // Имя сервера
if length(tmp)>0 then
hostname.Caption:=tmp;

tmp:=parcing('mapname',str);    // Имя карты
if length(tmp)>0 then
mapname.Caption:=tmp;


if (not (tmp=premap)) then
  begin
  if FileExists('img\'+bfmod+'\'+mapname.Caption+'.jpg') then
     Image1.Picture.LoadFromFile('img\'+bfmod+'\'+mapname.Caption+'.jpg') else
  if FileExists('img\no.jpg') then
     Image1.Picture.LoadFromFile('img\no.jpg');


                       // Будильник по названию карты
  if (Form2.CheckBox1.Checked) and (pos(Form2.Edit2.Text,tmp)>0) then
    begin
    timer2.Enabled:=true;
    Form2.CheckBox1.Checked:=False;
    end;
                       //******************************

  end;
premap:=tmp;



tmp:=parcing('roundTimeRemain',str);
if length(tmp)>0 then            //  Оставшееся время
  begin
  all:=StrToInt(tmp);
  min:=all div 60;
  if min<10 then smin:='0'+FloatToStr(min) else smin:=FloatToStr(min);
  sec:=all-min*60;
  if sec<10 then ssec:='0'+FloatToStr(sec) else ssec:=FloatToStr(sec);
  lefttime.Caption:=smin+':'+ssec;


                      // Будильник по новой карте
  if (Form2.CheckBox3.Checked) and (all=0) then
    begin
    Timer2.Enabled:=True;
    Form2.CheckBox3.Checked:=False;
    end;
                     //***************************

  end;




    //  Тут определяем какая команда ось, а какая союзники

tmp:=parcing('axis_team_ratio',str);
if length(tmp)>0 then
if tmp='1' then
begin
t2.Caption:='Союзники';
t2n.Font.Color:=clNavy;
t1.Caption:='Ось';
t1n.Font.Color:=clMaroon;
end else
begin
t1.Caption:='Союзники';
t1n.Font.Color:=clNavy;
t2.Caption:='Ось';
t2n.Font.Color:=clMaroon;
end;


tmp:=parcing('tickets1',str);
if length(tmp)>0 then
t1n.Caption:=tmp;

tmp:=parcing('tickets2',str);
if length(tmp)>0 then
t2n.Caption:=tmp;

//        ======


trtip:='Карта: '+mapname.Caption+#13+'Игроков: '+FloatToStr(plrs)+#13+'Счёт: '+t1n.Caption+' - '+t2n.Caption+#13+'Осталось: '+lefttime.Caption;


//         Выводим список игроков:

numb:=numb+1;

if numb>10 then
begin
numb:=0;

If (trayed=true) then
  Ic(3,Application.Icon);  //     Если в трее, то обновим!

if plrs>0 then
begin
for i:=0 to plrs-1 do
  begin

  //    Заносим в массив:

  tmp:=parcing('team_'+FloatToStr(i),str);
  if tmp='1' then allplrs[i].team:=True else allplrs[i].team:=False;
  tmp:=parcing('playername_'+FloatToStr(i),str);
  allplrs[i].name:=tmp;
  tmp:=parcing('score_'+FloatToStr(i),str);
  allplrs[i].score:=StrToInt(tmp);
  tmp:=parcing('kills_'+FloatToStr(i),str);
  allplrs[i].kills:=StrToInt(tmp);
  tmp:=parcing('deaths_'+FloatToStr(i),str);
  allplrs[i].deaths:=StrToInt(tmp);
  tmp:=parcing('ping_'+FloatToStr(i),str);
  allplrs[i].ping:=StrToInt(tmp);
  tmp:=parcing('hash_'+FloatToStr(i),str);
  allplrs[i].hash:=tmp;
  end;

  //      ==============
  //        Сортируем:

for i:=0 to plrs-1 do
  for j:=i to plrs-1 do
    if allplrs[i].score<allplrs[j].score then
      begin
      tmppl:=allplrs[i];
      allplrs[i]:=allplrs[j];
      allplrs[j]:=tmppl;
      end;

  //      ==============
  //    Выводим в таблицу:

for i:=0 to plrs-1 do
  begin

  if allplrs[i].team=True then
      begin
      osp:=osp+1;
      StringGrid1.RowCount:=osp+1;
      StringGrid1.Rows[osp][0]:=allplrs[i].name;
      StringGrid1.Rows[osp][1]:=FloatToStr(allplrs[i].score);
      StringGrid1.Rows[osp][2]:=FloatToStr(allplrs[i].kills);
      StringGrid1.Rows[osp][3]:=FloatToStr(allplrs[i].deaths);
      StringGrid1.Rows[osp][4]:=FloatToStr(allplrs[i].ping);
      end else
      begin
      alp:=alp+1;
      StringGrid2.RowCount:=alp+1;
      StringGrid2.Rows[alp][0]:=allplrs[i].name;
      StringGrid2.Rows[alp][1]:=FloatToStr(allplrs[i].score);
      StringGrid2.Rows[alp][2]:=FloatToStr(allplrs[i].kills);
      StringGrid2.Rows[alp][3]:=FloatToStr(allplrs[i].deaths);
      StringGrid2.Rows[alp][4]:=FloatToStr(allplrs[i].ping);
      end;


  end;

  if (osp-alp)>1 then
    begin
    Label8.Font.Color:=clRed;
    Label8.Caption:='Unbalanced';
    end else
    begin
    Label8.Font.Color:=clGreen;
    Label8.Caption:='Balanced';
    end;
 

end;
end;



end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
try
WSocket1.SendStr('\status\');      // Основная команда, при отправке которой
                              //  на серер, он выдаёт нам всё информацию
except
Button1.Click;
Timer1.Enabled:=False;
end;
end;

procedure TForm1.WSocket1DataAvailable(Sender: TObject; ErrCode: Word);
var tmp,tmps:String;
begin
tmps:=WSocket1.ReceiveStr;    //  Получаем строку с ответом

//Label2.Caption:=tmps;

wtmps:=wtmps+tmps;           //Сохраняем полученные данные, для дальнейшей обработки

tmp:=parcing('numplayers',wtmps);    //  Получаем количество игроков


if length(tmp)>0 then
  begin
  players.Caption:=tmp;
  plrs:=StrToInt(tmp);

                       // Будильник по количеству человек
  if (Form2.CheckBox2.Checked) and (plrs>=Form2.SpinEdit1.Value) then
    begin
    timer2.Enabled:=true;
    Form2.CheckBox2.Checked:=False;
    end;
                       //********************************
  end;

if ((pos('playername_'+FloatToStr(plrs-1),wtmps)>1) or (plrs=0)) then
  begin
  parseit(wtmps);     //    Если игроков 0, или-же игроков не 0, и
  wtmps:='';          // при этом мы получили информацию об игроках
  end;                // то это означает что пришли все данные, и
                      // мы можем начать парсить их!

end;

procedure TForm1.FormCreate(Sender: TObject);
var
f:TextFile;
tmp:String;
begin
trtip:='Монитор остановлен';
trayed:=false;    
form1.Top:=Round(Screen.Height/2-Form1.Height/2);
form1.Left:=Round(Screen.Width/2-Form1.Width/2);

StringGrid1.Rows[0][0]:='Игрок';
StringGrid1.Rows[0][1]:='Очк.';
StringGrid1.Rows[0][2]:='Уб.';
StringGrid1.Rows[0][3]:='См.';
StringGrid1.Rows[0][4]:='Пнг.';

StringGrid2.Rows[0][0]:='Игрок';
StringGrid2.Rows[0][1]:='Очк.';
StringGrid2.Rows[0][2]:='Уб.';
StringGrid2.Rows[0][3]:='См.';
StringGrid2.Rows[0][4]:='Пнг.';

try
AssignFile(f,'conf.ini');
Reset(f);
readln(f,tmp);
ComboBox1.Text:=tmp;
While not EOF(f) do
  begin
  readln(f,tmp);
  if (not (tmp='')) then
  ComboBox1.Items.Add(tmp);
  end;
CloseFile(f);
except
end;

end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
var
f:TextFile;
i:Byte;
begin
If button1.Caption='Stop' then
  button1.Click;

AssignFile(f,'conf.ini');
Rewrite(f);
Writeln(f,ComboBox1.Text);
if (not (ComboBox1.Items.Count=0)) then
for i:=0 to ComboBox1.Items.Count-1 do
  begin
  if (not (combobox1.Items[i]='')) then
  Writeln(f,combobox1.Items[i]);
  end;
CloseFile(f);
Ic(2, Application.Icon);
end;

procedure TForm1.Timer2Timer(Sender: TObject);
var
  str,Windir: string;       //  Звенит будильник
  WindirP: PChar;
begin
WinDirP := StrAlloc(MAX_PATH);
GetWindowsDirectory(WinDirP, MAX_PATH);
WinDir := StrPas(WinDirP);
str:=windir+'\Media\ringin.wav';
PlaySound(PChar(str), 0, SND_ASYNC);
              //   Получаем путь к папке windows и проигрываем звонок,
              // который в ней лежит. Это чтоб не увеличивать архив с
              // программой.
end;

procedure TForm1.ComboBox1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
If key=13 then
    Button1Click(Sender);
    // Если пользователь нажмёт на Enter, это будет равносильно нажатию на кнопку
end;

procedure TForm1.Ic(n: Integer; Icon: TIcon);
Var  Nim:TNotifyIconData;
  i:Byte;
begin
With Nim do
  Begin
  cbSize:=SizeOf(Nim);
  Wnd:=Form1.Handle;
  uID:=1;
  uFlags:=NIF_ICON or NIF_MESSAGE or NIF_TIP;
  hicon:=Icon.Handle;
  uCallbackMessage:=wm_user+1;
  for i:=1 to length(trtip) do szTip[i-1]:=trtip[i];
  for i:=length(trtip) to length(szTip)-1 do szTip[i]:=Char(0);
  End;

Case n OF
  1: Shell_NotifyIcon(Nim_Add,@Nim);
  2: Shell_NotifyIcon(Nim_Delete,@Nim);
  3: Shell_NotifyIcon(Nim_Modify,@Nim);
End;

end;

procedure TForm1.ControlWindow(var Msg: TMessage);
begin
if Msg.WParam = SC_MINIMIZE then
begin
trayed:=True;
Ic(1, Application.Icon); // Добавляем значок в трей
ShowWindow(Application.Handle, SW_HIDE); // Скрываем программу
ShowWindow(Handle, SW_HIDE); // Скрываем программу
end
else
inherited;
end; 

procedure TForm1.N1Click(Sender: TObject);
begin
Form1.Close;
end;

procedure TForm1.IconMouse(var Msg: TMessage);
var p: tpoint;
begin
GetCursorPos(p); // Запоминаем координаты курсора мыши
case Msg.LParam of // Проверяем какая кнопка была нажата
  WM_LBUTTONUP, WM_LBUTTONDBLCLK: {Действия, выполняемый по одинарному или двойному щел?ку левой кнопки мыши на зна?ке. В нашем слу?ае это просто активация приложения}
    begin
    trayed:=false;
    Ic(2, Application.Icon); // Удаляем значок из трея
    ShowWindow(Application.Handle, SW_SHOW); // Восстанавливаем окно программы
    ShowWindow(Handle, SW_SHOW); // Восстанавливаем окно программы
    end;
  WM_RBUTTONUP: {Действия, выполняемый по одинарному щелчку правой кнопки мыши}
    begin
    SetForegroundWindow(Handle); // Восстанавливаем программу в качестве переднего окна
    PopupMenu1.Popup(p.X, p.Y); // Заставляем всплыть тот самый TPopUp о котором я говорил ?уть раньше
    PostMessage(Handle, WM_NULL, 0, 0) // Обнуляем сообщение
    end;
  end;
end;

procedure TForm1.About1Click(Sender: TObject);   // Окно о программе:
begin
Application.MessageBox(PChar('BFMon v1.5, 2009'+#13+'by bak'+#13+'Для UAPLAYER.com'+#13+'& bf.maxnet.ua'),'О Программе');
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
Form2.Show;    // Показываем окно с настройками
end;

procedure TForm1.N2Click(Sender: TObject);
begin
Timer2.Enabled:=False;     // Останавливаем звонок будильника
end;

end.
