# db2-datetime

Module DATETIME provides simple date and time utilities for Db2 for LUW databases.

## Installation

You need to install the module definition and then each of the functions. Use an appropriate Db2 adminstrative user with the Db2 command line processor.

### Prerequisites

#### Change directory
Change to directory ``db2`` in a copy of the git repository on your database server.

#### Connect
Connect to your database.

#### Set schema
Decide which schema will hold the functions. For example, you might decide to use schema SCHEDULE. Set the default schema, for example:

``db2 set schema SCHEDULE``

### Create DATETIME module
Now create the DATETIME module and its function templates:

``db2 -tvf module_DATETIME.sql``

### Create DATETIME functions
Create each function in the module. The functions are delimited by ``@`` in each definition file.

```
db2 -td@ -f module_DATETIME/function_DAYS_BEFORE.sql
db2 -td@ -f module_DATETIME/function_IS_BETWEEN_TIMES.sql
db2 -td@ -f module_DATETIME/function_NEXT_1ST_DOW_N_OF_MONTH.sql
db2 -td@ -f module_DATETIME/function_NEXT_1ST_DOW_N.sql
db2 -td@ -f module_DATETIME/function_NEXT_2ND_DOW_N_OF_MONTH.sql
db2 -td@ -f module_DATETIME/function_NEXT_2ND_DOW_N.sql
db2 -td@ -f module_DATETIME/function_NEXT_3RD_DOW_N_OF_MONTH.sql
db2 -td@ -f module_DATETIME/function_NEXT_3RD_DOW_N.sql
db2 -td@ -f module_DATETIME/function_NEXT_4TH_DOW_N_OF_MONTH.sql
db2 -td@ -f module_DATETIME/function_NEXT_4TH_DOW_N.sql
db2 -td@ -f module_DATETIME/function_NEXT_DAY_N_OF_MONTH.sql
db2 -td@ -f module_DATETIME/function_NEXT_DAY_N.sql
db2 -td@ -f module_DATETIME/function_NEXT_DOW_IN_LIST.sql
db2 -td@ -f module_DATETIME/function_NEXT_EVERY_N_DAYS.sql
db2 -td@ -f module_DATETIME/function_NEXT_EVERY_N_HOURS.sql
db2 -td@ -f module_DATETIME/function_NEXT_EVERY_N_MINUTES.sql
db2 -td@ -f module_DATETIME/function_NEXT_EVERY_N_MONTHS.sql
db2 -td@ -f module_DATETIME/function_NEXT_EVERY_N_SECONDS.sql
db2 -td@ -f module_DATETIME/function_NEXT_EVERY_N_WEEKS.sql
db2 -td@ -f module_DATETIME/function_NEXT_LAST_DAY_OF_MONTH.sql
db2 -td@ -f module_DATETIME/function_NEXT_LAST_DAY.sql
db2 -td@ -f module_DATETIME/function_NEXT_LAST_DOW_N_OF_MONTH.sql
db2 -td@ -f module_DATETIME/function_NEXT_LAST_DOW_N.sql
db2 -td@ -f module_DATETIME/function_NEXT_LEAP_DATE.sql
```

### Grant permissions to user module

Grant EXECUTE on the module to provide access to all its functions. For example:

``db2 grant execute on module DATETIME to public``

Functions can be invoked using a 3 part name, for example:

``VALUES schedule.datetime.days_before(datetime.next_month_end('2024-11-28'), 5);``

To avoid needing to specify the schema in each usage, set the current path to include that schema. For example:

``db2 set path system path, SCHEDULE``

A 2 part call will now work:

``VALUES datetime.days_before(datetime.next_month_end('2024-11-28'), 5);``


## Functional description

### Next date functions

Module DATETIME provides the following functions for calculating future dates for various criteria:

* NEXT_EVERY_N_DAYS
* NEXT_EVERY_N_WEEKS
* NEXT_EVERY_N_MONTHS
* NEXT_DAY_N
* NEXT_LAST_DAY
* NEXT_1ST_DOW_N
* NEXT_2ND_DOW_N
* NEXT_3RD_DOW_N
* NEXT_4TH_DOW_N
* NEXT_LAST_DOW_N
* NEXT_DAY_N_OF_MONTH
* NEXT_LAST_DAY_OF_MONTH
* NEXT_1ST_DOW_N_OF_MONTH
* NEXT_2ND_DOW_N_OF_MONTH
* NEXT_3RD_DOW_N_OF_MONTH
* NEXT_4TH_DOW_N_OF_MONTH
* NEXT_LAST_DOW_N_OF_MONTH
* NEXT_LEAP_DATE
* NEXT_DOW_IN_LIST

#### Common parameters

Each of the parameters below is common to several of the next date functions.

##### Parameter P_AT_DATE

Parameter P_AT_DATE is a DATE value. It defines the date from which the relevant next date is calculated. The non-null result of any next date function will always be a date on or after the supplied P_AT_DATE.

##### Parameter P_MONTH

Parameter P_MONTH is a SMALLINT value between 1 and 12. It defines the required month for many of the next date functions. The non-null result of any next date function will always be a date with a month matching the supplied P_MONTH.

##### Parameter P_DOW_N

Parameter P_DOW_N is a SMALLINT value between 1 and 7. It defines the required ISO day of the week for several of the next date functions. The non-null result of any next date function will always be a date with an ISO day of the week matching the supplied P_DOW_N.

#### Custom exceptions

The exceptions below may be raised by the next date functions.

##### SQLSTATE TZ001

This exception means that a parameter other than the function cannot calculate a result less than the maximum date (9999-12-31). This only occurs for supplied P_AT_DATE values towards the end of the DATE range (mostly year 9999).

Example:
```
-- The highest leap date is 9996-02-29.
VALUES datetime.next_leap_date('9996-03-01');

SQL0438N  Application raised error or warning with diagnostic text: "P_AT_DATE 
is beyond calculation range".  SQLSTATE=TZ001

```

##### SQLSTATE TZ002

This exception means that the value supplied for a parameter other than P_AT_DATE is out of its permitted range.

Example:
```
-- The specified month must be between 1 and 12.
VALUES datetime.next_last_day_of_month('2023-11-25', 13);

SQL0438N  Application raised error or warning with diagnostic text: "P_MONTH 
out of range".  SQLSTATE=TZ002
```

#### NULL inputs

If any supplied parameter contains a NULL, the result will be null.

#### Function NEXT_EVERY_N_DAYS

This function returns the first date on or after the specified date (P_AT_DATE) with the specified days interval (P_N_DAYS) from the specified base date (P_BASE_DATE). Parameter P_N_DAYS is a SMALLINT value between 1 and 366.

Examples:
```
-- Return the first date on or after 2024-11-16 that is a multiple of 7 days from 2024-11-01.
VALUES datetime.next_every_n_days('2024-11-16', '2024-11-01', 7);

22-11-2024

-- Return the first date on or after 2024-11-01 that is a multiple of 5 days from 2024-11-16.
VALUES datetime.next_every_n_days('2024-11-01', '2024-11-16', 5);

16-11-2024
```

#### Function NEXT_EVERY_N_WEEKS

This function returns the first date on or after the specified date (P_AT_DATE) with the specified days interval (P_N_WEEKS) from the specified base date (P_BASE_DATE). Parameter P_N_WEEKS is a SMALLINT value between 1 and 52.

Examples:
```
-- Return the first date on or after 2024-11-15 that is a multiple of 2 weeks from 2024-11-01.
VALUES datetime.next_every_n_weeks('2024-11-15', '2024-11-01', 2);

15-11-2024

-- Return the first date on or after 2024-11-01 that is a multiple of 3 weeks from 2024-11-01.
VALUES datetime.next_every_n_weeks('2024-11-15', '2024-11-01', 3);

22-11-2024
```

#### Function NEXT_EVERY_N_MONTHS

This function returns the first date on or after the specified date (P_AT_DATE) with the specified months interval (P_N_MONTHS) from the specified base date (P_BASE_DATE). Parameter P_N_MONTHS is a SMALLINT value between 1 and 120.

Examples:
```
-- Return the first date on or after 2024-11-15 that is a multiple of 2 months from 2024-10-31.
VALUES datetime.next_every_n_months('2024-11-15', '2024-10-31', 2);

31-12-2024

-- Return the first date on or after 2024-11-15 that is a multiple of 4 months from 2024-10-31.
VALUES datetime.next_every_n_months('2024-11-15', '2024-10-31', 4);

28-02-2025
```

#### Function NEXT_DAY_N

This function returns the first date on or after the specified date (P_AT_DATE) that matches the specified day (P_DAY_N). Parameter P_DAY_N is a SMALLINT value between 1 and 31.

Examples:
```
-- Return the next 29th after 2024-01-30.
VALUES datetime.next_day_n('2024-01-30', 29);

29-02-2024

-- Return the next 29th after 2025-01-30.
VALUES datetime.next_day_n('2025-01-30', 29);

29-03-2025
```

#### Function NEXT_LAST_DAY

This function returns the next month end date on or after the specified date (P_AT_DATE).

Examples:
```
-- Return the last day of the June after 2024-11-05.
VALUES datetime.next_month_end('2024-11-05');

30-11-2024
```

#### Function NEXT_1ST_DOW_N

This function returns the first date on or after the specified date (P_AT_DATE) that is the first occurence in its month of the specified day of week (P_DOW_N).

Examples:
```
-- Return the first date on or after 2024-11-05 that is the first Monday in a month.
VALUES datetime.next_1st_dow_n('2024-11-05', 1);

02-12-2024
```

#### Function NEXT_2ND_DOW_N

This function returns the first date on or after the specified date (P_AT_DATE) that is the second occurence in its month of the specified day of week (P_DOW_N).

Examples:
```
-- Return the first date on or after 2024-11-05 that is the second Monday in a month.
VALUES datetime.next_2nd_dow_n('2024-11-05', 1);

11-11-2024
```

#### Function NEXT_3RD_DOW_N

This function returns the first date on or after the specified date (P_AT_DATE) that is the third occurence in its month of the specified day of week (P_DOW_N).

Examples:
```
-- Return the first date on or after 2024-11-05 that is the third Sunday in a month.
VALUES datetime.next_3rd_dow_n('2024-11-05', 7);

17-11-2024
```

#### Function NEXT_4TH_DOW_N

This function returns the first date on or after the specified date (P_AT_DATE) that is the fourth occurence in its month of the specified day of week (P_DOW_N).

Examples:
```
-- Return the first date on or after 2024-11-05 that is the fourth Tuesday in a month.
VALUES datetime.next_4th_dow_n('2024-11-05', 2);

26-11-2024
```

#### Function NEXT_LAST_DOW_N

This function returns the first date on or after the specified date (P_AT_DATE) that is the last occurence in its month of the specified day of week (P_DOW_N).

Examples:
```
-- Return the first date on or after 2024-11-05 that is the last Monday in a month.
VALUES datetime.next_last_dow_n('2024-11-05', 1);

25-11-2024
```

#### Function NEXT_DAY_N_OF_MONTH

This function returns the first date on or after the specified date (P_AT_DATE) that matches the specified day (P_DAY_N) and month (P_MONTH). Parameter P_DAY_N is a SMALLINT value between 1 and 31; the exact maximum depends on the month in accordance with normal date rules. A P_DAY_N value of 29 cannot be specified with a P_MONTH value of 2; use function NEXT_LEAP_DATE instead.

Examples:
```
-- Return the next 15th January after 2023-11-25.
VALUES datetime.next_day_n_of_month('2023-11-25', 15, 1);

15-01-2024

-- Return the next 28th February after 2024-03-01.
VALUES datetime.next_day_n_of_month('2024-03-01', 28, 2);

28-02-2025
```

#### Function NEXT_LAST_DAY_OF_MONTH

This function returns the date of the last day in the specified month (P_MONTH) on or after the specified date (P_AT_DATE).

Examples:
```
-- Return the last day of the June after 2024-11-01.
VALUES datetime.next_last_day_of_month('2024-11-01', 6);

30-06-2025
```

#### Function NEXT_1ST_DOW_N_OF_MONTH

This function returns the first date on or after the specified date (P_AT_DATE) that is the first occurrence of the specified day of the week (P_DOW_N) in the specified month (P_MONTH).

Examples:
```
-- Return the first date on or after 2024-11-05 that is the first Monday in November.
VALUES datetime.next_1st_dow_n_of_month('2024-11-05', 1, 11);

03-11-2025

-- Return the first date on or after 2024-11-05 that is the first Thursday in November.
VALUES datetime.next_1st_dow_n_of_month('2024-11-05', 4, 11);

07-11-2024
```

#### Function NEXT_2ND_DOW_N_OF_MONTH

This function returns the first date on or after the specified date (P_AT_DATE) that is the second occurrence of the specified day of the week (P_DOW_N) in the specified month (P_MONTH).

Examples:
```
-- Return the first date on or after 2024-11-12 that is the second Tuesday in November.
VALUES datetime.next_2nd_dow_n_of_month('2024-11-12', 2, 11);

12-11-2024

-- Return the first date on or after 2024-11-12 that is the second Friday in November.
VALUES datetime.next_2nd_dow_n_of_month('2024-11-12', 5, 11);

14-11-2025
```

#### Function NEXT_3RD_DOW_N_OF_MONTH

This function returns the first date on or after the specified date (P_AT_DATE) that is the third occurrence of the specified day of the week (P_DOW_N) in the specified month (P_MONTH).

Examples:
```
-- Return the first date on or after 2024-11-16 that is the third Sunday in November.
VALUES datetime.next_3rd_dow_n_of_month('2024-11-16', 7, 11);

17-11-2024

-- Return the first date on or after 2024-11-16 that is the third Friday in November.
VALUES datetime.next_3rd_dow_n_of_month('2024-11-16', 5, 11);

21-11-2025
```

#### Function NEXT_4TH_DOW_N_OF_MONTH

This function returns the first date on or after the specified date (P_AT_DATE) that is the fourth occurrence of the specified day of the week (P_DOW_N) in the specified month (P_MONTH).

Examples:
```
-- Return the first date on or after 2024-11-16 that is the fourth Sunday in November.
VALUES datetime.next_4th_dow_n_of_month('2024-11-16', 7, 11);

24-11-2024

-- Return the first date on or after 2024-11-16 that is the fourth Friday in November.
VALUES datetime.next_4th_dow_n_of_month('2024-11-16', 5, 11);

22-11-2024
```

#### Function NEXT_LAST_DOW_N_OF_MONTH

This function returns the first date on or after the specified date (P_AT_DATE) that is the last occurrence of the specified day of the week (P_DOW_N) in the specified month (P_MONTH).

Examples:
```
-- Return the first date on or after 2024-11-16 that is the last Sunday in November.
VALUES datetime.next_last_dow_n_of_month('2024-11-16', 7, 11);

24-11-2024

-- Return the first date on or after 2024-11-16 that is the last Friday in November.
VALUES datetime.next_last_dow_n_of_month('2024-11-16', 5, 11);

29-11-2024
```

#### Function NEXT_LEAP_DATE

This function returns the first date on or after the specified date (P_AT_DATE) that is 29th February.

Examples:
```
-- Return the first date on or after 2024-01-01 that is a leap date.
VALUES datetime.next_leap_date('2024-01-01');

29-02-2024

-- Return the first date on or after 2096-03-01 that is a leap date.
VALUES datetime.next_leap_date('2096-03-01');

29-02-2104
```

#### Function NEXT_DOW_IN_LIST

This function returns the first date on or after the specified date (P_AT_DATE) with its day of week matching any of the days of the week specified by a bit mask (P_DOW_BITS).

The P_DOW_BITS bit mask is any value between 1 and 127. The values are calculated by adding powers of 2 from 0 to 6:
* 2^0 = 1 : Monday
* 2^1 = 2 : Tuesday
* 2^2 = 4 : Wednesday
* 2^3 = 8 : Thursday
* 2^4 = 16 : Friday
* 2^5 = 32: Saturday
* 2^6 = 64 : Sunday

You can add these values together to represent multiple days of the week. For example, P_DOW_BITS value:
* 96: Returns the next date on or after P_AT_DATE that is a Saturday or Sunday
* 31: Returns the next date on or after P_AT_DATE that is a weekday

Examples:
```
-- Return the next weekend date on or after Thursday, 19th March 2026.
VALUES datetime.next_dow_in_list('2026-03-19', 96);

03/21/2026

-- Return the next weekend date on or after Saturday, 21st March 2026.
VALUES datetime.next_dow_in_list('2026-03-21', 96);

03/21/2026

-- Return the next weekend date on or after Sunday, 22nd March 2026.
VALUES datetime.next_dow_in_list('2026-03-22', 96);

03/22/2026

-- Return the next weekend date on or after Monday, 23rd March 2026.
VALUES datetime.next_dow_in_list('2026-03-23', 96);

03/28/2026

-- Return the next weekday date on or after Saturday, 21st March 2026.
VALUES datetime.next_dow_in_list('2026-03-21', 31);

03/23/2026
```


### Next time functions

Module DATETIME provides the following functions for calculating future times:

* NEXT_EVERY_N_MINUTES
* NEXT_EVERY_N_HOURS

Both functions return the next interval on or after a supplied time (P_AT_TIME) that falls within a specified time range (P_BASE_FROM_TIME to P_BASE_TO_TIME). If P_BASE_TO_TIME is less than P_BASE_FROM_TIME then the time range is considered to span midnight. If P_BASE_TO_TIME is NULL or equals P_BASE_FROM_TIME then the time range is considered to be 24 hours. The result calculated will always be zero or more intervals from P_BASE_FROM_TIME.

#### Function NEXT_EVERY_N_MINUTES

This function calculates the result using an interval that is a specified number of minutes (P_N_MINUTES).

Examples:
```
-- The specified interval must be between 1 and 180 minutes.
VALUES datetime.next_every_n_minutes('00:00', '23:30', '01:30', 181);

SQL0438N  Application raised error or warning with diagnostic text: 
"P_N_MINUTES out of range".  SQLSTATE=TZ002

-- Return the next 15 minute interval between 11.30pm and 1.30am, as at 12.05.38am.
VALUES datetime.next_every_n_minutes('00:05:38', '23:30', '01:30', 15);

00:15:00

-- Return the next 5 minute interval between 1.30am and 11.30pm, as at 12.05.38am. Since the supplied time is outside the
-- range, the range start time is returned.
VALUES datetime.next_every_n_minutes('00:05:38', '01:30', '23:30', 5);

01:30:00

-- Return the next 13 minute interval calculate from 1 second after midnight, as at 11.40pm.
VALUES datetime.next_every_n_minutes('23:40', '00:00:01', NULL, 13);

23:50:01

-- Return the next 13 minute interval calculate from 1 second after midnight, as at 11.51pm.
VALUES datetime.next_every_n_minutes('23:51', '00:00:01', NULL, 13);

00:00:01
```

#### Function NEXT_EVERY_N_HOURS

This function calculates the result using an interval that is a specified number of hours (P_N_HOURS).

Examples:
```
-- The specified interval must be between 1 and 48 hours.
VALUES datetime.next_every_n_hours('00:00', '23:30', '01:30', 49);

SQL0438N  Application raised error or warning with diagnostic text: "P_N_HOURS 
out of range".  SQLSTATE=TZ002

-- Return the next 5 hour interval between 6am and midnight, as at 7.05am.
VALUES datetime.next_every_n_hours('07:05', '06:00', '00:00', 5);

11:00:00
```

### Offset functions

#### Function DAYS_BEFORE

This function returns the date with the specified number of days (P_OFFSET_N) before the specified date (P_AT_DATE). Parameter P_MONTH is a SMALLINT value between 1 and 12. Parameter P_OFFSET_N is a SMALLINT value between 0 and 14.

The function can be used to modify other scheduling calculations.

Examples:
```
-- Return the date 5 days prior to the last day of the specified month.
VALUES datetime.days_before(datetime.next_month_end('2024-11-28'), 5);

25-11-2024
```
