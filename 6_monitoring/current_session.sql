SELECT username, status, osuser, machine, program
FROM v$session
WHERE username IS NOT NULL;
