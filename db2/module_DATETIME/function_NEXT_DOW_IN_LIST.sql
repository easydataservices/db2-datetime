ALTER MODULE datetime
ADD FUNCTION next_dow_in_list(p_at_date DATE, p_dow_bits SMALLINT)  RETURNS DATE
  DETERMINISTIC
  NO EXTERNAL ACTION
BEGIN
  DECLARE v_count SMALLINT;
  DECLARE v_dow SMALLINT;
  DECLARE v_result_date DATE;

  -- Return error if P_AT_DATE is beyond the range of calculation.
  DECLARE CONTINUE HANDLER FOR SQLSTATE '22008'
    SIGNAL SQLSTATE 'TZ001' SET MESSAGE_TEXT = 'P_AT_DATE is beyond calculation range';

  -- Check for invalid inputs.
  IF p_dow_bits NOT BETWEEN 1 AND 127 THEN
    SIGNAL SQLSTATE 'TZ002' SET MESSAGE_TEXT = 'P_DOW_BITS out of range';
  END IF;

  -- Handle NULL input, returning NULL.
  IF p_at_date IS NULL OR p_dow_bits IS NULL THEN
    RETURN NULL;
  END IF;

  -- Iterate through future dates until a bit mask match is found.
  SET v_count = 0;
  WHILE v_count < 7 AND v_result_date IS NULL DO
    SET v_dow = DAYOFWEEK_ISO(p_at_date + v_count DAYS);
    IF BITAND(POWER(2, v_dow - 1), p_dow_bits) > 0 THEN
      SET v_result_date = p_at_date + v_count DAYS;
    END IF;
    SET v_count = v_count + 1;
  END WHILE;

  -- Return result.
  RETURN v_result_date;
END@
