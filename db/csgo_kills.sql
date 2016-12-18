CREATE TABLE csgo_kills (
  time_key uint64,
  event_id string,
  time datetime,
  PRIMARY KEY (time_key, event_id)
) WITH user_defined_partitions = "true";
