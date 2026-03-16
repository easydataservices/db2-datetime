ALTER MODULE datetime
ADD FUNCTION next_3rd_dow_n(p_at_date DATE, p_dow_n SMALLINT) RETURNS DATE
  DETERMINISTIC
  NO EXTERNAL ACTION
BEGIN
  DECLARE v_calculated_date DATE;

  -- Calculate result.
  SET v_calculated_date = next_3rd_dow_n_of_month(p_at_date, p_dow_n, MONTH(p_at_date));

  -- If the result is a future year then recalculate using the following month.
  IF YEAR(v_calculated_date) > YEAR(p_at_date) THEN
    SET v_calculated_date = next_3rd_dow_n_of_month(p_at_date, p_dow_n, MOD(MONTH(p_at_date), 12) + 1);
  END IF;

  -- Return result.
  RETURN v_calculated_date;
END@
