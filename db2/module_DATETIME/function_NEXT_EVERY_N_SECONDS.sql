ALTER MODULE datetime
ADD FUNCTION next_every_n_seconds(p_at_time TIME, p_base_from_time TIME, p_base_to_time TIME, p_n_seconds INTEGER) RETURNS TIME
  DETERMINISTIC
  NO EXTERNAL ACTION
BEGIN
  DECLARE v_at_midnight_seconds INTEGER;
  DECLARE v_base_from_midnight_seconds INTEGER;
  DECLARE v_delta_seconds INTEGER;
  DECLARE v_adjustment_seconds INTEGER;
  DECLARE v_calculated_time TIME;

  -- Handle NULL input, returning NULL.
  IF p_at_time IS NULL OR p_base_from_time IS NULL OR p_n_seconds IS NULL THEN
    RETURN NULL;
  END IF;

  -- Adjust other inputs.
  SET p_base_from_time = CASE WHEN p_base_from_time = '24:00' THEN '00:00' ELSE p_base_from_time END;
  SET p_base_to_time = CASE WHEN p_base_to_time = '24:00' THEN '00:00' ELSE p_base_to_time END;
  SET p_base_to_time = COALESCE(p_base_to_time, p_base_from_time);

  -- Early out if supplied time is outside time range.
  IF NOT is_between_times(p_at_time, p_base_from_time, p_base_to_time) THEN
    RETURN p_base_from_time;
  END IF;

  -- Calculate values used to derive result.
  SET v_at_midnight_seconds = MIDNIGHT_SECONDS(p_at_time);
  SET v_base_from_midnight_seconds = MIDNIGHT_SECONDS(p_base_from_time);

  -- Calculate provisional result
  IF p_at_time >= p_base_from_time THEN
    SET v_delta_seconds = v_at_midnight_seconds - v_base_from_midnight_seconds;
  ELSE
    SET v_delta_seconds = 86400 - v_base_from_midnight_seconds + v_at_midnight_seconds;
  END IF;
  SET v_adjustment_seconds = MOD(v_delta_seconds, p_n_seconds);
  SET v_calculated_time = p_at_time - v_adjustment_seconds SECONDS;
  IF v_adjustment_seconds > 0 THEN
    SET v_calculated_time = v_calculated_time + p_n_seconds SECONDS;
  END IF;

  -- If the result is outside the permitted time range then return range start time.
  IF NOT is_between_times(v_calculated_time, p_base_from_time, p_base_to_time) THEN
    RETURN p_base_from_time;
  -- If the result is less than 1 interval after the range start time then return range start time.
  ELSEIF is_between_times(v_calculated_time, p_base_from_time + 1 SECOND, p_base_from_time + (p_n_seconds - 1) SECONDS) THEN
    RETURN p_base_from_time;
  END IF;

  -- Return calculated result.
  RETURN v_calculated_time;
END@
