ALTER MODULE datetime
ADD FUNCTION is_between_times(p_at_time TIME, p_start_time TIME, p_end_time TIME) RETURNS BOOLEAN
  DETERMINISTIC
  NO EXTERNAL ACTION
BEGIN
  -- Handle NULL input, returning NULL.
  IF p_at_time IS NULL OR p_start_time IS NULL OR p_end_time IS NULL THEN
    RETURN NULL;
  END IF;

  -- Adjust inputs.
  SET p_at_time = CASE WHEN p_at_time = '24:00' THEN '00:00' ELSE p_at_time END;
  SET p_start_time = CASE WHEN p_start_time = '24:00' THEN '00:00' ELSE p_start_time END;
  SET p_end_time = CASE WHEN p_end_time = '24:00' THEN '00:00' ELSE p_end_time END;

  -- Calculate and return result.
  IF p_start_time < p_end_time THEN
    IF p_at_time BETWEEN p_start_time AND p_end_time THEN
      RETURN TRUE;
    ELSE
      RETURN FALSE;
    END IF;
  ELSEIF p_start_time > p_end_time THEN
    IF p_at_time BETWEEN p_start_time AND '24:00' THEN
      RETURN TRUE;
    ELSEIF p_at_time BETWEEN '00:00' AND p_end_time THEN
      RETURN TRUE;
    ELSE
      RETURN FALSE;
    END IF;
  ELSE
    RETURN TRUE;
  END IF;
END@
