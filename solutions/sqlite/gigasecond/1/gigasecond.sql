UPDATE "gigasecond"
SET "result" = STRFTIME('%Y-%m-%dT%H:%M:%S', "moment", '+1000000000 seconds');