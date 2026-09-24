WITH occupancy AS (
	SELECT
		station_id,
		SUM(EXTRACT(EPOCH FROM (disconnect_time_ts - connection_time_ts))/3600)/2160 AS occupancy_rate
		FROM sessions
		GROUP BY station_id	
	),
	step1 AS (
    SELECT
        station_id,
        connection_time_ts,
        LAG(disconnect_time_ts) OVER (PARTITION BY station_id ORDER BY connection_time_ts) AS prev_disconnect_time
    FROM sessions
),
step2 AS (
    SELECT
        station_id,
        connection_time_ts,
        prev_disconnect_time,
        EXTRACT(EPOCH FROM (connection_time_ts - prev_disconnect_time)) / 3600 AS gap_hours
    FROM step1
),
gaps AS (
	SELECT
    station_id,
    MAX(gap_hours) AS max_gap_hours,
	COUNT (*) AS sessions_count
FROM step2
GROUP BY station_id
HAVING COUNT(*) > 16
)
SELECT
	occupancy.station_id,
	occupancy.occupancy_rate,
	gaps.max_gap_hours,
	gaps.sessions_count
FROM occupancy
JOIN gaps ON occupancy.station_id = gaps.station_id
ORDER BY occupancy.occupancy_rate DESC;