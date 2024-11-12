ALTER MODULE datetime
ADD FUNCTION next_3rd_dow_n_of_month(p_at_date DATE, p_dow_n SMALLINT, p_month SMALLINT) RETURNS DATE
  DETERMINISTIC
  NO EXTERNAL ACTION
BEGIN
  DECLARE c_day_1 DATE CONSTANT '0001-01-01';
  DECLARE v_month_start_date DATE;
  DECLARE v_calculated_date DATE;

  -- Return error if P_AT_DATE is beyond the range of calculation.
  DECLARE CONTINUE HANDLER FOR SQLSTATE '22008'
    SIGNAL SQLSTATE 'TZ001' SET MESSAGE_TEXT = 'P_AT_DATE is beyond calculation range';

  -- Check for invalid inputs.
  IF p_dow_n NOT BETWEEN 1 AND 7 OR p_month NOT BETWEEN 1 AND 12 THEN
    SIGNAL SQLSTATE 'TZ002' SET MESSAGE_TEXT = 'P_DOW_N or P_MONTH out of range';
  END IF;

  -- Handle NULL input, returning NULL.
  IF p_at_date IS NULL OR p_dow_n IS NULL OR p_month IS NULL THEN
    RETURN NULL;
  END IF;

  -- Calculate first day of the month of the supplied date.
  SET v_month_start_date = c_day_1 + (YEAR(p_at_date) - 1) YEARS + (p_month - 1) MONTHS;

  -- Calculate result.
  IF DAYOFWEEK_ISO(v_month_start_date) > p_dow_n THEN
    SET v_calculated_date = v_month_start_date + (7 + p_dow_n - DAYOFWEEK_ISO(v_month_start_date)) DAYS + 14 DAYS;
  ELSE
    SET v_calculated_date = v_month_start_date + (p_dow_n - DAYOFWEEK_ISO(v_month_start_date)) DAYS + 14 DAYS;
  END IF;

  -- If the result is before the specified start date then recalculate from start of following year.
  IF v_calculated_date < p_at_date THEN
    RETURN next_3rd_dow_n_of_month(c_day_1 + YEAR(p_at_date) YEARS, p_dow_n, p_month);
  END IF;

  -- Return result.
  RETURN v_calculated_date;
END@
