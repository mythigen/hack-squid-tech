-- USERS TABLE
CREATE TABLE IF NOT EXISTS users (
  id SERIAL PRIMARY KEY,
  email VARCHAR(255) UNIQUE NOT NULL,
  first_name VARCHAR(255) NOT NULL,
  last_name VARCHAR(255) NOT NULL,
  role INT DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  suspended_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- USERS PROFILES
CREATE TABLE IF NOT EXISTS users_profiles (
  id SERIAL PRIMARY KEY,
  user_id INT,
  phone_number VARCHAR(255),
  country VARCHAR(255),
  region VARCHAR(255),
  address VARCHAR(255),
  gender BOOLEAN,
  FOREIGN KEY(user_id) REFERENCES users(id)
);

-- USERS MEDIA
CREATE TABLE IF NOT EXISTS users_media (
  id SERIAL PRIMARY KEY,
  uesr_id INT,
  file_name VARCHAR(255),
  file_type VARCHAR(255),
  flag VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  removed_at TIMESTAMP,
  FOREIGN KEY(user_id) REFERENCES users(id)
);

-- USERS AUTHENTICATION KEYS TABLE
CREATE TABLE IF NOT EXISTS users_authentication_keys (
  id SERIAL PRIMARY KEY,
  user_id INT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  suspended_at TIMESTAMP,
  FOREIGN KEY(user_id) REFERENCES users(id)
);

-- USERS AUTHENTICATION CREDENTIALS TABLE
CREATE TABLE IF NOT EXISTS users_authentication_credentials (
  id SERIAL PRIMARY KEY,
  user_id INT,
  username VARCHAR(255) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  is_temporary BOOLEAN DEFAULT TRUE,
  is_primary BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  suspended_at TIMESTAMP,
  FOREIGN KEY(user_id) REFERENCES users(id)
);

-- USERS ACTIVE SESSIONS TABLE
CREATE TABLE IF NOT EXISTS users_active_sessions (
  id SERIAL PRIMARY KEY,
  user_id INT,
  session_id VARCHAR(255),
  expires_active_at TIMESTAMP,
  suspended_at TIMESTAMP,
  FOREIGN KEY(user_id) REFERENCES users(id)
);

-- USERS IDLE SESSIONS TABLE
CREATE TABLE IF NOT EXISTS users_idle_sessions (
  id SERIAL PRIMARY KEY,
  active_session_id INT,
  expires_idle_at TIMESTAMP,
  FOREIGN KEY(active_session_id) REFERENCES users_active_sessions(id)
);

-- USERS INVITATIONS TABLE
CREATE TABLE IF NOT EXISTS users_invitations (
  id SERIAL PRIMARY KEY,
  user_id INT,
  invitation_type VARCHAR(10) DEFAULT 'NEW',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  suspended_at TIMESTAMP,
  FOREIGN KEY(user_id) REFERENCES users(id)
);

-- USERS INVITATION UUID TABLE
CREATE TABLE IF NOT EXISTS users_invitation_uuid (
  id SERIAL PRIMARY KEY,
  invitation_id INT,
  uuid VARCHAR(255) UNIQUE NOT NULL,
  active BOOLEAN DEFAULT FALSE,
  FOREIGN KEY(invitation_id) REFERENCES users_invitations(id)
);

-- USERS FAILED ATTEMPTS TABLE
CREATE TABLE IF NOT EXISTS users_failed_attempts (
  id SERIAL PRIMARY KEY,
  email VARCHAR(255) NOT NULL,
  password VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

/* Part II - User Relations */

CREATE IF NOT EXISTS connections (
  id SERIAL PRIMARY KEY,
  created_by INT,
  sent_to INT,
  -- created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (created_by) REFERENCES users(id),
  FOREIGN KEY (sent_to) REFERENCES users(id)
);

CREATE IF NOT EXISTS connections_states (
  id SERIAL PRIMARY KEY,
  connection_id INT,
  connection_state, -- Requested, Approved, Rejected, Blocked
  created_at TIMESTAMP,
  FOREIGN KEY(connection_id) REFERENCES connections(id)
);
