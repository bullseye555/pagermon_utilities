attach '/home/pi/pagermon/server/messages.db' as m;
attach '/home/pi/pagermon/server/messages_archive.db' as ma;

INSERT OR IGNORE INTO ma.messages
SELECT *
FROM m.messages
WHERE julianday('now') - julianday(TIMESTAMP, 'unixepoch') > 30;

DELETE
FROM m.messages
WHERE julianday('now') - julianday(TIMESTAMP, 'unixepoch') > 30;

DELETE
FROM ma.capcodes;

INSERT INTO ma.capcodes
SELECT *
FROM m.capcodes;

DELETE
FROM ma.messages
WHERE julianday('now') - julianday(TIMESTAMP, 'unixepoch') > 730;

vacuum ma;
 
vacuum m;

.quit
