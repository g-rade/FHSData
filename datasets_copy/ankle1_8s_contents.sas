libname dir 'T:\FHS-TXB Analysis\FHS 2154 - datasets';

ods rtf style=journal file='T:\FHS-TXB Analysis\FHS 2154 - datasets\ankle1_8s_contents.rtf';

proc contents data=dir.dr281_ankle1_8s;
run;

ods rtf close;
