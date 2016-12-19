CSGOLytics
==========

CSGOLytics imports the Valve SRCDS/CS:GO (Counter Strike Global Offense) server logfile and writes all game events as structured data (JSON) into a backend database ([EventQL](https://eventql.io/)).

![Screenshot](https://raw.githubusercontent.com/paulasmuth/csgolytics/master/screenshot.png)

Installation
------------

The most simple way to install CSGOLytics is by using rubygems:

    $ gem install csgolytics
    
Usage
-----

CSGOLytics requires a running [EventQL](https://eventql.io/) database. To use CSGOLytics, you also have to enable detailed logging in your dedicated server. You can either execute these lines via rcon or put them into your `autoexec.cfg` file.

    > rcon log on
    > rcon mp_logdetail 3

#### Sending log data via logtail

The preferred way of importing the CS:GO logfiles is by using the included `csgolytics-import` tool. To start the import tool, execute this command:

    $ ./csgolytics-import \
          --logdir /path/to/csgo/server/csgo/logs \
          --eventql_host localhost \
          --eventql_port 9175 \
          --eventql_database csgolytics
    
#### Sending log data via UDP

Alternatively, you can use the built-in remote logging support to receive the log data via udp. However this is less reliable. To use UDP logging, start the import tool with this command.
    
    $ ./csgolytics-import \
          --listen_udp 0.0.0.0:3764 \
          --eventql_host localhost \
          --eventql_port 9175 \
          --eventql_database csgolytics
         

Then execute this line via rcon or put it into the `autoexec.cfg` file (replace x.x.x.x with the address on which csgolytics-import is listening for udp packets)

    > rcon logaddress_add x.x.x.x:3764
    


Game Events (JSON)
------------------

#### Frag Event (csgo_frags)

    {  
       "event":"frag",
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

#### Assist Event (csgo_assists)

    {  
       "event":"assist",
       "time":"2016-12-18T11:51:19Z",
       "attacker_name":"le_fnord",
       "attacker_steamid":"STEAM_1:0:123456789",
       "attacker_team":"CT",
       "victim_name":"Allen",
       "victim_steamid":"BOT",
       "victim_team":"T"
    }


License
-------

Copyright (c) 2016 Paul Asmuth

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
