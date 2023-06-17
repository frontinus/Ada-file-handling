with Ada.Text_IO;
with Ada.Strings;
with Ada.Integer_Text_IO;
use Ada.Text_IO;
use Ada.Strings;
with Ada.Strings.Fixed;
use Ada.Strings.Fixed;
with Ada.Strings.Fixed;
use Ada.Strings.Fixed;
with Ada.Strings.Unbounded;
use Ada.Strings.Unbounded;
procedure Main is
   CSV_File: Ada.Text_IO.File_Type;
   TXT_File: Ada.Text_IO.File_Type;
   Last:Natural;
   Line : String(1..1050);
   Substring1: String(1..11) :="  Package: ";
   index : Natural;
   flag:Integer:=0;
   nb_func: Integer:=0;
   length_fin:Integer;
   delim1:Integer:= 73;
   delim2:Integer:= 102;
   delim3:Integer:=131;
   flog: Integer:=1;
   side: Trim_End:= Right;
   Str:Ada.Strings.Unbounded.Unbounded_String;
begin
   Ada.Text_IO.Open(File => TXT_File,Mode => Ada.Text_IO.In_File,Name => "Report STCA EBAU.txt");
   Ada.Text_IO.Create (File => CSV_File, Mode => Ada.Text_IO.Out_File, Name => "Report STCA EBAU import in excel" & ".csv");
   Ada.Text_IO.Put(CSV_File,"Package|CSU|Statement %|Statement covered|Statement Out of|Branch %|Branch covered|Branch Out of|MCDC %|MCDC covered|MCDC Out of");
   New_Line(CSV_File);
   while not Ada.Text_IO.End_Of_File(TXT_File) loop

      Get_Line(TXT_File,Line,Last);
      flog :=1;
      declare
         LineN:String :=Line(1..Last);
      begin
            index := Ada.Strings.Fixed.Index(Source => LineN, Pattern =>Substring1);
         if(index >0) then
            flag :=1;
            flog:= 0;
            Str :=Ada.Strings.Unbounded.To_Unbounded_String( LineN(11..Last));
         end if;
         if(LineN'Length>4) then
            if(LineN(5)=' ' or LineN(5)='<' or LineN(5)='>' or LineN(5)='*') then
               flag:=0;
            end if;
         end if;
         if(flag =1 and flog=1) then

            declare
               LineN3:String:=LineN(4..59);
               LineN4:String:=LineN(65..71);
               LineN5:String:=LineN(73..78);
               LineN6:String:=LineN(94..100);
               LineN7:String:=LineN(102..107);
               LineN8:String:=LineN(123..129);
               LineN9:String:=LineN(131..136);
            begin
               for I in LineN5'Range loop
                  if LineN5(I) = '/' then
                     delim1 := I;
                     exit;
                  end if;
               end loop;
               for I in LineN7'Range loop
                  if LineN7(I) = '/' then
                     delim2 := I;
                     exit;
                  end if;
               end loop;
               for I in LineN9'Range loop
                  if LineN9(I) = '/' then
                     delim3 := I;
                     exit;
                  end if;
               end loop;
               declare
                  LeftPart1:String := LineN5(LineN5'First +1 .. delim1 - 1);
                  RightPart1:String := Trim(Source => LineN5(delim1 +1  .. LineN5'Last),Side =>side);
                  LeftPart2:String := LineN7(LineN7'First +1 .. delim2 - 1);
                  RightPart2:String := Trim(Source => LineN7(delim2 +1 .. LineN7'Last),Side =>side);

                  LeftPart3:String := LineN9(LineN9'First +1 .. delim3 - 1);
                  RightPart3:String := Trim(Source => LineN9(delim3 +1.. LineN9'Last),Side =>side);
               begin
                  if(RightPart1'Length >0) then
                     if(RightPart1(RightPart1'Last) = ')') then
                        Ada.Strings.Fixed.Delete(RightPart1,2,2);
                     end if;
                  end if;
                  if(RightPart2'Length> 0) then
                     if(RightPart2(RightPart2'Last) = ')') then
                        Ada.Strings.Fixed.Delete(RightPart2,2,2);
                     end if;
                  end if;
                  if(RightPart3'Length>0 ) then
                     if(RightPart3(RightPart3'Last) = ')') then
                        Ada.Strings.Fixed.Delete(RightPart3,2,2);
                     end if;
                  end if;
                  length_fin := Length(Str) + LineN3'Length + LineN4'Length + LeftPart1'Length + RightPart1'Length + LineN6'Length + LeftPart2'Length + RightPart2'Length + LineN8'Length + LeftPart3'Length + RightPart3'Length + 10;
                  declare
                     Concat: String(1..length_fin);
                  begin
                     Concat:= To_String(Str) & "|" & LineN3 & "|" & LineN4 & "|" & LeftPart1 & "|" & RightPart1 & "|" & LineN6 & "|" & LeftPart2 & "|" & RightPart2 & "|" & LineN8 & "|" & LeftPart3 & "|" & RightPart3;
                     Put_Line(CSV_File,Concat);
                  end;
               end;
               end;
         end if;
     end;
   end loop;
   Ada.Text_IO.Close(TXT_File);
   Ada.Text_IO.Close(CSV_File);



end Main;
