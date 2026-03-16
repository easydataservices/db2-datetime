ALTER MODULE datetime
ADD FUNCTION next_every_n_hours(p_at_time TIME, p_base_from_time TIME, p_base_to_time TIME, p_n_hours SMALLINT) RETURNS TIME
  DETERMINISTIC
  NO EXTERNAL ACTION
BEGIN
  -- Check for invalid inputs.
  IF p_n_hours NOT BETWEEN 1 AND 48 THEN
    SIGNAL SQLSTATE 'TZ002' SET MESSAGE_TEXT = 'P_N_HOURS out of range';
  END IF;

  -- Return result.
  RETURN next_every_n_seconds(p_at_time, p_base_from_time, p_base_to_time, p_n_hours * 3600);
END@
