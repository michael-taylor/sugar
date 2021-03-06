﻿namespace Sugar;

interface

type
  Convert = public static class 
  private
    {$IF NOUGAT}
    method ParseNumberInvariant(aValue: not nullable String): NSNumber;
    method ParseInt32(aValue: not nullable String): Int32;  
    method ParseInt64(aValue: not nullable String): Int64; 
    method ParseDouble(aValue: not nullable String): Double;
    {$ENDIF}

    method TrimLeadingZeros(aValue: not nullable String): not nullable String; inline;
    method DigitForValue(aValue: Int32): Char; inline;
  public
    method ToString(aValue: Boolean): not nullable String;
    method ToString(aValue: Byte; aBase: Integer := 10): not nullable String;
    method ToString(aValue: Int32; aBase: Integer := 10): not nullable String;
    method ToString(aValue: Int64; aBase: Integer := 10): not nullable String;
    method ToString(aValue: Double; aDigitsAfterDecimalPoint: Integer := -1): not nullable String;
    method ToString(aValue: Char): not nullable String;
    method ToString(aValue: Object): not nullable String;

    method ToInt32(aValue: Boolean): Int32;
    method ToInt32(aValue: Byte): Int32;
    method ToInt32(aValue: Int64): Int32;
    method ToInt32(aValue: Double): Int32;
    method ToInt32(aValue: Char): Int32;
    method ToInt32(aValue: not nullable String): Int32;

    method ToInt64(aValue: Boolean): Int64;
    method ToInt64(aValue: Byte): Int64;
    method ToInt64(aValue: Int32): Int64;
    method ToInt64(aValue: Double): Int64;
    method ToInt64(aValue: Char): Int64;
    method ToInt64(aValue: not nullable String): Int64;

    method ToDouble(aValue: Boolean): Double;
    method ToDouble(aValue: Byte): Double;
    method ToDouble(aValue: Int32): Double;
    method ToDouble(aValue: Int64): Double;
    method ToDoubleInvariant(aValue: not nullable String): Double;

    method ToByte(aValue: Boolean): Byte;
    method ToByte(aValue: Double): Byte;
    method ToByte(aValue: Int32): Byte;
    method ToByte(aValue: Int64): Byte;
    method ToByte(aValue: Char): Byte;
    method ToByte(aValue: not nullable String): Byte;

    method ToChar(aValue: Boolean): Char;
    method ToChar(aValue: Int32): Char;
    method ToChar(aValue: Int64): Char;
    method ToChar(aValue: Byte): Char;
    method ToChar(aValue: not nullable String): Char;

    method ToBoolean(aValue: Double): Boolean;
    method ToBoolean(aValue: Int32): Boolean;
    method ToBoolean(aValue: Int64): Boolean;
    method ToBoolean(aValue: Byte): Boolean;
    method ToBoolean(aValue: not nullable String): Boolean;
    
    //method ToHexString(aValue: Int32; aWidth: Integer := 0): not nullable String;
    method ToHexString(aValue: UInt64; aWidth: Integer := 0): not nullable String;
    method ToHexString(aData: array of Byte; aOffset: Integer; aCount: Integer): not nullable String;
    method ToHexString(aData: array of Byte; aCount: Integer): not nullable String;
    method ToHexString(aData: array of Byte): not nullable String;
    method ToHexString(aData: Binary): not nullable String;

    method ToOctalString(aValue: Int64; aWidth: Integer := 0): not nullable String;
    method ToBinaryString(aValue: Int64; aWidth: Integer := 0): not nullable String;

    method HexStringToInt32(aValue: not nullable String): UInt32;
    method HexStringToInt64(aValue: not nullable String): UInt64;
    method HexStringToByteArray(aData: not nullable String): array of Byte;
  end;

implementation

method Convert.ToString(aValue: Boolean): not nullable String;
begin
  result := if aValue then Consts.TrueString else Consts.FalseString;
end;

method Convert.ToString(aValue: Byte; aBase: Integer := 10): not nullable String;
begin
  {$IF COOPER OR NOUGAT}
  case aBase of
    2: exit ToBinaryString(aValue);
    8: exit ToOctalString(aValue);
    10: exit aValue.ToString as not nullable;
    16: exit ToHexString(aValue);
    else raise new SugarException('Unsupported base for ToString.');
  end;
  {$ELSEIF ECHOES}
  exit System.Convert.ToString(aValue, aBase) as not nullable;
  {$ENDIF}
end;

method Convert.ToString(aValue: Int32; aBase: Integer := 10): not nullable String;
begin
  {$IF COOPER OR NOUGAT}
  case aBase of
    2: exit ToBinaryString(aValue);
    8: exit ToOctalString(aValue);
    10: exit aValue.ToString as not nullable;
    16: exit ToHexString(aValue);
    else raise new SugarException('Unsupported base for ToString.');
  end;
  {$ELSEIF ECHOES}
  exit System.Convert.ToString(aValue, aBase) as not nullable;
  {$ENDIF}
end;

method Convert.ToString(aValue: Int64; aBase: Integer := 10): not nullable String;
begin
  {$IF COOPER OR NOUGAT}
  case aBase of
    2: exit ToBinaryString(aValue);
    8: exit ToOctalString(aValue);
    10: exit aValue.ToString as not nullable;
    16: exit ToHexString(aValue);
    else raise new SugarException('Unsupported base for ToString.');
  end;
  {$ELSEIF ECHOES}
  exit System.Convert.ToString(aValue, aBase) as not nullable;
  {$ENDIF}
end;

method Convert.ToString(aValue: Double; aDigitsAfterDecimalPoint: Integer := -1): not nullable String;
begin
  if Consts.IsNegativeInfinity(aValue) then
    exit "-Infinity";

  if Consts.IsPositiveInfinity(aValue) then
    exit "Infinity";

  if Consts.IsNaN(aValue) then
    exit "NaN";

  {$IF COOPER}
  var DecFormat: java.text.DecimalFormat := java.text.DecimalFormat(java.text.DecimalFormat.getInstance(Sugar.Cooper.LocaleUtils.ForLanguageTag("en-US")));
  var X := Math.Log10(Math.Abs(aValue));
  var FloatPattern := if aDigitsAfterDecimalPoint < 0 then "#.###############" else "#."+new String('#', aDigitsAfterDecimalPoint);
  var ScientificPattern := FloatPattern+"E00";

  if Math.Sign(X) > 0 then
    DecFormat.applyPattern(if Math.Abs(X) >= 15 then ScientificPattern else FloatPattern)
  else
    DecFormat.applyPattern(if Math.Abs(X) >= 5 then ScientificPattern else FloatPattern);

  result := DecFormat.format(aValue) as not nullable;

  if result.IndexOf("E-") > -1 then
    result := result.Replace("E", "E+");
  {$ELSEIF ECHOES}
  if aDigitsAfterDecimalPoint < 0 then
    result := System.Convert.ToString(aValue, System.Globalization.CultureInfo.InvariantCulture) as not nullable
  else
    result := aValue.ToString("0."+new String('0', aDigitsAfterDecimalPoint), System.Globalization.CultureInfo.InvariantCulture) as not nullable
  {$ELSEIF NOUGAT}
  if aDigitsAfterDecimalPoint < 0 then
    result := aValue.ToString.ToUpper()
  else
    //{$HIDE NW3}result := NSString.stringWithFormat("%0."+new String('0', aDigitsAfterDecimalPoint)+"f", aValue) as not nullable;{$SHOW NW3}
    result := NSString.stringWithFormat("%0.*f", aDigitsAfterDecimalPoint, aValue) as not nullable;
  {$ENDIF}
end;

method Convert.ToString(aValue: Char): not nullable String;
begin
  {$IF COOPER OR NOUGAT}
  //74584: Two more bogus nullable warnings
  exit Sugar.String(aValue);
  {$ELSEIF ECHOES}
  exit System.Convert.ToString(aValue) as not nullable;
  {$ENDIF}
end;

method Convert.ToString(aValue: Object): not nullable String;
begin
  //74584: Two more bogus nullable warnings
  exit coalesce(aValue.ToString, '');
end;

method Convert.ToInt32(aValue: Boolean): Int32;
begin
  result := if aValue then 1 else 0; 
end;

method Convert.ToInt32(aValue: Byte): Int32;
begin
  {$IF COOPER OR NOUGAT}
  exit Int32(aValue);
  {$ELSEIF ECHOES}
  exit System.Convert.ToInt32(aValue);
  {$ENDIF}
end;

method Convert.ToInt32(aValue: Int64): Int32;
begin
  if (aValue > Consts.MaxInteger) or (aValue < Consts.MinInteger) then
    raise new SugarArgumentOutOfRangeException(ErrorMessage.TYPE_RANGE_ERROR, "Int32");

  {$IF COOPER OR NOUGAT}
  exit Int32(aValue);
  {$ELSEIF ECHOES}
  exit System.Convert.ToInt32(aValue);
  {$ENDIF}
end;

method Convert.ToInt32(aValue: Double): Int32;
begin
  var Number := Math.Round(aValue);

  if (Number > Consts.MaxInteger) or (Number < Consts.MinInteger) then
    raise new SugarArgumentOutOfRangeException(ErrorMessage.TYPE_RANGE_ERROR, "Int32");

  exit Int32(Number);
end;

method Convert.ToInt32(aValue: Char): Int32;
begin
  {$IF COOPER OR NOUGAT}
  exit ord(aValue);
  {$ELSEIF ECHOES}
  exit System.Convert.ToInt32(aValue);
  {$ENDIF}
end;

method Convert.ToInt32(aValue: not nullable String): Int32;
begin
  {$IF COOPER}
  exit Integer.parseInt(aValue);
  {$ELSEIF ECHOES}
  exit System.Convert.ToInt32(aValue);
  {$ELSEIF NOUGAT}
  exit ParseInt32(aValue);
  {$ENDIF}
end;

method Convert.DigitForValue(aValue: Int32): Char;
begin
  result := chr(55 + aValue + (((aValue - 10) shr 31) and -7)); // don't ask me how this works but it does.
end;

method Convert.TrimLeadingZeros(aValue: not nullable String): not nullable String;
begin
  for i: Int32 := 0 to length(aValue)-2 do
    if aValue[i] ≠ '0' then exit aValue.Substring(i);
  exit aValue;
end;

method Convert.ToHexString(aValue: UInt64; aWidth: Integer := 0): not nullable String;
begin
  var lWidth := aWidth;
  if (lWidth < 1) or (lWidth > 64/4) then lWidth := 64/4;
  result := '';
  for i: Integer := lWidth-1 downto 0 do
    result := result + DigitForValue(aValue shr (i*4) and $0f);
  if aWidth = 0 then
    result := TrimLeadingZeros(result);
end;

method Convert.ToOctalString(aValue: Int64; aWidth: Integer := 0): not nullable String;
begin
  var lWidth := aWidth;
  if (lWidth < 1) or (lWidth > 64/3) then lWidth := 64/3;
  result := '';
  for i: Integer := lWidth-1 downto 0 do
    result := result + DigitForValue(aValue shr (i*3) and $07);
  if aWidth = 0 then
    result := TrimLeadingZeros(result);
end;

method Convert.ToBinaryString(aValue: Int64; aWidth: Integer := 0): not nullable String;
begin
  var lWidth := aWidth;
  if (lWidth < 1) or (lWidth > 64) then lWidth := 64;
  result := '';
  for i: Integer := lWidth-1 downto 0 do
    result := result + DigitForValue(aValue shr i and $01);
  if aWidth = 0 then
    result := TrimLeadingZeros(result);
end;

method Convert.ToHexString(aData: array of Byte; aOffset: Integer; aCount: Integer): not nullable String;
begin
  if (length(aData) = 0) or (aCount = 0) then
    exit '';

  RangeHelper.Validate(Range.MakeRange(aOffset, aCount), aData.Length);

  var Chars := new Char[aCount * 2];
  var Num: Integer;

  for i: Integer := 0 to aCount - 1 do begin
    Num := aData[aOffset + i] shr 4;
    Chars[i * 2] := chr(55 + Num + (((Num - 10) shr 31) and -7));
    Num := aData[aOffset + i] and $F;
    Chars[i * 2 + 1] := chr(55 + Num + (((Num - 10) shr 31) and -7));
  end;

  exit new String(Chars);
end;

method Convert.ToHexString(aData: array of Byte; aCount: Integer): not nullable String;
begin
  result := ToHexString(aData, 0, aCount);
end;

method Convert.ToHexString(aData: array of Byte): not nullable String;
begin
  result := ToHexString(aData, 0, length(aData));
end;

method Convert.ToHexString(aData: Binary): not nullable String;
begin
  result := ToHexString(aData.ToArray())
end;

method Convert.HexStringToByteArray(aData: not nullable String): array of Byte;

  method HexValue(C: Char): Integer;
  begin
    var Value := ord(C);
    result := Value - (if Value < 58 then 48 else if Value < 97 then 55 else 87);
    
    if (result > 15) or (result < 0) then
      raise new SugarFormatException("{0}. Invalid character: [{1}]", ErrorMessage.FORMAT_ERROR, C);
  end;

begin
  if length(aData) = 0 then
    exit [];

  if aData.Length mod 2 = 1 then
    raise new SugarFormatException("{0}. {1}", ErrorMessage.FORMAT_ERROR, "Hex string can not have odd number of chars.");

  result := new Byte[aData.Length shr 1];

  for i: Integer := 0 to result.Length - 1 do
    result[i] := Byte((HexValue(aData[i shl 1]) shl 4) + HexValue(aData[(i shl 1) + 1]));
end;

method Convert.HexStringToInt32(aValue: not nullable String): UInt32;
begin
  {$IF COOPER}
  exit Integer.parseInt(aValue, 16);
  {$ELSEIF ECHOES}
  exit Int32.Parse(aValue, System.Globalization.NumberStyles.HexNumber);
  {$ELSEIF NOUGAT}
  var scanner: NSScanner := NSScanner.scannerWithString(aValue);
  scanner.scanHexInt(var result);
  {$ENDIF}
end;

method Convert.HexStringToInt64(aValue: not nullable String): UInt64;
begin
  {$IF COOPER}
  exit Long.parseLong(aValue, 16);
  {$ELSEIF ECHOES}
  exit Int64.Parse(aValue, System.Globalization.NumberStyles.HexNumber);
  {$ELSEIF NOUGAT}
  var scanner: NSScanner := NSScanner.scannerWithString(aValue);
  scanner.scanHexLongLong(var result);
  {$ENDIF}
end;

method Convert.ToInt64(aValue: Boolean): Int64;
begin
  result := if aValue then 1 else 0;
end;

method Convert.ToInt64(aValue: Byte): Int64;
begin
  {$IF COOPER OR NOUGAT}
  exit Int64(aValue);
  {$ELSEIF ECHOES}
  exit System.Convert.ToInt64(aValue);
  {$ENDIF}
end;

method Convert.ToInt64(aValue: Int32): Int64;
begin
  {$IF COOPER OR NOUGAT}
  exit Int64(aValue);
  {$ELSEIF ECHOES}
  exit System.Convert.ToInt64(aValue);
  {$ENDIF}
end;

method Convert.ToInt64(aValue: Double): Int64;
begin
  if (aValue > Consts.MaxInt64) or (aValue < Consts.MinInt64) then
    raise new SugarArgumentOutOfRangeException(ErrorMessage.TYPE_RANGE_ERROR, "Int64");

  exit Math.Round(aValue);
end;

method Convert.ToInt64(aValue: Char): Int64;
begin
  {$IF COOPER OR NOUGAT}
  exit ord(aValue);
  {$ELSEIF ECHOES}
  exit System.Convert.ToInt64(aValue);
  {$ENDIF}
end;

method Convert.ToInt64(aValue: not nullable String): Int64;
begin
  if aValue = nil then
    exit 0;

  if String.IsNullOrWhiteSpace(aValue) then
    raise new SugarFormatException("Unable to convert string '{0}' to int64.", aValue);

  {$IF COOPER}
  exit Long.parseLong(aValue);
  {$ELSEIF ECHOES}
  exit System.Convert.ToInt64(aValue);
  {$ELSEIF NOUGAT}
  exit ParseInt64(aValue);
  {$ENDIF}
end;

method Convert.ToDouble(aValue: Boolean): Double;
begin
  result := if aValue then 1 else 0;
end;

method Convert.ToDouble(aValue: Byte): Double;
begin
  {$IF COOPER OR NOUGAT}
  exit Double(aValue);
  {$ELSEIF ECHOES}
  exit System.Convert.ToDouble(aValue);
  {$ENDIF}
end;

method Convert.ToDouble(aValue: Int32): Double;
begin
  {$IF COOPER OR NOUGAT}
  exit Double(aValue);
  {$ELSEIF ECHOES}
  exit System.Convert.ToDouble(aValue);
  {$ENDIF}
end;

method Convert.ToDouble(aValue: Int64): Double;
begin
  {$IF COOPER OR NOUGAT}
  exit Double(aValue);
  {$ELSEIF ECHOES}
  exit System.Convert.ToDouble(aValue);
  {$ENDIF}
end;

method Convert.ToDoubleInvariant(aValue: not nullable String): Double;
begin
  if String.IsNullOrWhiteSpace(aValue) then
    raise new SugarFormatException("Unable to convert string '{0}' to double.", aValue);

  {$IF COOPER}
  var DecFormat: java.text.DecimalFormat := java.text.DecimalFormat(java.text.DecimalFormat.getInstance(Sugar.Cooper.LocaleUtils.ForLanguageTag("en-US")));
  var Symbols: java.text.DecimalFormatSymbols := java.text.DecimalFormatSymbols.getInstance(Sugar.Cooper.LocaleUtils.ForLanguageTag("en-US"));

  Symbols.DecimalSeparator := '.';
  Symbols.GroupingSeparator := ',';
  Symbols.ExponentSeparator := 'E';
  DecFormat.setParseIntegerOnly(false);
  var Position := new java.text.ParsePosition(0);
  
  aValue := aValue.Trim.ToUpper;
  {$IF ANDROID}
  if aValue.Length > 1 then begin
    var DecimalIndex := aValue.IndexOf(".");
    if DecimalIndex = -1 then
      DecimalIndex := aValue.Length;

    aValue := aValue[0] + aValue.Substring(1, DecimalIndex - 1).Replace(",", "") + aValue.Substring(DecimalIndex);    
  end;
  {$ENDIF}

  result := DecFormat.parse(aValue, Position).doubleValue;

  if Position.Index < aValue.Length then
    raise new SugarFormatException("Unable to convert string '{0}' to double.", aValue);

  if Consts.IsInfinity(result) or Consts.IsNaN(result) then
    raise new SugarFormatException("Unable to convert string '{0}' to double.", aValue);
  {$ELSEIF ECHOES}
  exit System.Convert.ToDouble(aValue, System.Globalization.CultureInfo.InvariantCulture);
  {$ELSEIF NOUGAT}
  exit ParseDouble(aValue);
  {$ENDIF}
end;

method Convert.ToByte(aValue: Boolean): Byte;
begin
  result := if aValue then 1 else 0;
end;

method Convert.ToByte(aValue: Double): Byte;
begin
  var Number := Math.Round(aValue);

  if (Number > 255) or (Number < 0) then
    raise new SugarArgumentOutOfRangeException(ErrorMessage.TYPE_RANGE_ERROR, "Byte");

  exit Byte(Number);
end;

method Convert.ToByte(aValue: Int32): Byte;
begin
  if (aValue > 255) or (aValue < 0) then
    raise new SugarArgumentOutOfRangeException(ErrorMessage.TYPE_RANGE_ERROR, "Byte");

  exit Byte(aValue);
end;

method Convert.ToByte(aValue: Int64): Byte;
begin
  if (aValue > 255) or (aValue < 0) then
    raise new SugarArgumentOutOfRangeException(ErrorMessage.TYPE_RANGE_ERROR, "Byte");

  exit Byte(aValue);
end;

method Convert.ToByte(aValue: Char): Byte;
begin
  var Number := Convert.ToInt32(aValue);

  if (Number > 255) or (Number < 0) then
    raise new SugarArgumentOutOfRangeException(ErrorMessage.TYPE_RANGE_ERROR, "Byte");

  {$IF COOPER OR NOUGAT}
  exit ord(aValue);
  {$ELSEIF ECHOES}
  exit System.Convert.ToByte(aValue);
  {$ENDIF}
end;

method Convert.ToByte(aValue: not nullable String): Byte;
begin
  if aValue = nil then
    exit 0;

  if String.IsNullOrWhiteSpace(aValue) then
    raise new SugarFormatException("Unable to convert string '{0}' to byte.", aValue);

  {$IF COOPER}
  exit Byte.parseByte(aValue);
  {$ELSEIF ECHOES}
  exit System.Convert.ToByte(aValue);
  {$ELSEIF NOUGAT}
  var Number: Int32 := ParseInt32(aValue);
  exit ToByte(Number);
  {$ENDIF}
end;

method Convert.ToChar(aValue: Boolean): Char;
begin
  exit ToChar(ToInt32(aValue));
end;

method Convert.ToChar(aValue: Int32): Char;
begin
  if (aValue > Consts.MaxChar) or (aValue < Consts.MinChar) then
    raise new SugarArgumentOutOfRangeException(ErrorMessage.TYPE_RANGE_ERROR, "Char");

  {$IF COOPER OR NOUGAT}
  exit chr(aValue);
  {$ELSEIF ECHOES}
  exit System.Convert.ToChar(aValue);
  {$ENDIF}
end;

method Convert.ToChar(aValue: Int64): Char;
begin
  if (aValue > Consts.MaxChar) or (aValue < Consts.MinChar) then
    raise new SugarArgumentOutOfRangeException(ErrorMessage.TYPE_RANGE_ERROR, "Char");

  {$IF COOPER OR NOUGAT}
  exit chr(aValue);
  {$ELSEIF ECHOES}
  exit System.Convert.ToChar(aValue);
  {$ENDIF}
end;

method Convert.ToChar(aValue: Byte): Char;
begin
  {$IF COOPER}
  exit chr(Integer(aValue));
  {$ELSEIF ECHOES}
  exit System.Convert.ToChar(aValue);
  {$ELSEIF NOUGAT}
  exit chr(aValue);
  {$ENDIF}
end;

method Convert.ToChar(aValue: not nullable String): Char;
begin
  SugarArgumentNullException.RaiseIfNil(aValue, "aValue");

  if aValue.Length <> 1 then
    raise new SugarFormatException("Unable to convert string '{0}' to char.", aValue);

  exit aValue[0];
end;

method Convert.ToBoolean(aValue: Double): Boolean;
begin
  exit if aValue = 0 then false else true;
end;

method Convert.ToBoolean(aValue: Int32): Boolean;
begin
  exit if aValue = 0 then false else true;
end;

method Convert.ToBoolean(aValue: Int64): Boolean;
begin
  exit if aValue = 0 then false else true;
end;

method Convert.ToBoolean(aValue: Byte): Boolean;
begin
  exit if aValue = 0 then false else true;
end;

method Convert.ToBoolean(aValue: not nullable String): Boolean;
begin  
  if (aValue = nil) or (aValue.EqualsIgnoreCase(Consts.FalseString)) then 
    exit false;

  if aValue.EqualsIgnoreCase(Consts.TrueString) then
    exit true;  
  
  raise new SugarFormatException(ErrorMessage.FORMAT_ERROR);
end;

{$IF NOUGAT}
method Convert.ParseNumberInvariant(aValue: not nullable String): NSNumber;
begin
  if String.IsNullOrEmpty(aValue) then
    exit nil;

  var Formatter := new NSNumberFormatter;
  Formatter.numberStyle := NSNumberFormatterStyle.NSNumberFormatterDecimalStyle;
  Formatter.decimalSeparator := '.';
  //Formatter.thousandSeparator := ','; // E44 No member "thousandSeparator" on type "NSNumberFormatter"
  Formatter.exponentSymbol := 'E';
  result := Formatter.numberFromString(aValue);
end;

method Convert.ParseInt32(aValue: not nullable String): Int32;
begin
  var Number := ParseInt64(aValue);

  if (Number > Consts.MaxInteger) or (Number < Consts.MinInteger) then
    raise new SugarFormatException(ErrorMessage.FORMAT_ERROR);

  exit Int32(Number);
end;

method Convert.ParseInt64(aValue: not nullable String): Int64;
begin
  var Number := ParseNumberInvariant(aValue);

  if Number = nil then
    raise new SugarFormatException(ErrorMessage.FORMAT_ERROR);

  var obj: id := Number;
  var NumberType := CFNumberGetType(CFNumberRef(obj));

  if NumberType in [CFNumberType.kCFNumberIntType, CFNumberType.kCFNumberNSIntegerType, CFNumberType.kCFNumberSInt8Type, CFNumberType.kCFNumberSInt32Type,
                    CFNumberType.kCFNumberSInt16Type, CFNumberType.kCFNumberShortType, CFNumberType.kCFNumberSInt64Type, CFNumberType.kCFNumberCharType] then
    exit Number.longLongValue;

  raise new SugarFormatException(ErrorMessage.FORMAT_ERROR);
end;

method Convert.ParseDouble(aValue: not nullable String): Double;
begin
  var Number := ParseNumberInvariant(aValue);

  if Number = nil then
    raise new SugarFormatException(ErrorMessage.FORMAT_ERROR);

  exit Number.doubleValue;
end;

{$ENDIF}

end.
