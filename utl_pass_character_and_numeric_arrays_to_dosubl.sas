SAS Pass character and numeric arrays to dosubl.

INPUT (Pass these arrays to dosubl)
===================================

   array num[3] 8  _temporary_ (100,200,300);
   array ary[3] $8 _temporary_  ('Georgia', 'Florida', 'NewYork');

PROCESS
=======

   data _null_;
      array num[3] 8  _temporary_ (100,200,300);
      array ary[3] $8 _temporary_  ('Georgia', 'Florida', 'NewYork');

      adAry=put(addrlong(ary[1]),$hex40.); * starting address of character array;
      call symputx('adAry',adAry);

      adNum=put(addrlong(Num[1]),$hex40.); * starting address of numeric array;
      call symputx('adNum',adNum);

      rc=dosubl('
         data want;
            array mum[3] 8 _temporary_ (999,999,999);                      * replace from mainline;
            array ary[3] $8 _temporary_  ("Replace", "Replace", "Replace");

            adNum = input(symget("adNum"),$hex40.);
            chrs=peekclong(adNum,24);                  * get 24 chars 3x8 byte floats ie 100,200,300 in mainline;
            call pokelong(chrs,addrlong(Num[1]),24,1); * poke 24 chars which are the three nums into local num ary;

            adAry = input(symget("adAry"),$hex40.);
            chrs=peekclong(adAry,24);                  * get 24 chars 3x8 chars from parent ary Georgia, Florida, NewYork;
            call pokelong(chrs,addrlong(ary[1]),24);   * poke 24 chars which are the three nums into local num ary;

            do i=1 to 3;
              put Num[i]= Ary[i]=;
            end;
         run;quit;
      ');
   run;quit;

OUTPUT  (DOSUBL has values from parent)
=======================================

    NUM[1]=100   ARY[1]=Georgia
    NUM[2]=200   ARY[2]=Florida
    NUM[3]=300   ARY[3]=NewYork

*                _              _       _
 _ __ ___   __ _| | _____    __| | __ _| |_ __ _
| '_ ` _ \ / _` | |/ / _ \  / _` |/ _` | __/ _` |
| | | | | | (_| |   <  __/ | (_| | (_| | || (_| |
|_| |_| |_|\__,_|_|\_\___|  \__,_|\__,_|\__\__,_|

;


   array num[3] 8  _temporary_ (100,200,300);
   array ary[3] $8 _temporary_  ('Georgia', 'Florida', 'NewYork');

*          _       _   _
 ___  ___ | |_   _| |_(_) ___  _ __
/ __|/ _ \| | | | | __| |/ _ \| '_ \
\__ \ (_) | | |_| | |_| | (_) | | | |
|___/\___/|_|\__,_|\__|_|\___/|_| |_|

;

proc datasets lib=work kill;
run;quit;
%symdel adNum adAry / nowarn;
data _null_;
   array num[3] 8  _temporary_ (100,200,300);
   array ary[3] $8 _temporary_  ('Georgia', 'Florida', 'NewYork');
   adAry=put(addrlong(ary[1]),$hex40.);
   call symputx('adAry',adAry);
   adNum=put(addrlong(Num[1]),$hex40.);
   call symputx('adNum',adNum);
   rc=dosubl('
      data want;
         array Num[3] 8 _temporary_ (999,999,999);
         array ary[3] $8 _temporary_  ("Replace", "Replace", "Replace");
         adNum = input(symget("adNum"),$hex40.);
         chrs=peekclong(adNum,24);
         call pokelong(chrs,addrlong(Num[1]),24,1);
         adAry = input(symget("adAry"),$hex40.);
         chrs=peekclong(adAry,24);
         call pokelong(chrs,addrlong(ary[1]),24);
         do i=1 to 3;
           put Num[i]= Ary[i]=;
         end;
      run;quit;
   ');
run;quit;

NUM[1]=100   ARY[1]=Georgia
NUM[2]=200   ARY[2]=Florida
NUM[3]=300   ARY[3]=NewYork

