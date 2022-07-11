
/* event data - subset for chf and date of chf*/
data datesfmsoe;
  set dir.dr281_vr_soe_2020_a_1340s;
  keep ranid event date idtype;
  rename event = addevent date = datechf;
  if event in(40,41,49);
  run;

  proc sort data=datesfmsoe out=chf nodupkey;
    by ranid datechf;
	run;

 	 data firstchf;
	   set chf;
	   by ranid datechf;
       if first.ranid;
	   if idtype in(1,7,72); 
	   label datechf = "number days from exam 1 to chf ";
	   run;

/* last contact data */
data dthsurv;
  set dir.dr281_vr_survdth_2019_a_1337s;
  keep ranid lastcon lastsoe datedth;
  if idtype in(1,7,72); 

  /* if died set last contact to date of death */
  if lastcon = . then lastcon = datedth;
run;

  proc sort data=dthsurv nodupkey;
    by ranid;
	run;

	
/* long strain data */	
data strain;
  set dir.dr281_t_echocs_ex08_1_0705s;
  keep ranid _6CH_AVE_LONGSTRAIN _6CH_AVE_RADSTRAIN longstrain_cat18;
  
  if idtype in(1,7,72); 

  longstrain_cat18 = .;

  if . < _6ch_ave_longstrain <= -18 then longstrain_cat18 = 0;
    else if _6ch_ave_longstrain > -18 then longstrain_cat18 = 1;

	label longstrain_cat18 = 'Categorical Longitudinal Strain (18)';  

	format longstrain_cat18 longcat18f.;
	run;

proc sort data=strain;
  by ranid;
  run;

data combine;
  merge dirs.alldata2022(in=in1) firstchf(in=in2) dthsurv strain;
  by ranid;
  if in1;
run;


	/* CHF */
data survivalchf;
  set combine;
  
  censor = .;
  days = .;

    /* categorize UTXB by quartile */

  if h010 = 0 then do;
  	if . < ratio <= 6500 then q2u = 0;
	  else if ratio > 6500 then q2u = 1;
  end;
   
  if h010 = 1 then do;
	if . < ratio <= 1700 then q2u = 0;
	  else if ratio > 1700 then q2u = 1;
    end;
  
  /* censor=1 if alive (date = last contact) and = 0 if chf*/

  if addevent in(40,41,49) then do;
    days = datechf - examdate3_8;
    censor = 0;
	end;

   else do;
    days = lastcon - examdate3_8;
	censor = 1;
	end;
	run;
	
   

data survivalchf1  ;
set survivalchf;

/* truncate data after 5000 days to 5000 days */
days1 = days;
censor1 = censor;

if days > 5045 then do;
   days1 = 5045;
   censor1 = 1;
   end;
run;

