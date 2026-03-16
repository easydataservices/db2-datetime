ALTER MODULE datetime
ADD FUNCTION days_before(p_at_date DATE, p_offset_n SMALLINT) RETURNS DATE
  DETERMINISTIC
  NO EXTERNAL ACTION
BEGIN
  DECLARE v_calculated_date DATE;

  -- Return error if P_AT_DATE is beyond the range of calculation.
  DECLARE CONTINUE HANDLER FOR SQLSTATE '22008'
    SIGNAL SQLSTATE 'TZ001' SET MESSAGE_TEXT = 'P_AT_DATE is beyond calculation range';

  -- If the specified offset or month is out of range then return an error.
  IF p_offset_n NOT BETWEEN 0 AND 14 THEN
    SIGNAL SQLSTATE 'TZ002' SET MESSAGE_TEXT = 'P_OFFSET_N out of range';
  END IF;

  -- Calculate result.
  SET v_calculated_date = p_at_date - p_offset_n DAYS;

  -- Return result.
  RETURN v_calculated_date;
END@
