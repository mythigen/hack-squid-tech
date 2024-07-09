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
);INTO users_sessions

-- User Event: Create Session
INSERT INTO users_sessions (
  user_id,
  session_id,
)
VALUES (
  (SELECT id FROM users WHERE email = $1),
  $2
);

-- User Event: Extend Session Lifetime
UPDATE users_sessions
SET expires_idle_at = NOW() + INTERVAL '3 DAY'
WHERE session_id = $1;

-- User Event: Check Session Validity
SELECT session_id
FROM users_sessions
WHERE session_id = $1
AND expires_idle_at > NOW()
AND expires_active_at > NOW()
AND (suspended_at = NULL OR suspended_at > NOW());

-- User Event: Create Invitation on Sign-up
INSERT INTO users_invitations (
  user_id,
  uuid
)
VALUES ( 
  (SELECT id FROM users WHERE email = $1),
  $2
);

-- User Event: Create Invitation
INSERT INTO users_invitations (
  user_id,
  invitation_type,
  uuid
)
VALUES ( 
  (SELECT id FROM users WHERE email = $1),
  $2, $3
);

-- User Event: Use Invitation
UPDATE users_invitations
SET used_at = NOW()
WHERE uuid = $1
AND expires_at > NOW()
AND (suspended_at = NULL OR suspended_at > NOW());

-- User Event: Log Failed attempts
INSERT INTO users_failed_attempts (
  email,
  ip,
)
VALUES (
  $1, $2
);

-- User Event: Setup Profile  - Full
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

