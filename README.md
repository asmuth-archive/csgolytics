CSGOLytics
==========

CSGOLytics imports the Valve SRCDS/CS:GO server logfile and writes all game events as structured data (JSON) into a backend database ([EventQL](https://eventql.io/)).

![Screenshot](https://raw.githubusercontent.com/paulasmuth/csgolytics/master/screenshot.png)

Usage
-----

CSGOLytics requires a running [EventQL](https://eventql.io/ database. You can start the CSGOLytics app with this command:

    $ ./csgolytics.rb \
          --listen_udp 0.0.0.0:3764 \
          --listen_http 0.0.0.0:8080 \
          --eventql_addr localhost:9175 \
          --eventql_database csgolytics

To use CSGOLytics, you have to enable UDP logging in your dedicated server. You can either execute these lines via rcon or put them into your `autoexec.cfg` file.

    > rcon logaddress_add x.x.x.x:3764
    > rcon log on
    > rcon mp_logdetail 3

You also have to add an entry for each gameserver in `config/config.yml`. **It is important to enter the correct remote address for each gameserver in the config.yml file, otherwise incoming data will not be accepted**


Game Events (JSON)
------------------

#### Kill Event

    {  
       "event":"kill",
       "time":"2016-12-18T11:51:19Z",
       "attacker_name":"le_fnord",
       "attacker_steamid":"STEAM_1:0:123456789",
       "attacker_team":"CT",
       "attacker_coords_x":-285,
       "attacker_coords_y":343,
       "attacker_coords_z":1,
       "victim_name":"Allen",
       "victim_steamid":"BOT",
       "victim_team":"T",
       "victim_coords_x":-282,
       "victim_coords_y":424,
       "victim_coords_z":125,
       "weapon":"ak47",
       "headshot":false,
       "penetrated":false,
       "server_id":"aim"
    }
