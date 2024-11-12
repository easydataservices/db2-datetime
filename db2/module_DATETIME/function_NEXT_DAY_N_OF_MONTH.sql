ALTER MODULE datetime
ADD FUNCTION next_day_n_of_month(p_at_date DATE, p_day_n SMALLINT, p_month SMALLINT) RETURNS DATE
  DETERMINISTIC
  NO EXTERNAL ACTION
BEGIN
  DECLARE c_day_1 DATE CONSTANT '0001-01-01';
  DECLARE v_year_start_date DATE;
  DECLARE v_calculated_date DATE;

  -- Return error if P_AT_DATE is beyond the range of calculation.
  DECLARE CONTINUE HANDLER FOR SQLSTATE '22008'
    SIGNAL SQLSTATE 'TZ001' SET MESSAGE_TEXT = 'P_AT_DATE is beyond calculation range';

  -- Handle NULL input, returning NULL.
  IF p_at_date IS NULL OR p_day_n IS NULL OR p_month IS NULL THEN
    RETURN NULL;
  END IF;

  -- If the specified day and month requests a leap date then delegate; otherwise calculate the result.
  IF (p_month, p_day_n) = (2, 29) THEN
    RETURN next_leap_date(p_at_date);
  ELSE
    -- Calculate first day of the year of the supplied date.
    SET v_year_start_date = c_day_1 + (YEAR(p_at_date) - 1) YEARS;

    -- Add a year if the supplied date has a day and month after the specified day and month.
    IF (MONTH(p_at_date), DAY(p_at_date)) > (p_month, p_day_n) THEN
      SET v_year_start_date = v_year_start_date + 1 YEAR;
    END IF;

    -- Calculate the potential result.
    SET v_calculated_date = v_year_start_date + (p_month - 1) MONTHS + (p_day_n - 1) DAYS;

    -- Check for an invalid result.
    IF (MONTH(v_calculated_date), DAY(v_calculated_date)) != (p_month, p_day_n) THEN
      SIGNAL SQLSTATE 'TZ002' SET MESSAGE_TEXT = 'Illegal P_DAY_N or P_MONTH inputs';
    END IF;
  END IF;

  -- Return result.
  RETURN v_calculated_date;
END@

