DROP TABLE IF EXISTS sessions;

CREATE TABLE sessions (
    connection_time TEXT,
    disconnect_time TEXT,
    done_charging_time TEXT,
    kwh_delivered NUMERIC,
    session_id TEXT,
    site_id TEXT,
    station_id TEXT,
    space_id TEXT,
    user_id TEXT
);
ALTER TABLE sessions
ADD COLUMN connection_time_ts TIMESTAMP,
ADD COLUMN done_charging_time_ts TIMESTAMP,
ADD COLUMN disconnect_time_ts TIMESTAMP;
UPDATE sessions
SET
    connection_time_ts = TO_TIMESTAMP(SUBSTRING(connection_time FROM 6), 'DD Mon YYYY HH24:MI:SS'),
    done_charging_time_ts = TO_TIMESTAMP(SUBSTRING(done_charging_time FROM 6), 'DD Mon YYYY HH24:MI:SS'),
    disconnect_time_ts = TO_TIMESTAMP(SUBSTRING(disconnect_time FROM 6), 'DD Mon YYYY HH24:MI:SS');