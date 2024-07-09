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
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY(connection_id) REFERENCES connections(id)
);

-- Part III- Posts
CREATE IF NOT EXISTS posts (
  id SERIAL PRIMARY KEY,
  created_by INT,
  content VARCHAR(1024),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP,
  FOREIGN KEY(created_by) REFERENCES users(id)
);

CREATE IF NOT EXISTS posts_interractions (
  id SERIAL PRIMARY KEY,
  post_id INT,
  created_by INT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP,
  FOREIGN KEY(post_id) REFERENCES posts(id),
  FOREIGN KEY(created_by) REFERENCES users(id)
);

CREATE IF NOT EXISTS posts_comments (
  id SERIAL PRIMARY KEY,
  post_id INT,
  created_by INT,
  content VARCHAR(512),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP,
  FOREIGN KEY(post_id) REFERENCES posts(id),
  FOREIGN KEY(created_by) REFERENCES users(id)
);

CREATE IF NOT EXISTS posts_comments_interractions (
  id SERIAL PRIMARY KEY,
  comment_id INT,
  created_by INT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP,
  FOREIGN KEY(comment_id) REFERENCES posts_comments(id),
  FOREIGN KEY(created_by) REFERENCES users(id)
);

CREATE IF NOT EXISTS posts_reports (
  id SERIAL PRIMARY KEY,
  post_id INT,
  created_by INT,
  report_type VARCHAR(256),
  content VARCHAR(512),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP,
  FOREIGN KEY(post_id) REFERENCES posts(id),
  FOREIGN KEY(created_by) REFERENCES users(id)
);

CREATE IF NOT EXISTS posts_comments_reports (
  id SERIAL PRIMARY KEY,
  comment_id INT,
  created_by INT,
  report_type VARCHAR(256),
  content VARCHAR(512),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP,
  FOREIGN KEY(comment_id) REFERENCES posts_comments(id),
  FOREIGN KEY(created_by) REFERENCES users(id)
);

CREATE IF NOT EXISTS posts_media (
  id SERIAL PRIMARY KEY,
  post_id INT,
  file_name VARCHAR(255),
  file_type VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  removed_at DATETIME,
  FOREIGN KEY(post_id) REFERENCES posts(id)
);

CREATE IF NOT EXISTS posts_tags (
  id SERIAL PRIMARY KEY,
  post_id INT,
  tag_name VARCHAR(255),
  FOREIGN KEY(post_id) REFERENCES posts(id)
);

CREATE IF NOT EXISTS posts_resposts (
  id SERIAL PRIMARY KEY,
  post_id INT,
  resposted_by INT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP,
  FOREIGN KEY(post_id) REFERENCES posts(id),
  FOREIGN KEY(reposted_by) REFERENCES users(id)
);

-- Part IV - Events
CREATE IF NOT EXISTS event (
  id SERIAL PRIMARY KEY,
  created_by INT,
  title VARCHAR(255),
  description VARCHAR(1024),
  event_type VARCHAR(255),
  address VARCHAR(255),
  checkin_validation_method VARHCAR(255),
  task_validation_method VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP,
  FOREIGN KEY(created_by) REFERENCES users(id)
);

CREATE IF NOT EXISTS event_interested (
  id SERIAL PRIMARY KEY,
  event_id INT,
  user_id INT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP,
  FOREIGN KEY(event_id) REFERENCES event(id),
  FOREIGN KEY(user_id) REFERENCES users(id)
);

CREATE IF NOT EXISTS event_organizers_invitations (
  id SERIAL PRIMARY KEY,
  event_id INT,
  sent_to INT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP,
  FOREIGN KEY(event_id) REFERENCES event(id),
  FOREIGN KEY(sent_to) REFERENCES users(id)
);

CREATE IF NOT EXISTS event_organizers_invitations_states (
  id SERIAL PRIMARY KEY,
  invitation_id INT,
  connection_state,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY(invitation_id) REFERENCES event_organizers_invitations(id)
);

CREATE IF NOT EXISTS event_planning (
  id SERIAL PRIMARY KEY,
  event_id INT,
  activity_name VARCHAR(255),
  activity_description VARCHAR(255),
  activity_begins_at DATETIME,
  activity_ends_at DATETIME,
  FOREIGN KEY(event_id) REFERENCES event(id)
);

CREATE IF NOT EXISTS event_media (
  id SERIAL PRIMARY KEY,
  event_id INT,
  file_name VARCHAR(255),
  file_type VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  removed_at DATETIME,
  FOREIGN KEY(event_id) REFERENCES event(id)
);

CREATE IF NOT EXISTS event_goals (
  id SERIAL PRIMARY KEY,
  event_id INT,
  goal_type VARCHAR(255),
  goal_value VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  removed_at DATETIME,
  FOREIGN KEY(event_id) REFERENCES event(id)
);

-- task tracker qr
-- acheivements badges and contributions
-- event share
