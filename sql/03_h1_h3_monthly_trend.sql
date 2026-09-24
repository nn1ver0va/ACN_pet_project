SELECT
	TO_CHAR (connection_time_ts, 'YYYY-MM') AS month,
	SUM(EXTRACT(EPOCH FROM(disconnect_time_ts-done_charging_time_ts))/3600)/SUM(EXTRACT(EPOCH FROM(disconnect_time_ts-connection_time_ts))/3600) AS idle_share,
	AVG(kwh_delivered) AS avg_kwh_per_session,
	COUNT(*) AS sessions_count
FROM sessions
GROUP BY month
ORDER BY month;