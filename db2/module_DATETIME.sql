CREATE OR REPLACE MODULE datetime;

-- Return first date on or after the specified date with the specified days interval from the specified base date.
ALTER MODULE datetime
PUBLISH FUNCTION next_every_n_days(p_at_date DATE, p_base_date DATE, p_n_days SMALLINT) RETURNS DATE;

-- Return first date on or after the specified date with the specified weeks interval from the specified base date.
ALTER MODULE datetime
PUBLISH FUNCTION next_every_n_weeks(p_at_date DATE, p_base_date DATE, p_n_weeks SMALLINT) RETURNS DATE;

-- Return first date on or after the specified date with the specified months interval from the specified base date.
ALTER MODULE datetime
PUBLISH FUNCTION next_every_n_months(p_at_date DATE, p_base_date DATE, p_n_months SMALLINT) RETURNS DATE;

-- Return first date on or after the specified date with the specified day.
ALTER MODULE datetime
PUBLISH FUNCTION next_day_n(p_at_date DATE, p_day_n SMALLINT) RETURNS DATE;

-- Return month end date on or after the specified date.
ALTER MODULE datetime
PUBLISH FUNCTION next_last_day(p_at_date DATE) RETURNS DATE;

-- Return first date on or after the specified date with the first occurence of the specified day of week.
ALTER MODULE datetime
PUBLISH FUNCTION next_1st_dow_n(p_at_date DATE, p_dow_n SMALLINT) RETURNS DATE;

-- Return first date on or after the specified date with the second occurence of the specified day of week.
ALTER MODULE datetime
PUBLISH FUNCTION next_2nd_dow_n(p_at_date DATE, p_dow_n SMALLINT) RETURNS DATE;

-- Return first date on or after the specified date with the third occurence of the specified day of week.
ALTER MODULE datetime
PUBLISH FUNCTION next_3rd_dow_n(p_at_date DATE, p_dow_n SMALLINT) RETURNS DATE;

-- Return first date on or after the specified date with the fourth occurence of the specified day of week.
ALTER MODULE datetime
PUBLISH FUNCTION next_4th_dow_n(p_at_date DATE, p_dow_n SMALLINT) RETURNS DATE;

-- Return first date on or after the specified date with the final occurence of the specified day of week.
ALTER MODULE datetime
PUBLISH FUNCTION next_last_dow_n(p_at_date DATE, p_dow_n SMALLINT) RETURNS DATE;

-- Return first date on or after the specified date with the specified day and month.
ALTER MODULE datetime
PUBLISH FUNCTION next_day_n_of_month(p_at_date DATE, p_day_n SMALLINT, p_month SMALLINT) RETURNS DATE;

-- Return the date of the last day in the specified month on or after the specified date.
ALTER MODULE datetime
PUBLISH FUNCTION next_last_day_of_month(p_at_date DATE, p_month SMALLINT) RETURNS DATE;

-- Return first date on or after the specified date with the first occurence of the specified day of week in the specified month.
ALTER MODULE datetime
PUBLISH FUNCTION next_1st_dow_n_of_month(p_at_date DATE, p_dow_n SMALLINT, p_month SMALLINT) RETURNS DATE;

-- Return first date on or after the specified date with the second occurence of the specified day of week in the specified month.
ALTER MODULE datetime
PUBLISH FUNCTION next_2nd_dow_n_of_month(p_at_date DATE, p_dow_n SMALLINT, p_month SMALLINT) RETURNS DATE;

-- Return first date on or after the specified date with the third occurence of the specified day of week in the specified month.
ALTER MODULE datetime
PUBLISH FUNCTION next_3rd_dow_n_of_month(p_at_date DATE, p_dow_n SMALLINT, p_month SMALLINT) RETURNS DATE;

-- Return first date on or after the specified date with the fourth occurence of the specified day of week in the specified month.
ALTER MODULE datetime
PUBLISH FUNCTION next_4th_dow_n_of_month(p_at_date DATE, p_dow_n SMALLINT, p_month SMALLINT) RETURNS DATE;

-- Return first date on or after the specified date with the final occurence of the specified day of week in the specified month.
ALTER MODULE datetime
PUBLISH FUNCTION next_last_dow_n_of_month(p_at_date DATE, p_dow_n SMALLINT, p_month SMALLINT) RETURNS DATE;

-- Return first date on or after the specified date that is 29th February.
ALTER MODULE datetime
PUBLISH FUNCTION next_leap_date(p_at_date DATE) RETURNS DATE;

-- Return date with the specified number of days before the specified date.
ALTER MODULE datetime
PUBLISH FUNCTION days_before(p_at_date DATE, p_offset_n SMALLINT) RETURNS DATE;
