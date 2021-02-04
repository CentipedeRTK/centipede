//---------------------------------------------------------------------------
#ifndef getmainH
#define getmainH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <Buttons.hpp>
#include <ComCtrls.hpp>
#include <ExtCtrls.hpp>
#include <FileCtrl.hpp>
#include <Vcl.Dialogs.hpp>
#include <Vcl.Graphics.hpp>
#ifdef TCPP
#include <vcl\inifiles.hpp>
#else
#include <inifiles.hpp>
#endif
#include "viewer.h"
#include "rtklib.h"

//---------------------------------------------------------------------------
class TMainForm : public TForm
{
__published:
	TPanel *Panel2;
	TPanel *Panel3;
	TPanel *Msg1;
	TPanel *Msg3;
	TButton *BtnDir;
	TListBox *DataList;
	TComboBox *DataType;
	TPanel *Msg2;
	TLabel *LabelSta;
	TOpenDialog *OpenDialog;
	TListBox *StaList;
	TPanel *Panel4;
	TLabel *Label4;
	TEdit *FtpLogin;
	TEdit *FtpPasswd;
	TLabel *Label8;
	TSaveDialog *SaveDialog;
	TButton *BtnStas;
	TCheckBox *HidePasswd;
	TTimer *Timer;
	TImage *Image1;
	TImage *Image2;
	TImage *Image3;
	TImage *Image4;
	TTrayIcon *TrayIcon;
	TComboBox *SubType;
	TSpeedButton *BtnTray;
	TSpeedButton *BtnHelp;
	TImage *Image5;
	TImage *Image6;
	TImage *Image7;
	TImage *Image8;
	TButton *BtnAll;
	TComboBox *Dir;
	TLabel *MsgLabel2;
	TLabel *MsgLabel1;
	TLabel *MsgLabel3;
	TButton *BtnFile;
	TButton *BtnLog;
	TButton *BtnOpts;
	TButton *BtnTest;
	TButton *BtnDownload;
	TButton *BtnExit;
	TPanel *Panel5;
	TPanel *Panel6;
	TPanel *Panel7;
	TPanel *Panel8;
	TPanel *Panel9;
	TPanel *Panel10;
	TPanel *Panel11;
	TPanel *Panel12;
	TLabel *Label1;
	TEdit *TimeY1;
	TUpDown *TimeY1UD;
	TEdit *TimeH1;
	TUpDown *TimeH1UD;
	TSpeedButton *BtnTime1;
	TPanel *Panel13;
	TLabel *Label3;
	TEdit *TimeY2;
	TUpDown *TimeY2UD;
	TEdit *TimeH2;
	TUpDown *TimeH2UD;
	TSpeedButton *BtnTime2;
	TPanel *Panel14;
	TLabel *Label7;
	TComboBox *TimeInt;
	TEdit *Number;
	TLabel *Label2;
	TPanel *Panel15;
	TPanel *Panel1;
	TCheckBox *SkipExist;
	TCheckBox *UnZip;
	TCheckBox *LocalDir;
	TSpeedButton *BtnKeyword;
	TPanel *Panel16;
	TPanel *Panel17;
	TPanel *Panel18;
	
	void __fastcall TimeY1UDChangingEx(TObject *Sender, bool &AllowChange,
          int NewValue, TUpDownDirection Direction);
	void __fastcall TimeH1UDChangingEx(TObject *Sender, bool &AllowChange,
          int NewValue, TUpDownDirection Direction);
	void __fastcall TimeY2UDChangingEx(TObject *Sender, bool &AllowChange,
          int NewValue, TUpDownDirection Direction);
	void __fastcall TimeH2UDChangingEx(TObject *Sender, bool &AllowChange,
          int NewValue, TUpDownDirection Direction);
	void __fastcall BtnExitClick(TObject *Sender);
	void __fastcall BtnOptsClick(TObject *Sender);
	void __fastcall BtnLogClick(TObject *Sender);
	void __fastcall BtnDownloadClick(TObject *Sender);
	void __fastcall DataTypeChange(TObject *Sender);
	void __fastcall FormShow(TObject *Sender);
	void __fastcall FormClose(TObject *Sender, TCloseAction &Action);
	void __fastcall BtnFileClick(TObject *Sender);
	void __fastcall DataListClick(TObject *Sender);
	void __fastcall BtnDirClick(TObject *Sender);
	void __fastcall LocalDirClick(TObject *Sender);
	void __fastcall BtnStasClick(TObject *Sender);
	void __fastcall BtnTime1Click(TObject *Sender);
	void __fastcall BtnTime2Click(TObject *Sender);
	void __fastcall BtnKeywordClick(TObject *Sender);
	void __fastcall BtnHelpClick(TObject *Sender);
	void __fastcall HidePasswdClick(TObject *Sender);
	void __fastcall TimerTimer(TObject *Sender);
	void __fastcall BtnTrayClick(TObject *Sender);
	void __fastcall TrayIconDblClick(TObject *Sender);
	void __fastcall BtnTestClick(TObject *Sender);
	void __fastcall StaListClick(TObject *Sender);
	void __fastcall FormCreate(TObject *Sender);
	void __fastcall BtnAllClick(TObject *Sender);
	void __fastcall DirChange(TObject *Sender);
	void __fastcall Panel3Resize(TObject *Sender);
	void __fastcall Panel2Resize(TObject *Sender);
	void __fastcall Panel6Resize(TObject *Sender);
	void __fastcall ComboCloseUp(TObject *Sender);
	void __fastcall TimeY1KeyDown(TObject *Sender, WORD &Key, TShiftState Shift);
	void __fastcall TimeH1KeyDown(TObject *Sender, WORD &Key, TShiftState Shift);
	void __fastcall TimeH2KeyDown(TObject *Sender, WORD &Key, TShiftState Shift);
	void __fastcall TimeY2KeyDown(TObject *Sender, WORD &Key, TShiftState Shift);
	void __fastcall TimeIntChange(TObject *Sender);
	
private:
    TTextViewer *LogViewer;
	TStringList *Types;
	TStringList *Urls;
	TStringList *Locals;
	
	void __fastcall DropFiles(TWMDropFiles msg);
	void __fastcall LoadOpt(void);
	void __fastcall SaveOpt(void);
	void __fastcall UpdateType(void);
	void __fastcall UpdateMsg(void);
	void __fastcall UpdateStaList(void);
	void __fastcall UpdateEnable(void);
	void __fastcall PanelEnable(int ena);
	void __fastcall GetTime(gtime_t *ts, gtime_t *te, double *ti);
	int  __fastcall SelectUrl(url_t *urls);
	int  __fastcall SelectSta(char **stas);
	void __fastcall LoadUrl(AnsiString file);
	void __fastcall LoadSta(AnsiString file);
	int  __fastcall ExecCmd(AnsiString cmd);
	void __fastcall ReadHist(TIniFile *ini, AnsiString key, TStrings *list);
	void __fastcall WriteHist(TIniFile *ini, AnsiString key, TStrings *list);
	void __fastcall AddHist(TComboBox *combo);
	
	BEGIN_MESSAGE_MAP
	MESSAGE_HANDLER(WM_DROPFILES,TWMDropFiles,DropFiles);
	END_MESSAGE_MAP(TForm);
	
public:
	AnsiString IniFile;
	AnsiString UrlFile;
	AnsiString LogFile;
	AnsiString Stations;
	AnsiString ProxyAddr;
	int HoldErr;
	int HoldList;
	int NCol;
	int DateFormat;
	int TraceLevel;
	int LogAppend;
	int TimerCnt;
	__fastcall TMainForm(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TMainForm *MainForm;
//---------------------------------------------------------------------------
#endif
