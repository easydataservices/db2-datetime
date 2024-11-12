ALTER MODULE datetime
ADD FUNCTION next_leap_date(p_at_date DATE) RETURNS DATE
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
  IF p_at_date IS NULL THEN
    RETURN NULL;
  END IF;

  -- Calculate first day of the year of the supplied date; add a year if the supplied date is after February.
  SET v_year_start_date = c_day_1 + (YEAR(p_at_date) - 1) YEARS;
  IF MONTH(p_at_date) > 2 THEN
    SET v_year_start_date = v_year_start_date + 1 YEAR;
  END IF;

  -- Calculate a potential leap date.
  SET v_calculated_date = v_year_start_date + 1 MONTH + 28 DAYS;

  -- If the potential leap date is an actual leap date then return it; otherwise try the next year.
  IF (MONTH(v_calculated_date), DAY(v_calculated_date)) = (2, 29) THEN
    RETURN v_calculated_date;
  ELSE
    RETURN next_leap_date(v_year_start_date + 1 YEAR);
  END IF;
END@
