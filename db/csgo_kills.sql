CREATE TABLE csgo_kills (
  time_key uint64,
  event_id string,
  server_id string,
  time datetime,
  attacker_name string,
  attacker_steamid string,
  attacker_team string,
  victim_name string,
  victim_steamid string,
  victim_team string,
  weapon string,
  headshoot bool,
  penetrated bool,
  PRIMARY KEY (time_key, event_id)
) WITH user_defined_partitions = "true";
