CREATE TABLE csgo_frags (
  time datetime,
  event_id string,
  server_id string,
  attacker_name string,
  attacker_steamid string,
  attacker_team string,
  victim_name string,
  victim_steamid string,
  victim_team string,
  weapon string,
  headshot bool,
  penetrated bool,
  distance double,
  PRIMARY KEY (time, event_id)
);
