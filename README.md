# db2-datetime

Module DATETIME provides simple date and time utilities for Db2 for LUW databases.

The current release contains only scheduling-related date functions.

## Function DAYS_BEFORE

This function returns the date with the specified number of days (P_OFFSET_N) before the specified date (P_AT_DATE). Parameter P_MONTH is a SMALLINT value between 1 and 12. Parameter P_OFFSET_N is a SMALLINT value between 0 and 14.

The function can be used to modify other scheduling calculations.

Examples:
```
-- Return the date 5 days prior to the last day of the specified month.
VALUES datetime.days_before(datetime.next_month_end('2024-11-28'), 5);

25-11-2024
```

## Next date functions

Module DATETIME provides the following functions for calculating future dates for various criteria:

* NEXT_DAY_N_OF_MONTH
* NEXT_1ST_DOW_N_OF_MONTH
* NEXT_2ND_DOW_N_OF_MONTH
* NEXT_3RD_DOW_N_OF_MONTH
* NEXT_4TH_DOW_N_OF_MONTH
* NEXT_LAST_DOW_N_OF_MONTH
* NEXT_EVERY_N_DAYS
* NEXT_EVERY_N_WEEKS
* NEXT_EVERY_N_MONTHS
* NEXT_MONTH_END
* NEXT_LAST_DAY_OF_MONTH
* NEXT_LEAP_DATE

### Common parameters

Each of the parameters below is common to several of the next date functions.

#### Parameter P_AT_DATE

Parameter P_AT_DATE is a DATE value. It defines the date from which the relevant next date is calculated. The non-null result of any next date function will always be a date on or after the supplied P_AT_DATE.

#### Parameter P_MONTH

Parameter P_MONTH is a SMALLINT value between 1 and 12. It defines the required month for many of the next date functions. The non-null result of any next date function will always be a date with a month matching the supplied P_MONTH.

#### Parameter P_DOW_N

Parameter P_DOW_N is a SMALLINT value between 1 and 7. It defines the required ISO day of the week for several of the next date functions. The non-null result of any next date function will always be a date with an ISO day of the week matching the supplied P_DOW_N.

### Custom exceptions

The exceptions below may be raised by the next date functions.

#### SQLSTATE TZ001

This exception means that a parameter other than the function cannot calculate a result less than the maximum date (9999-12-31). This only occurs for supplied P_AT_DATE values towards the end of the DATE range (mostly year 9999).

Example:
```
-- The highest leap date is 9996-02-29.
VALUES datetime.next_leap_date('9996-03-01');

SQL0438N  Application raised error or warning with diagnostic text: "P_AT_DATE 
is beyond calculation range".  SQLSTATE=TZ001

```

#### SQLSTATE TZ002

This exception means that the value supplied for a parameter other than P_AT_DATE is out of its permitted range.

Example:
```
-- The specified month must be between 1 and 12.
VALUES datetime.next_last_day_of_month('2023-11-25', 13);

SQL0438N  Application raised error or warning with diagnostic text: "P_MONTH 
out of range".  SQLSTATE=TZ002
```


### NULL inputs

If any supplied parameter contains a NULL, the result will be null.

### Function NEXT_DAY_N_OF_MONTH

This function returns the earliest date on or after the specified date (P_AT_DATE) that matches the specified day (P_DAY_N) and month (P_MONTH). Parameter P_DAY_N is a SMALLINT value between 1 and 31; the exact maximum depends on the month in accordance with normal date rules.

Examples:
```
-- Return the next 15th January after 2023-11-25.
VALUES datetime.next_day_n_of_month('2023-11-25', 15, 1);

15-01-2024

-- Return the next 29th February after 2024-03-01.
VALUES datetime.next_day_n_of_month('2024-03-01', 29, 2);

29-02-2028
```

### Function NEXT_1ST_DOW_N_OF_MONTH

This function returns the earliest date on or after the specified date (P_AT_DATE) that is the first occurrence of the specified day of the week (P_DOW_N) in the specified month (P_MONTH).

Examples:
```
-- Return the earlist date on or after 2024-11-05 that is the first Monday in November.
VALUES datetime.next_1st_dow_n_of_month('2024-11-05', 1, 11);

03-11-2025

-- Return the earlist date on or after 2024-11-05 that is the first Thursday in November.
VALUES datetime.next_1st_dow_n_of_month('2024-11-05', 4, 11);

07-11-2024
```

### Function NEXT_2ND_DOW_N_OF_MONTH

This function returns the earliest date on or after the specified date (P_AT_DATE) that is the second occurrence of the specified day of the week (P_DOW_N) in the specified month (P_MONTH).

Examples:
```
-- Return the earlist date on or after 2024-11-12 that is the second Tuesday in November.
VALUES datetime.next_2nd_dow_n_of_month('2024-11-12', 2, 11);

12-11-2024

-- Return the earlist date on or after 2024-11-12 that is the second Friday in November.
VALUES datetime.next_2nd_dow_n_of_month('2024-11-12', 5, 11);

14-11-2025
```

### Function NEXT_3RD_DOW_N_OF_MONTH

This function returns the earliest date on or after the specified date (P_AT_DATE) that is the third occurrence of the specified day of the week (P_DOW_N) in the specified month (P_MONTH).

Examples:
```
-- Return the earlist date on or after 2024-11-16 that is the third Sunday in November.
VALUES datetime.next_3rd_dow_n_of_month('2024-11-16', 7, 11);

17-11-2024

-- Return the earlist date on or after 2024-11-16 that is the third Friday in November.
VALUES datetime.next_3rd_dow_n_of_month('2024-11-16', 5, 11);

21-11-2025
```

### Function NEXT_4TH_DOW_N_OF_MONTH

This function returns the earliest date on or after the specified date (P_AT_DATE) that is the fourth occurrence of the specified day of the week (P_DOW_N) in the specified month (P_MONTH).

Examples:
```
-- Return the earlist date on or after 2024-11-16 that is the fourth Sunday in November.
VALUES datetime.next_4th_dow_n_of_month('2024-11-16', 7, 11);

24-11-2024

-- Return the earlist date on or after 2024-11-16 that is the fourth Friday in November.
VALUES datetime.next_4th_dow_n_of_month('2024-11-16', 5, 11);

22-11-2024
```

### Function NEXT_LAST_DOW_N_OF_MONTH

This function returns the earliest date on or after the specified date (P_AT_DATE) that is the last occurrence of the specified day of the week (P_DOW_N) in the specified month (P_MONTH).

Examples:
```
-- Return the earlist date on or after 2024-11-16 that is the last Sunday in November.
VALUES datetime.next_last_dow_n_of_month('2024-11-16', 7, 11);

24-11-2024

-- Return the earlist date on or after 2024-11-16 that is the last Friday in November.
VALUES datetime.next_last_dow_n_of_month('2024-11-16', 5, 11);

29-11-2024
```

### Function NEXT_EVERY_N_DAYS

This function returns the earliest date on or after the specified date (P_AT_DATE) with the specified days interval (P_N_DAYS) from the specified base date (P_BASE_DATE). Parameter P_N_DAYS is a SMALLINT value between 1 and 366.

Examples:
```
-- Return the earliest date on or after 2024-11-16 that is a multiple of 7 days from 2024-11-01.
VALUES datetime.next_every_n_days('2024-11-16', '2024-11-01', 7);

22-11-2024

-- Return the earliest date on or after 2024-11-01 that is a multiple of 5 days from 2024-11-16.
VALUES datetime.next_every_n_days('2024-11-01', '2024-11-16', 5);

16-11-2024
```

### Function NEXT_EVERY_N_WEEKS

This function returns the earliest date on or after the specified date (P_AT_DATE) with the specified days interval (P_N_WEEKS) from the specified base date (P_BASE_DATE). Parameter P_N_WEEKS is a SMALLINT value between 1 and 52.

Examples:
```
-- Return the earliest date on or after 2024-11-15 that is a multiple of 2 weeks from 2024-11-01.
VALUES datetime.next_every_n_weeks('2024-11-15', '2024-11-01', 2);

15-11-2024

-- Return the earliest date on or after 2024-11-01 that is a multiple of 3 weeks from 2024-11-01.
VALUES datetime.next_every_n_weeks('2024-11-15', '2024-11-01', 3);

22-11-2024
```

### Function NEXT_EVERY_N_MONTHS

This function returns the earliest date on or after the specified date (P_AT_DATE) with the specified months interval (P_N_MONTHS) from the specified base date (P_BASE_DATE). Parameter P_N_MONTHS is a SMALLINT value between 1 and 120.

Examples:
```
-- Return the earliest date on or after 2024-11-15 that is a multiple of 2 months from 2024-10-31.
VALUES datetime.next_every_n_months('2024-11-15', '2024-10-31', 2);

31-12-2024

-- Return the earliest date on or after 2024-11-15 that is a multiple of 4 months from 2024-10-31.
VALUES datetime.next_every_n_months('2024-11-15', '2024-10-31', 4);

28-02-2025
```

### Function NEXT_MONTH_END

This function returns the next month end date on or after the specified date (P_AT_DATE).

Examples:
```
-- Return the last day of the June after 2024-11-05.
VALUES datetime.next_month_end('2024-11-05');

30-11-2024
```

### Function NEXT_LAST_DAY_OF_MONTH

This function returns the date of the last day in the specified month (P_MONTH) on or after the specified date (P_AT_DATE).

Examples:
```
-- Return the last day of the June after 2024-11-01.
VALUES datetime.next_last_day_of_month('2024-11-01', 6);

30-06-2025
```

### Function NEXT_LEAP_DATE

This function returns the earliest date on or after the specified date (P_AT_DATE) that is 29th February.

Examples:
```
-- Return the earliest date on or after 2024-01-01 that is a leap date.
VALUES datetime.next_leap_date('2024-01-01');

29-02-2024

-- Return the earliest date on or after 2096-03-01 that is a leap date.
VALUES datetime.next_leap_date('2096-03-01');

29-02-2104
```
