
"" date
let s:Ryear = '%(%(19|20)\d\d)'
let s:Rmonth = '%(0\d|1[012])'
let s:Rday = '%([012]\d|3[01])'
" ALT: (Mo|Tu|We|Th|Fr|Sa|Su) OR [MTWRFSU]
let s:Rwkdaynm = '%(Mon|Tue|Wed|Thu|Fri|Sat|Sun)'  " OR: %(-\u\l\l?)
let s:Rweek = 'W%([0-4]\d|5[0-3])'
let nou#rgx#Rdate = s:Ryear.'-'.s:Rmonth.'-'.s:Rday
let nou#rgx#Rcal = nou#rgx#Rdate.'%(-'.s:Rwkdaynm.')?%(-'.s:Rweek.')?'
" let s:Rwkyear = s:Ryear.'-'.s:Rweek
" let s:Rwkcury = 'C'.s:Rweek
" let s:Ranydate = '<%('.nou#rgx#Rcal.'|'.s:Rwkyear.'|'.s:Rwkcury.')>'

"" cal
let s:Rmonthnm = '(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)'
let nou#rgx#Rmcal = s:Ryear.'-'.s:Rmonth.'%(-'.s:Rmonthnm.')?%(-%(H[12]|T[123]|Q[1234]))?'


"" time
let s:Rhours = '%([01]\d|2[0-4])'  " OR: %(\d|...
let s:Rminutes = '[0-5]\d'
let s:Rseconds = '[0-5]\d'
let s:Rtimezone = '%(Z|\+%([01]\d|2[0-4]):?00)'  " ATT: don't allow fractional time zones
let nou#rgx#Rtime = s:Rhours.':'.s:Rminutes.'%(:'.s:Rseconds.')?'
let nou#rgx#Rdatetime = nou#rgx#Rdate.'[^0-9]'.nou#rgx#Rtime.'%('.s:Rtimezone.')?'


let nou#rgx#Rdts = s:Ryear . s:Rmonth . s:Rday .'%(_'. s:Rhours . s:Rminutes . s:Rseconds .')?'
