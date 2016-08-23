unit RotaImg;

{$mode objfpc}{$H+}

interface

uses
  ExtCtrls, Graphics;

//rotar imagen en sentido antihorario 90 grados
procedure RotateBitmap90(const bitmap: TBitmap);

//rotar imagen en sentido horario 90 grados
procedure RotateBitmap180(const bitmap: TBitmap);

implementation

uses
  IntfGraphics, LCLType;

procedure RotateBitmap90(const bitmap: TBitmap);
var
  tmp: TBitmap;
  src, dst: TLazIntfImage;
  ImgHandle, ImgMaskHandle: HBitmap;
  i, j, w, h: integer;
begin
  tmp := TBitmap.create;
  tmp.Width := Bitmap.Height;
  tmp.Height := Bitmap.Width;
  dst := TLazIntfImage.Create(0, 0);
  dst.LoadFromBitmap(tmp.Handle, tmp.MaskHandle);
  src := TLazIntfImage.Create(0, 0);
  src.LoadFromBitmap(bitmap.Handle, bitmap.MaskHandle);
  w := bitmap.width - 1;
  h := bitmap.height - 1;
  for i := 0 to w do
    for j := 0 to h do
      dst.Colors[j, w - i] := src.Colors[i, j];
  dst.CreateBitmaps(ImgHandle, ImgMaskHandle, false);
  tmp.Handle := ImgHandle;
  tmp.MaskHandle := ImgMaskHandle;
  dst.Free;
  bitmap.Assign(tmp);
  tmp.Free;
  src.Free;
end;

procedure RotateBitmap180(const bitmap: TBitmap);
var
  tmp: TBitmap;
  src, dst: TLazIntfImage;
  ImgHandle, ImgMaskHandle: HBitmap;
  i, j, w, h: integer;
begin
  tmp := TBitmap.create;
  tmp.Width := Bitmap.Height;
  tmp.Height := Bitmap.Width;
  dst := TLazIntfImage.Create(0, 0);
  dst.LoadFromBitmap(tmp.Handle, tmp.MaskHandle);
  src := TLazIntfImage.Create(0, 0);
  src.LoadFromBitmap(bitmap.Handle, bitmap.MaskHandle);
  w := bitmap.width - 1;
  h := bitmap.height - 1;
  for i := 0 to w do
    for j := 0 to h do
      dst.Colors[h - j, i] := src.Colors[i, j];
  dst.CreateBitmaps(ImgHandle, ImgMaskHandle, false);
  tmp.Handle := ImgHandle;
  tmp.MaskHandle := ImgMaskHandle;
  dst.Free;
  bitmap.Assign(tmp);
  tmp.Free;
  src.Free;
end;

end.

