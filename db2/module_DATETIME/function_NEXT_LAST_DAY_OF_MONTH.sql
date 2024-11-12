ALTER MODULE datetime
ADD FUNCTION next_last_day_of_month(p_at_date DATE, p_month SMALLINT) RETURNS DATE
  DETERMINISTIC
  NO EXTERNAL ACTION
BEGIN
  DECLARE c_day_1 DATE CONSTANT '0001-01-01';
  DECLARE v_calculated_date DATE;

  -- Return error if P_AT_DATE is beyond the range of calculation.
  DECLARE CONTINUE HANDLER FOR SQLSTATE '22008'
    SIGNAL SQLSTATE 'TZ001' SET MESSAGE_TEXT = 'P_AT_DATE is beyond calculation range';

  -- If the specified month is out of range then return an error.
  IF p_month NOT BETWEEN 1 AND 12 THEN
    SIGNAL SQLSTATE 'TZ002' SET MESSAGE_TEXT = 'P_MONTH out of range';
  END IF;

  -- Handle NULL input, returning NULL.
  IF p_at_date IS NULL OR p_month IS NULL THEN
    RETURN NULL;
  END IF;

  -- Calculate result.
  IF MONTH(p_at_date) > p_month THEN
    SET v_calculated_date = c_day_1 + YEAR(p_at_date) YEARS + (p_month - 1) MONTHS;
  ELSE
    SET v_calculated_date = c_day_1 + (YEAR(p_at_date) - 1) YEARS + (p_month - 1) MONTHS;
  END IF;
  SET v_calculated_date = v_calculated_date + DAYS_TO_END_OF_MONTH(v_calculated_date) DAYS;

  -- Return result.
  RETURN v_calculated_date;
END@
