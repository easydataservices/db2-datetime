ALTER MODULE datetime
ADD FUNCTION next_every_n_days(p_at_date DATE, p_base_date DATE, p_n_days SMALLINT) RETURNS DATE
  DETERMINISTIC
  NO EXTERNAL ACTION
BEGIN
  DECLARE v_delta_days INTEGER;
  DECLARE v_calculated_date DATE;

  -- Return error if P_AT_DATE is beyond the range of calculation.
  DECLARE CONTINUE HANDLER FOR SQLSTATE '22008'
    SIGNAL SQLSTATE 'TZ001' SET MESSAGE_TEXT = 'P_AT_DATE is beyond calculation range';

  -- Check for invalid inputs.
  IF p_n_days NOT BETWEEN 1 AND 366 THEN
    SIGNAL SQLSTATE 'TZ002' SET MESSAGE_TEXT = 'P_N_DAYS out of range';
  END IF;

  -- Handle NULL input, returning NULL.
  IF p_at_date IS NULL OR p_base_date IS NULL OR p_n_days IS NULL THEN
    RETURN NULL;
  END IF;

  -- Early exit if P_AT_DATE is not after P_BASE_DATE.
  IF p_at_date <= p_base_date THEN
    RETURN p_base_date;
  END IF;

  -- Calculate the result.
  SET v_delta_days = DAYS(p_at_date) - DAYS(p_base_date);
  IF MOD(v_delta_days, p_n_days) = 0 THEN
    SET v_calculated_date = p_at_date;
  ELSE
    SET v_calculated_date = p_at_date + (p_n_days - MOD(v_delta_days, p_n_days)) DAYS;
  END IF;

  -- Return result.
  RETURN v_calculated_date;
END@
