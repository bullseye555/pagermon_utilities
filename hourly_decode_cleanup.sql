attach '/home/pi/pagermon/server/messages.db' as m;

DELETE
FROM m.messages
WHERE substr(message, 1, 2) NOT IN (
		'@@'
		,'Hb'
		,'QD'
		,')&'
		);

DELETE
FROM m.messages
WHERE length(message) < 10;

.quit
