ALTER MODULE datetime
ADD FUNCTION next_month_end(p_at_date DATE) RETURNS DATE
  DETERMINISTIC
  NO EXTERNAL ACTION
BEGIN
  DECLARE v_calculated_date DATE;

  -- Return error if P_AT_DATE is beyond the range of calculation.
  DECLARE CONTINUE HANDLER FOR SQLSTATE '22008'
    SIGNAL SQLSTATE 'TZ001' SET MESSAGE_TEXT = 'P_AT_DATE is beyond calculation range';

  -- Calculate result.
  SET v_calculated_date = p_at_date + DAYS_TO_END_OF_MONTH(p_at_date) DAYS;

  -- Return result.
  RETURN v_calculated_date;
END@
