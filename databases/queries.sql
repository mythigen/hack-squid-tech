-- User Event: Sign-up
INSERT INTO users(email)
VALUES($1);

INSERT INTO users_authentication_credentials(
  user_id,
  username,
  password,
  is_primary
)
VALUES(
  (SELECT id FROM users WHERE email = $1),
  CONCAT('EMAIL ', $2),
  $3, 
  true
);

-- User Event: Setup Profile - Full
INSERT INTO users_profiles (
  user_id,
  phone_number,
  country,
  region,
  address,
  gender
) 
VALUES (
  (SELECT user_id AS id FROM users_sessions WHERE session_id = $1),
  $2, $3, $4, $5, $6
);

-- User Event: Setup Profile - Partial
INSERT INTO users_profiles (
  user_id,
  {{column_name}}
) 
VALUES (
  (SELECT user_id AS id FROM users_sessions WHERE session_id = $1),
  $2
);

-- User Event: Update Profile - Full
UPDATE users_profiles SET (
  phone_number,
  country,
  region,
  address,
  gender
) = (
  $1, $2, $3, $4, $5
)
WHERE user_id = (
  SELECT user_id AS id FROM users_sessions WHERE session_id = $6
);

-- User Event: Update Profile - Partial
UPDATE users_profiles 
SET {{ column_name }} = $1
WHERE user_id = (
  SELECT user_id AS id FROM users_sessions WHERE session_id = $2
);

-- User Event: Upload Media
INSERT INTO users_media (
  user_id,
  file_name,
  file_type,
  flag
)
VALUES (
  (SELECT user_id AS id FROM users_sessions WHERE session_id = $1),
  $2, $3, $4
);

-- User Event: Delete Media
UPDATE users_media 
SET flag = 'REMOVED'
WHERE file_name = $1
AND user_id = (SELECT user_id AS id FROM users_sessions WHERE session_id = $2);

-- User Event: Update Cover or Profile Picture
UPDATE users_media 
SET flag = $1
WHERE file_name != $2
AND user_id = (SELECT user_id AS id FROM users_sessions WHERE session_id = $3);

