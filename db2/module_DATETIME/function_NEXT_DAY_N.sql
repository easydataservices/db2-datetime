ALTER MODULE datetime
ADD FUNCTION next_day_n(p_at_date DATE, p_day_n SMALLINT) RETURNS DATE
  DETERMINISTIC
  NO EXTERNAL ACTION
BEGIN
  DECLARE c_day_1 DATE CONSTANT '0001-01-01';
  DECLARE v_month_start_date DATE;
  DECLARE v_calculated_date DATE;

  -- Check for invalid inputs.
  IF p_day_n NOT BETWEEN 1 AND 31 THEN
    SIGNAL SQLSTATE 'TZ002' SET MESSAGE_TEXT = 'P_DAY_N out of range';
  END IF;

  -- Handle NULL input, returning NULL.
  IF p_at_date IS NULL OR p_day_n IS NULL THEN
    RETURN NULL;
  END IF;

  -- Calculate first day of the month of the supplied date.
  SET v_month_start_date = c_day_1 + (YEAR(p_at_date) - 1) YEARS + (MONTH(p_at_date) - 1) MONTHS;

  -- Calculate start month for search.
  IF DAY(p_at_date) > p_day_n THEN
    SET v_month_start_date = v_month_start_date + 1 MONTH;
  END IF;

  -- Calculate the result.
  BEGIN
    -- Handle delegated function exception by continuing search.
    DECLARE CONTINUE HANDLER FOR SQLSTATE 'TZ002'
      SET v_calculated_date = NULL;

    WHILE v_calculated_date IS NULL DO
      SET v_calculated_date = next_day_n_of_month(v_month_start_date, p_day_n, MONTH(v_month_start_date));
      SET v_month_start_date = v_month_start_date + 1 MONTH;
    END WHILE;
  END;

  -- If the specified day is 29th then use the next leap date if it returns an earlier date.
  IF p_day_n = 29 AND next_leap_date(p_at_date) < v_calculated_date THEN
    SET v_calculated_date = next_leap_date(p_at_date);
  END IF;

  -- Return result.
  RETURN v_calculated_date;
END@
