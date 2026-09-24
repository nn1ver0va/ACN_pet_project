SELECT 
station_id,
SUM(EXTRACT(EPOCH FROM (disconnect_time_ts - connection_time_ts))/3600)/2160 AS occupancy_rate,
COUNT (*) AS sessions_count
FROM sessions
GROUP BY station_id
ORDER BY occupancy_rate DESC;