
/* survival Template */   

ODS PATH work.templat(update) sasuser.templat(read) sashelp.tmplmst(read);

/* plot is output to this folder with a generis name that I then renamed */
ods listing gpath='Z:\TXB Cutpoint Determination Updated Data\Plots' image_dpi=300;

data _null_;
   %let url = //support.sas.com/documentation/onlinedoc/stat/ex_code/151;
   infile "http:&url/templft.html" device=url;

   file 'macros.tmp';
   retain pre 0;
   input;
   _infile_ = tranwrd(_infile_, '&amp;', '&');
   _infile_ = tranwrd(_infile_, '&lt;' , '<');
   if index(_infile_, '</pre>') then pre = 0;
   if pre then put _infile_;
   if index(_infile_, '<pre>') then pre = 1;
run;
       
%inc 'macros.tmp' / nosource;

%ProvideSurvivalMacros                    /* variables available.           */

%let GraphOpts = attrpriority=none
                 DataLinePatterns=(Solid solid);

%let ntitles = 0;
%let TitleText0 = "";    /* Change the title.              */
%let TitleText1 = " "; *&titletext0 "for" STRATUMID; * " for " STRATUMID;
%let TitleText2 = " "; *&titletext0;  /* replaces product limit survival estimates */
%let LegendOpts = title=" ";
*%let entrytitle = "Time to Death By ASA Use";


%let yOptions = label="Survival" labelattrs=(size=13pt)
                linearopts=(viewmin=0.5 viewmax=1
                            tickvaluelist=(0.5 0.6 0.7 0.8 0.9 1));

%let yaxisopts=(linearopts=(minorticks=true minortickcount=5));

                   /* modify y-axis */
%let xOptions = label = "Years Since Index Exam" labelattrs=(size=13pt) linearopts=(viewmin=0 viewmax=10);
                            /*tickvaluelist=(0 0.25 0.50 0.75 1)*/   /* modify x-axis */


/* line thickness and line type for 1st plot */

/* quartile cutpoint plot */
%let StepOpts = lineattrs=(thickness=3);
%let GraphOpts = attrpriority=none
                 DataLinePatterns=(41);

/* subtitle */
%macro StmtsBeginGraph;
entrytitle "Time to Death By TXB Ratio Quartile (ASA y 1701 ASA n 6483)";   *entrytitle "Time to Death by ASA USE %sysfunc(date(),worddate.)" /textattrs=GraphValueText;
drawtext textattrs=(weight=Bold) 'Number at Risk' / x=7 y=10 width=20;
%mend;

%CompileSurvivalTemplates   

Proc Lifetest data = survival2 atrisk
  plots =(survival(test nocensor atrisk(maxlen=15) atrisk(outside)=0 to 10 by 1));
  TIME yrs1 * censor1(1);
  STRATA q2u;
run;
	

/* txb ratio plot */

%let StepOpts = lineattrs=(thickness=2.5);
%let GraphOpts = attrpriority=none
                 DataLinePatterns=(LongDash);

/* subtitle */
%macro StmtsBeginGraph;
entrytitle "Time to Death By TXB Ratio Cutpoint (ASA y 1291 ASA n 5609)";   *entrytitle "Time to Death by ASA USE %sysfunc(date(),worddate.)" /textattrs=GraphValueText;
drawtext textattrs=(weight=Bold) 'Number at Risk' / x=7 y=10 width=20;
%mend;

%CompileSurvivalTemplates   

Proc Lifetest data = survival2 atrisk
  plots =(survival(test nocensor atrisk(maxlen=15) atrisk(outside)=0 to 10 by 1));
  TIME yrs1 * censor1(1);
  STRATA ratioy;
run;


/* txb egfr ratio cutpoint */

%let StepOpts = lineattrs=(thickness=2.5);				 
%let GraphOpts = attrpriority=none
                 DataLinePatterns=(Solid);

/* subtitle */
%macro StmtsBeginGraph;
entrytitle "Time to Death By TXB EGFR Ratio Cutpoint (ASA y 17.8 ASA n 65.0)";   *entrytitle "Time to Death by ASA USE %sysfunc(date(),worddate.)" /textattrs=GraphValueText;
drawtext textattrs=(weight=Bold) 'Number at Risk' / x=7 y=10 width=20;
%mend;

%CompileSurvivalTemplates   

/* ASA Use Combined */
Proc Lifetest data = survival2 atrisk
  plots =(survival(test nocensor atrisk(maxlen=15) atrisk(outside)=0 to 10 by 1));
  TIME yrs1 * censor1(1);
  STRATA egfry;
run;

