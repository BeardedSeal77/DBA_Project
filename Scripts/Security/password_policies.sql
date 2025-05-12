-- Enforce Password Policies

-- Create a custom password profile named 'bookstore_profile'.
CREATE PROFILE bookstore_profile LIMIT
  FAILED_LOGIN_ATTEMPTS 5 -- Lock the account after 5 consecutive failed login attempts.
  PASSWORD_LIFE_TIME 90 -- Password must be changed every 90 days.
  PASSWORD_REUSE_TIME 180  -- Prevent the reuse of a password for 180 days after it's changed
  PASSWORD_LOCK_TIME 1 -- Automatically lock the account for 1 day after reaching the failed login limit
  PASSWORD_VERIFY_FUNCTION ora12c_verify_function; -- "ora12c_verify_function" enforces strong password rules (at least one uppercase, one digit, special char etc.)

-- Apply profile to users
ALTER USER user_viewer PROFILE bookstore_profile;
ALTER USER user_clerk PROFILE bookstore_profile;
ALTER USER user_manager PROFILE bookstore_profile;