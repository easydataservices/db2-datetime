ALTER MODULE datetime
ADD FUNCTION next_every_n_months(p_at_date DATE, p_base_date DATE, p_n_months SMALLINT) RETURNS DATE
  DETERMINISTIC
  NO EXTERNAL ACTION
BEGIN
  DECLARE v_delta_months INTEGER;
  DECLARE v_calculated_date DATE;

  -- Return error if P_AT_DATE is beyond the range of calculation.
  DECLARE CONTINUE HANDLER FOR SQLSTATE '22008'
    SIGNAL SQLSTATE 'TZ001' SET MESSAGE_TEXT = 'P_AT_DATE is beyond calculation range';

  -- Check for invalid inputs.
  IF p_n_months NOT BETWEEN 1 AND 120 THEN
    SIGNAL SQLSTATE 'TZ002' SET MESSAGE_TEXT = 'P_N_MONTHS out of range';
  END IF;

  -- Handle NULL input, returning NULL.
  IF p_at_date IS NULL OR p_base_date IS NULL OR p_n_months IS NULL THEN
    RETURN NULL;
  END IF;

  -- Early exit if P_AT_DATE is not after P_BASE_DATE.
  IF p_at_date <= p_base_date THEN
    RETURN p_base_date;
  END IF;

  -- Calculate the result. 
  SET v_delta_months = 12 * (YEAR(p_at_date) - YEAR(p_base_date)) + MONTH(p_at_date) - MONTH(p_base_date);
  IF MOD(v_delta_months, p_n_months) = 0 THEN
    SET v_calculated_date = p_base_date + v_delta_months MONTHS;
  ELSE
    SET v_calculated_date = p_base_date + (v_delta_months + p_n_months - MOD(v_delta_months, p_n_months)) MONTHS;
  END IF;

  -- If the result is before the specified start date then return result calculated from start of following month.
  IF v_calculated_date < p_at_date THEN
    RETURN next_every_n_months(p_at_date + (1 + DAYS_TO_END_OF_MONTH(p_at_date)) DAYS, p_base_date, p_n_months);
  END IF;

  -- Return result.
  RETURN v_calculated_date;
END@
