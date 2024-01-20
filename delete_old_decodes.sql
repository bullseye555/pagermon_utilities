attach '/home/pi/pagermon/server/messages.db' as m;

DELETE
FROM m.messages
WHERE julianday('now') - julianday(TIMESTAMP, 'unixepoch') > 30;
 
vacuum m;

.quit
