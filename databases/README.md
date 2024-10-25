# PostgreSQL
[postgres_tables.aml](./postgres_tables.aml)
## AML screenshot
Screenshot of postgres database diagram. `(temporary)` <br>
![AML screenshot](./2024-07-09_03-37.png)

## Queries
A list of queries used (generic) and their implementations

| User Event | Query |
| - | - |
| Sign-up | <pre>INSERT INTO users(email)<br>VALUES($1);</pre>
||<pre>INSERT INTO users_authentication_credentials(<br>  user_id,<br>  username,<br>  password,<br>  is_primary<br>)<br>VALUES(<br>  (SELECT id FROM users WHERE email = $1),<br>  CONCAT('EMAIL ', $2),<br>  $3, <br>  true<br>);INTO users_sessions</pre> |
| Create Session | <pre>INSERT INTO users_sessions (<br>  user_id,<br>  session_id,<br>)<br>VALUES (<br>  (SELECT id FROM users WHERE email = $1),<br>  $2<br>);</pre> |
| Extend Session Lifetime | <pre>UPDATE users_sessions<br>SET expires_idle_at = NOW() + INTERVAL '3 DAY'<br>WHERE session_id = $1;</pre> |
| Check Session Validity | <pre>SELECT session_id<br>FROM users_sessions<br>WHERE session_id = $1<br>AND expires_idle_at > NOW()<br>AND expires_active_at > NOW()<br>AND (suspended_at = NULL OR suspended_at > NOW());</pre> |
| Create Invitation on Sign-up | <pre>INSERT INTO users_invitations (<br>  user_id,<br>  uuid<br>)<br>VALUES ( <br>  (SELECT id FROM users WHERE email = $1),<br>  $2<br>);</pre> |
| Create Invitation | <pre>INSERT INTO users_invitations (<br>  user_id,<br>  invitation_type,<br>  uuid<br>)<br>VALUES ( <br>  (SELECT id FROM users WHERE email = $1),<br>  $2, $3<br>);</pre> |
| Use Invitation | <pre>UPDATE users_invitations<br>SET used_at = NOW()<br>WHERE uuid = $1<br>AND expires_at > NOW()<br>AND (suspended_at = NULL OR suspended_at > NOW());</pre> |
| Log Failed attempts | <pre>INSERT INTO users_failed_attempts (<br>  email,<br>  ip,<br>)<br>VALUES (<br>  $1, $2<br>);</pre> |
| Setup Profile  - Full | <pre>INSERT INTO users_profiles (<br>  user_id,<br>  phone_number,<br>  country,<br>  region,<br>  address,<br>  gender<br>) <br>VALUES (<br>  (SELECT user_id AS id FROM users_sessions WHERE session_id = $1),<br>  $2, $3, $4, $5, $6<br>);</pre> |
| Setup Profile - Partial | <pre>INSERT INTO users_profiles (<br>  user_id,<br>  {{column_name}}<br>) <br>VALUES (<br>  (SELECT user_id AS id FROM users_sessions WHERE session_id = $1),<br>  $2<br>);</pre> |
| Update Profile - Full | <pre>UPDATE users_profiles SET (<br>  phone_number,<br>  country,<br>  region,<br>  address,<br>  gender<br>) = (<br>  $1, $2, $3, $4, $5<br>)<br>WHERE user_id = (<br>  SELECT user_id AS id FROM users_sessions WHERE session_id = $6<br>);</pre> |
| Update Profile - Partial | <pre>UPDATE users_profiles <br>SET {{ column_name }} = $1<br>WHERE user_id = (<br>  SELECT user_id AS id FROM users_sessions WHERE session_id = $2<br>);</pre> |
| Upload Media | <pre>INSERT INTO users_media (<br>  user_id,<br>  file_name,<br>  file_type,<br>  flag<br>)<br>VALUES (<br>  (SELECT user_id AS id FROM users_sessions WHERE session_id = $1),<br>  $2, $3, $4<br>);</pre> |
| Delete Media | <pre>UPDATE users_media <br>SET flag = 'REMOVED'<br>WHERE file_name = $1<br>AND user_id = (SELECT user_id AS id FROM users_sessions WHERE session_id = $2);</pre> |
| Update Cover or Profile Picture | <pre>UPDATE users_media <br>SET flag = $1<br>WHERE file_name != $2<br>AND user_id = (SELECT user_id AS id FROM users_sessions WHERE session_id = $3);</pre> |
## Part I - Users
- Media flags:

| D2 | D1 | D0 | Flag Name                | Flag            |
|----|----|----|--------------------------|-----------------|
| 0  | 0  | 0  | No Tag                   | NONE            |
| 0  | 0  | 1  | Profile Picture          | PROFILE         |
| 0  | 1  | 0  | Cover Picture            | COVER           |
| 0  | 1  | 1  | N/A                      | N/A             |
| 1  | 0  | 0  | N/A                      | N/A             |
| 1  | 0  | 1  | Profile Picture (Current)| PROFILE_CURRENT |
| 1  | 1  | 0  | Cover Picture (Current)  | COVER_CURRENT   |
| 1  | 1  | 1  | Deleted                  | REMOVED         |


# MongoDB
- Messages
- Notifications
