
"" date
let nou#rgx#Ryear = '%(%(19|20)\d\d)'
let nou#rgx#Rmonth = '%(0\d|1[012])'
let nou#rgx#Rday = '%([012]\d|3[01])'
let s:RwkA = '[MTWRFSU]'
" let s:RwkAa = '%(Mo|Tu|We|Th|Fr|Sa|Su)'
let s:RwkAaa = '%(Mon|Tue|Wed|Thu|Fri|Sat|Sun)'  " OR: %(-\u\l\l?)
let s:Rweek = '%([0-4]\d|5[0-3])'
let nou#rgx#Rdate = nou#rgx#Ryear.'-'.nou#rgx#Rmonth.'-'.nou#rgx#Rday
let nou#rgx#Rcal = nou#rgx#Rdate.'%(-'.s:RwkAaa.')?%(-W'.s:Rweek.')?'
" let s:Rwkyear = nou#rgx#Ryear.'-'.s:Rweek
" let s:Rwkcury = 'C'.s:Rweek
" let s:Ranydate = '<%('.nou#rgx#Rcal.'|'.s:Rwkyear.'|'.s:Rwkcury.')>'
let s:Rymd = '[a-t][1-9abc][1-9a-v]'  " OR: [a-t0-9A-T] for dates 1990+ too
let nou#rgx#Rymda = s:Rymd . s:RwkA .'?'
let nou#rgx#Rymdhms = s:Rymd . '[0-9A-N][0-9A-Ya-y][0-9A-Ya-y]'
let nou#rgx#Rdatepfx = '<%('. nou#rgx#Rcal .'|'. nou#rgx#Rymda .')>'

"" cal
let s:Rmonthnm = '(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)'
let nou#rgx#Rmcal = nou#rgx#Ryear.'-'.nou#rgx#Rmonth.'%(-'.s:Rmonthnm.')?%(-%(H[12]|T[123]|Q[1234]))?'
let nou#rgx#Rcwkm = 'W'.s:Rweek.'%([/-]'.s:Rmonthnm.')?%(-'.nou#rgx#Rday.')?'


"" time
let s:Rhours = '%([01]\d|2[0-4])'  " OR: %(\d|...
let s:Rminutes = '[0-5]\d'
let s:Rseconds = '[0-5]\d'  " WARN: leap-year seconds may be either 00 or 60 (but only once per year)
let s:Rtimezone = '%(Z|\+%([01]\d|2[0-4]):?00)'  " ATT: don't allow fractional time zones
let nou#rgx#Rtime = s:Rhours.':'.s:Rminutes.'%(:'.s:Rseconds.')?'
let nou#rgx#Rdatetime = nou#rgx#Rdate.'[^0-9]'.nou#rgx#Rtime.'%('.s:Rtimezone.')?'


let nou#rgx#Rdts = nou#rgx#Ryear . nou#rgx#Rmonth . nou#rgx#Rday .'%(_'. s:Rhours . s:Rminutes . s:Rseconds .')?'
