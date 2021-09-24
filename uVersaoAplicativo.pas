unit uVersaoAplicativo;

interface

uses
   Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes;

type
   TVersaoAplicativo = class
   public
      class function GetVersaoAplicacao: string;
   end;

implementation

class function TVersaoAplicativo.GetVersaoAplicacao: string;
var
   LVerInfoSize: DWORD;
   LVerInfo: Pointer;
   LVerValueSize: DWORD;
   LVerValue: PVSFixedFileInfo;
   LHandle: DWORD;
begin
   LVerInfoSize := GetFileVersionInfoSize(PChar(ParamStr(0)), LHandle);
   GetMem(LVerInfo, LVerInfoSize);
   GetFileVersionInfo(PChar(ParamStr(0)), 0, LVerInfoSize, LVerInfo);
   VerQueryValue(LVerInfo, '\', Pointer(LVerValue), LVerValueSize);

   with LVerValue^ do
   begin
      Result := IntToStr(dwFileVersionMS shr 16);
      Result := Result + '.' + IntToStr(dwFileVersionMS and $FFFF);
      Result := Result + '.' + IntToStr(dwFileVersionLS shr 16);
      Result := Result + '.' + IntToStr(dwFileVersionLS and $FFFF);
   end;

   FreeMem(LVerInfo, LVerInfoSize);
end;

end.
