
"" date
let s:Ryear = '20[0-9][0-9]'
let s:Rmonth = '%(0[0-9]|1[012])'
let s:Rday = '%([012][0-9]|3[01])'
let s:Rwkdaynm ='(Mon|Tue|Wed|Thu|Fri|Sat|Sun)'  " OR: %(-\u\l\l?)
let s:Rweek='W([0-4][0-9]|5[0-3])'
let nou#rgx#Rdate = s:Ryear.'-'.s:Rmonth.'-'.s:Rday
let nou#rgx#Rcal  = nou#rgx#Rdate.'%(-'.s:Rwkdaynm.')?%(-'.s:Rweek.')?'
" let s:Rwkyear = s:Ryear.'-'.s:Rweek
" let s:Rwkcury = 'C'.s:Rweek
" let s:Ranydate = '<%('.nou#rgx#Rcal.'|'.s:Rwkyear.'|'.s:Rwkcury.')>'


"" time
let s:Rhours = '%([0-9]|[01][0-9]|2[0-4])'
let s:Rminutes = '[0-5][0-9]'
let s:Rseconds = '[0-5][0-9]'
let s:Rtimezone = '%(Z|\+%([01][0-9]|2[0-4]):?00)'  " ATT: don't allow fractional time zones
let nou#rgx#Rtime = s:Rhours.':'.s:Rminutes.'%(:'.s:Rseconds.')?'
let nou#rgx#Rdatetime = nou#rgx#Rdate.'[^0-9]'.nou#rgx#Rtime.'%('.s:Rtimezone.')?'
