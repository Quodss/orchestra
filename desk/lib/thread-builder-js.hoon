/-  spider
/-  channels-sur=channels
/-  groups-ver-sur=groups-ver
/-  chat-ver-sur=chat-ver
/+  sio=strandio
/+  wasm=wasm-lia
/+  mp=mop-extensions
/+  cj=channel-json
/+  sj=story-json
/*  quick-js-wasm  %wasm  /quick-js-emcc/wasm
::
=*  strand       strand:spider
=*  cw           coin-wasm:wasm-sur:wasm
=*  lv           lia-value:lia-sur:wasm
=*  script-form  script-raw-form:lia-sur:wasm
=*  strand-form  strand-form-raw:rand
=*  yield        script-yield:lia-sur:wasm
::  Types, interfaces
::
=>  |%
    ++  get-js-ctx
      |=  tor=vase
      ^-  [run-u=@ ctx-u=@ fil-u=@]
      =>  !<(acc tor)
      [run-u ctx-u fil-u]
    ::  actual accumulator type of a vase noun to be stored in lia accumulator
    ::
    +$  acc
      $:  run-u=@
          ctx-u=@
          fil-u=@
          :: state=json  XX  not necessary?
          bowl=(unit bowl:rand)
      ==
    ::
    +$  acc-mold  vase
    ++  arr  (arrows:wasm acc-mold)
    --
::
::  External call arrows
::
=>  =*  v-sur-channels   v9:channels-sur
    =*  flag             =>  v-sur-channels  flag
    =*  nest             =>  v-sur-channels  nest
    =*  channels         =>  v-sur-channels  channels
    =*  channel          =>  v-sur-channels  channel
    =*  post             =>  v-sur-channels  post
    =*  posts            =>  v-sur-channels  posts
    =*  memo             =>  v-sur-channels  memo
    =*  on-posts         =>  v-sur-channels  on-posts
    =*  reply-chan       =>  v-sur-channels  reply
    =*  replies-chan     =>  v-sur-channels  replies
    =*  on-replies-chan  =>  v-sur-channels  on-replies
    =*  story            =>  v-sur-channels  story
    =*  action-c         =>  v-sur-channels  a-channels
    =*  tomb-channels    =>  v-sur-channels  tombstone
    =*  mo-posts         ((mp time (each post tomb-channels)) lte)
    ::
    =*  v-sur-chat       v6:chat-ver-sur
    =*  dm               =>  v-sur-chat  dm
    =*  writ             =>  v-sur-chat  writ
    =*  writs            =>  v-sur-chat  writs
    =*  reply-dm         =>  v-sur-chat  reply
    =*  replies-dm       =>  v-sur-chat  replies
    =*  club             =>  v-sur-chat  club
    =*  id-club          =>  v-sur-chat  id:club
    =*  action-club      =>  v-sur-chat  action:club
    =*  action-dm        =>  v-sur-chat  action:dm
    =*  tomb-chat        =>  v-sur-chat  tombstone
    =*  mo-writs         ((mp time (each writ tomb-chat)) lte)
    ::
    =*  v-sur-groups     v7:groups-ver-sur
    =*  flag             =>  v-sur-groups  flag
    =*  seat             =>  v-sur-groups  seat
    =*  role-groups      =>  v-sur-groups  role-id
    =*  action-g         =>  v-sur-groups  a-groups
    ::
    |%
    ++  ease-discipline
      %-  slog
      :_  ~
      'This path is not covered with +discipline table in %groups \
      /(%vats bv0q9), so the agent yaps at a "mismatching mark", ignore it'
    ::
    ++  ext
      |%
      ++  restart  (call-ext:arr %restart ~)
      ::  Arvo API
      ::
      ++  get-bowl  (call-ext:arr %get-bowl ~)
      ::
      ++  get-txt-file
        |=  pax=path
        (call-ext:arr %get-txt-file vase+!>(pax) ~)
      ::
      ++  set-txt-file
        |=  [pax=path txt=cord]
        (call-ext:arr %set-txt-file vase+!>(pax) vase+!>(txt) ~)
      ::
      ++  fetch-url
        |=  =hiss:eyre
        (call-ext:arr %fetch-url vase+!>(hiss) ~)
      ::
      ++  sleep
        |=  for=@dr
        (call-ext:arr %sleep vase+!>(for) ~)
      ::
      ::  Tlon Messenger API
      ::
      ++  get-channels
        (call-ext:arr %get-channels ~)
      ::
      ++  get-chan-messages
        |=  [=nest:channels-sur n=@]
        (call-ext:arr %get-chan-messages vase+!>(nest) vase+!>(n) ~)
      ::  
      ++  get-dm-messages
        |=  [her=@p n=@]
        (call-ext:arr %get-dm-messages vase+!>(her) vase+!>(n) ~)
      ::
      ++  get-club-messages
        |=  [zem=id-club n=@]
        (call-ext:arr %get-club-messages vase+!>(zem) vase+!>(n) ~)
      ::
      ++  get-dm-replies
        |=  [her=@p key=time]
        (call-ext:arr %get-dm-replies vase+!>(her) vase+!>(key) ~)
      ::
      ++  get-club-replies
        |=  [zem=id-club key=time]
        (call-ext:arr %get-club-replies vase+!>(zem) vase+!>(key) ~)
      ::
      ++  get-chan-replies
        |=  [=nest:channels-sur key=time]
        (call-ext:arr %get-chan-replies vase+!>(nest) vase+!>(key) ~)
      ::
      ++  get-chan-members
        |=  =nest:channels-sur
        (call-ext:arr %get-chan-members vase+!>(nest) ~)
      ::
      ++  get-club-members
        |=  zem=id-club
        (call-ext:arr %get-club-members vase+!>(zem) ~)
      ::
      ++  get-roles
        |=  [=nest:channels-sur her=@p]
        (call-ext:arr %get-roles vase+!>(nest) vase+!>(her) ~)
      ::
      ++  add-user-chan
        |=  [=nest:channels-sur her=@p]
        (call-ext:arr %add-user-chan vase+!>(nest) vase+!>(her) ~)
      ::
      ++  add-user-club
        |=  [zem=id-club her=@p]
        (call-ext:arr %add-user-club vase+!>(zem) vase+!>(her) ~)
      ::
      ++  kick-user-chan
        |=  [=nest:channels-sur her=@p]
        (call-ext:arr %kick-user-chan vase+!>(nest) vase+!>(her) ~)
      ::
      ++  give-role
        |=  [=nest:channels-sur her=@p role=@tas]
        (call-ext:arr %give-role vase+!>(nest) vase+!>(her) vase+!>(role) ~)
      ::
      ++  remove-role
        |=  [=nest:channels-sur her=@p role=@tas]
        (call-ext:arr %remove-role vase+!>(nest) vase+!>(her) vase+!>(role) ~)
      ::
      ++  post-chan
        |=  [=nest:channels-sur post=story:channels-sur]
        (call-ext:arr %post-chan vase+!>(nest) vase+!>(post) ~)
      ::
      ++  send-dm
        |=  [her=@p post=story:channels-sur]
        (call-ext:arr %send-dm vase+!>(her) vase+!>(post) ~)
      ::
      ++  send-club
        |=  [zem=id-club post=story:channels-sur]
        (call-ext:arr %send-club vase+!>(zem) vase+!>(post) ~)
      ::
      ++  post-reply
        |=  [=nest:channels-sur key=time post=story:channels-sur]
        (call-ext:arr %post-reply vase+!>(nest) vase+!>(key) vase+!>(post) ~)
      ::
      ++  get-leeches
        (call-ext:arr %get-leeches ~)
      ::
      ++  get-targets
        |=  tag=(unit @ta)
        (call-ext:arr %get-targets vase+!>(tag) ~)
      --
    ::  +scry: scry thread with explicit path interpolation
    ::
    ++  scry
      |*  [=mold what=term whom=term pax=path]
      =/  m  (strand mold)
      ^-  form:m
      ;<  =bowl:spider  bind:m  get-bowl:sio
      %-  pure:m
      .^(mold what (scot %p our.bowl) whom (scot %da now.bowl) pax)
    ::  +tm: Tlon Messenger API threads. Stateful urwasm scripts cannot scry
    ::  due to persistent memoization, so we offload scrying to threads
    ::
    ++  tm
      |%
      ::  +get-channels: get a list of all available channels
      ::
      ++  get-channels  ::  XX nest is a unique identifier for a channel?
        =/  m  (strand (list nest))
        ^-  form:m
        ;<  =channels  bind:m
          (scry channels %gx %channels /v4/channels/channels-4)
        ::
        (pure:m ~(tap in ~(key by channels)))
      ::  +get-chan-messages: get a list of N last messages in a channel
      ::
      ++  get-chan-messages
        |=  [=nest n=@]
        =/  m  (strand (list (pair time memo)))
        ^-  form:m
        ;<  =channels  bind:m
          (scry channels %gx %channels /v4/channels/full/channels-4)
        ::
        ?~  channel=(~(get by channels) nest)  (pure:m ~)
        =/  =posts  posts.u.channel
        %-  pure:m
        %+  murn  (top:mo-posts posts n)
        |=  [t=time p=(each post *)]
        ^-  (unit [time memo])
        ?:  ?=(%| -.p)  ~
        `[t [content author sent]:p.p]
      ::  +get-dm-messages: get a list of N last DMs in a chat
      ::
      ++  get-dm-messages
        |=  [her=@p n=@]
        =/  m  (strand (list (pair time memo)))
        ^-  form:m
        ;<  [dms=(map ship dm) *]  bind:m
          (scry ,[(map ship dm) *] %gx %chat /full/noun)
        ::
        ?~  dm=(~(get by dms) her)  (pure:m ~)
        =/  writs  wit.pact.u.dm
        %-  pure:m
        %+  murn  (top:mo-writs writs n)
        |=  [t=time w=(each writ *)]
        ^-  (unit [time memo])
        ?-  -.w
          %&  `[t [content author sent]:p.w]
          %|  ~
        ==
      ::  +get-club-messages: get a list of N last DMs in a groupchat
      ::
      ++  get-club-messages
        |=  [zem=id-club n=@]
        =/  m  (strand (list (pair time memo)))
        ^-  form:m
        ;<  [* clubs=(map id-club club)]  bind:m
          (scry ,[* (map id-club club)] %gx %chat /full/noun)
        ::
        ?~  club=(~(get by clubs) zem)  (pure:m ~)
        =/  writs  wit.pact.u.club
        =/  l=(list [time (each writ *)])  (top:mo-writs writs n)
        %-  pure:m
        %+  murn  l
        |=  [t=time w=(each writ *)]
        ^-  (unit [time memo])
        ?-  -.w
          %&  `[t [content author sent]:p.w]
          %|  ~
        ==
      ::  +get-dm-replies: get thread replies to a DM
      ::
      ++  get-dm-replies
        |=  [her=@p key=time]
        =/  m  (strand (list memo))
        ^-  form:m
        ;<  [dms=(map ship dm) *]  bind:m
          (scry ,[(map ship dm) *] %gx %chat /full/noun)
        ::
        ?~  dm=(~(get by dms) her)  (pure:m ~)
        =/  wits  wit.pact.u.dm
        ?~  writ=(get:on:writs wits key)  (pure:m ~)
        ?:  ?=(%| -.u.writ)  (pure:m ~)
        =/  reps=replies-dm  replies.u.writ
        %-  pure:m
        %+  murn  (tap:on:replies-dm reps)
        |=  [time r=(each reply-dm *)]
        ^-  (unit memo)
        ?:  ?=(%| -.r)  ~
        `[content author sent]:p.r
      ::  +get-club-replies: get thread replies to a groupchat DM
      ::
      ++  get-club-replies
        |=  [zem=id-club key=time]
        =/  m  (strand (list memo))
        ^-  form:m
        ;<  [* clubs=(map id-club club)]  bind:m
          (scry ,[* (map id-club club)] %gx %chat /full/noun)
        ::
        ?~  club=(~(get by clubs) zem)  (pure:m ~)
        =/  wits  wit.pact.u.club
        ?~  writ=(get:on:writs wits key)  (pure:m ~)
        ?:  ?=(%| -.u.writ)  (pure:m ~)
        =/  reps=replies-dm  replies.u.writ
        %-  pure:m
        %+  murn  (tap:on:replies-dm reps)
        |=  [time r=(each reply-dm *)]
        ^-  (unit memo)
        ?:  ?=(%| -.r)  ~
        `[content author sent]:p.r
      ::  +get-chan-replies: get thread replies to a channel post
      ::
      ++  get-chan-replies
        |=  [=nest key=time]
        =/  m  (strand (list memo))
        ^-  form:m
        ;<  =channels  bind:m
          (scry channels %gx %channels /v4/channels/full/channels-4)
        ::
        ?~  channel=(~(get by channels) nest)  (pure:m ~)
        =/  =posts  posts.u.channel
        ?~  pot=(get:on-posts posts key)  (pure:m ~)
        ?:  ?=(%| -.u.pot)  (pure:m ~)
        =/  reps=replies-chan  replies.u.pot
        %-  pure:m
        %+  murn  (tap:on-replies-chan reps)
        |=  [time r=(each reply-chan *)]
        ^-  (unit memo)
        ?:  ?=(%| -.r)  ~
        `[content author sent]:p.r
      ::  +get-chan-members: get members of a group where the channel is located
      ::
      ++  get-chan-members
        |=  =nest
        =/  m  (strand (set ship))
        ^-  form:m
        ;<  =channels  bind:m
          (scry channels %gx %channels /v4/channels/channels-4)
        ::
        ?~  channel=(~(get by channels) nest)  (pure:m ~)
        =/  group=flag  group.perm.u.channel
        %-  ease-discipline
        %:  scry  (set ship)  %gx  %groups
          /v2/groups/(scot %p p.group)/[q.group]/seats/ships/noun
        ==
      ::  +get-club-members: get members of a groupchat
      ::
      ++  get-club-members
        |=  zem=id-club
        =/  m  (strand (set ship))
        ^-  form:m
        ;<  [* clubs=(map id-club club)]  bind:m
          (scry ,[* (map id-club club)] %gx %chat /full/noun)
        ::
        ?~  club=(~(get by clubs) zem)  (pure:m ~)
        (pure:m team.crew.u.club)
      ::  +get-roles: get roles of a ship in the group of a given channel
      ::
      ++  get-roles
        |=  [=nest her=@p]
        =/  m  (strand (set role-groups))
        ^-  form:m
        ;<  =channels  bind:m
          (scry channels %gx %channels /v4/channels/channels-4)
        ::
        ?~  channel=(~(get by channels) nest)  (pure:m ~)
        =/  group=flag  group.perm.u.channel
        %-  ease-discipline
        ;<  vessel=(unit seat)  bind:m
          %:  scry  (unit seat)  %gx  %groups
            /v2/groups/(scot %p p.group)/[q.group]/seats/(scot %p her)/noun
          ==
        ::
        ?~  vessel  (pure:m ~)
        (pure:m roles.u.vessel)
      ::  pokes
      ::
      ::  +add-user-chan: invite a user to the group of a channel
      ::
      ++  add-user-chan
        |=  [=nest her=@p]
        =/  m  (strand ,~)
        ^-  form:m
        ;<  =channels  bind:m
          (scry channels %gx %channels /v4/channels/channels-4)
        ::
        ?~  channel=(~(get by channels) nest)  (pure:m ~)
        =/  group=flag  group.perm.u.channel
        ;<  members=(set ship)  bind:m
          %-  ease-discipline
          %:  scry  (set ship)  %gx  %groups
            /v2/groups/(scot %p p.group)/[q.group]/seats/ships/ships
          ==
        ::
        ?:  (~(has in members) her)  (pure:m ~)
        ;<  bol=bowl:rand  bind:m  get-bowl:sio
        =/  act=action-g  [%group group seat+[[her ~ ~] add+~]]
        (poke:sio [our.bol %groups] group-action-4+!>(act))
      ::  +add-user-club: invite a user to a groupchat
      ::
      ++  add-user-club
        |=  [zem=id-club her=@p]
        =/  m  (strand ,~)
        ^-  form:m
        ;<  [* clubs=(map id-club club)]  bind:m
          (scry ,[* (map id-club club)] %gx %chat /full/noun)
        ::
        ?~  club=(~(get by clubs) zem)  (pure:m ~)
        =/  herd=(set @uv)  heard.u.club
        ;<  bol=bowl:rand  bind:m  get-bowl:sio
        =/  unique=@uv
          ::  ++  cu-uid generates SHA-256 hash, we produce the same length
          ::
          =/  eny=@uv  (cut 8 [0 1] eny.bol)
          |-  ^-  @uv
          ?.  (~(has in herd) eny)  eny
          $(eny +(eny))
        ::
        =/  act=action-club  [zem unique %hive our.bol her &]
        (poke:sio [our.bol %chat] chat-club-action-1+!>(act))
      ::  +kick-user-chan: kick a user from the group of a chat
      ::
      ++  kick-user-chan
        |=  [=nest her=@p]
        =/  m  (strand ,~)
        ^-  form:m
        ;<  =channels  bind:m
          (scry channels %gx %channels /v4/channels/channels-4)
        ::
        ?~  channel=(~(get by channels) nest)  (pure:m ~)
        =/  group=flag  group.perm.u.channel
        ;<  members=(set ship)  bind:m
          %-  ease-discipline
          %:  scry  (set ship)  %gx  %groups
            /v2/groups/(scot %p p.group)/[q.group]/seats/ships/ships
          ==
        ::
        ?.  (~(has in members) her)  (pure:m ~)
        ;<  bol=bowl:rand  bind:m  get-bowl:sio
        =/  act=action-g  [%group group seat+[[her ~ ~] del+~]]
        (poke:sio [our.bol %groups] group-action-4+!>(act))
      ::  +give-role: assign a role to a user in the group of a chat
      ::
      ++  give-role
        |=  [=nest her=@p role=@tas]
        =/  m  (strand ,~)
        ^-  form:m
        ;<  =channels  bind:m
          (scry channels %gx %channels /v4/channels/channels-4)
        ::
        ?~  channel=(~(get by channels) nest)  (pure:m ~)
        =/  group=flag  group.perm.u.channel
        ;<  members=(set ship)  bind:m
          %-  ease-discipline
          %:  scry  (set ship)  %gx  %groups
            /v2/groups/(scot %p p.group)/[q.group]/seats/ships/ships
          ==
        ::
        ?.  (~(has in members) her)  (pure:m ~)
        ;<  bol=bowl:rand  bind:m  get-bowl:sio
        =/  act=action-g  [%group group seat+[[her ~ ~] add-roles+[role ~ ~]]]
        (poke:sio [our.bol %groups] group-action-4+!>(act))
      ::  +give-role: strip a role from a user in the group of a chat
      ::
      ++  remove-role
        |=  [=nest her=@p role=@tas]
        =/  m  (strand ,~)
        ^-  form:m
        ;<  =channels  bind:m
          (scry channels %gx %channels /v4/channels/channels-4)
        ::
        ?~  channel=(~(get by channels) nest)  (pure:m ~)
        =/  group=flag  group.perm.u.channel
        ;<  members=(set ship)  bind:m
          %-  ease-discipline
          %:  scry  (set ship)  %gx  %groups
            /v2/groups/(scot %p p.group)/[q.group]/seats/ships/ships
          ==
        ::
        ?.  (~(has in members) her)  (pure:m ~)
        ;<  bol=bowl:rand  bind:m  get-bowl:sio
        =/  act=action-g  [%group group seat+[[her ~ ~] del-roles+[role ~ ~]]]
        (poke:sio [our.bol %groups] group-action-4+!>(act))
      ::  +post-chan: post in a channel
      ::
      ++  post-chan
        |=  [=nest post=story]
        =/  m  (strand ,~)
        ^-  form:m
        ;<  =channels  bind:m
          (scry channels %gx %channels /v4/channels/channels-4)
        ::
        ?~  channel=(~(get by channels) nest)  (pure:m ~)
        ;<  bol=bowl:rand  bind:m  get-bowl:sio
        =/  act=action-c
          [%channel nest %post %add [post [our now]:bol] /chat ~ ~]
        (poke:sio [our.bol %channels] channel-action-1+!>(act))
      ::  +send-dm: send DM duh
      ::
      ++  send-dm
        |=  [her=@p post=story]
        =/  m  (strand ,~)
        ^-  form:m
        ;<  bol=bowl:rand  bind:m  get-bowl:sio
        =/  act=action-dm
          [her [[our now]:bol %add [[post [our now]:bol] chat+/ ~ ~] `now.bol]]
        ::
        (poke:sio [our.bol %chat] chat-dm-action-1+!>(act))
      ::  +send-club: send groupchat DM
      ::
      ++  send-club
        |=  [zem=id-club post=story]
        =/  m  (strand ,~)
        ^-  form:m
        ;<  [* clubs=(map id-club club)]  bind:m
          (scry ,[* (map id-club club)] %gx %chat /full/noun)
        ::
        ?~  club=(~(get by clubs) zem)  (pure:m ~)
        =/  herd=(set @uv)  heard.u.club
        ;<  bol=bowl:rand  bind:m  get-bowl:sio
        =/  unique=@uv
          ::  ++  cu-uid generates SHA-256 hash, we produce the same length
          ::
          =/  eny=@uv  (cut 8 [0 1] eny.bol)
          |-  ^-  @uv
          ?.  (~(has in herd) eny)  eny
          $(eny +(eny))
        ::
        =/  act=action-club
          :*  zem
              unique
              %writ
              [our now]:bol
              %add
              [[post [our now]:bol] chat+/ ~ ~]
              `now.bol
          ==
        ::
        (poke:sio [our.bol %chat] chat-club-action-1+!>(act))
      ::  +post-reply: reply to a post in a channel
      ::
      ++  post-reply
        |=  [=nest key=time post=story]
        =/  m  (strand ,~)
        ^-  form:m
        ;<  =channels  bind:m
          (scry channels %gx %channels /v4/channels/channels-4)
        ::
        ?~  channel=(~(get by channels) nest)  (pure:m ~)
        ;<  bol=bowl:rand  bind:m  get-bowl:sio
        =/  act=action-c
          [%channel nest %post %reply key %add post [our now]:bol]
        ::
        (poke:sio [our.bol %channels] channel-action-1+!>(act))
      --
    ::  +fetch-thread: get a Spider thread by name from +call-ext:arr
    ::
    ++  fetch-thread
      =/  m  (strand (list lv))
      |=  name=term
      ^-  $-((list lv) (strand-form (list lv)))
      ?+    name  ~|(thread-not-defined+name !!)
          %get-bowl
        ::  (~ => [vase+bowl:rand ~])
        ::  does not need the argument
        ::
        |=  *
        ^-  form:m
        ;<  bol=bowl:rand  bind:m  get-bowl:sio
        (pure:m vase+!>(bol) ~)
      ::
          %get-txt-file
        ::  ([vase+path ~] => ?(~ [octs+contents=octs ~]))
        ::
        |=  l=(pole lv)
        ^-  form:m
        =*  prefix  %scripts
        ?>  ?=([[%vase p=*] ~] l)
        =+  !<(pax=path p.l)
        ;<  bol=bowl:rand  bind:m  get-bowl:sio
        =/  bek=beak  [our %base %da now]:bol
        ;<  =riot:clay  bind:m
          (warp:sio p.bek q.bek ~ %sing %x r.bek [prefix pax])
        ::
        ?~  riot  (pure:m ~)
        ?.  =(%txt p.r.u.riot)
          ~&  >>>  [%not-a-txt pax]
          (pure:m ~)
        ?~  wan=(mole |.(!<(wain q.r.u.riot)))
          ~&  >>>  [%weird-txt pax]
          (pure:m ~)
        =/  str=cord  (of-wain:format u.wan)
        (pure:m octs+[(met 3 str) str] ~)
      ::
          %set-txt-file
        ::  ([vase+path vase+cord ~] => ~)
        ::
        |=  l=(pole lv)
        ^-  form:m
        =*  prefix  %scripts
        ?>  ?=([[%vase p=*] [%vase t=*] ~] l)
        =+  [!<(pax=path p.l) !<(txt=cord t.l)]
        =/  wan=wain  (to-wain:format txt)
        =/  not=note-arvo  [%c [%info %base %& [prefix^pax %ins %txt !>(wan)]~]]
        (send-raw-card:sio [%pass / %arvo not])
      ::
          %fetch-url
        ::  ([vase+hiss ~] => ?(~ [vase+httr ~]))
        ::
        |=  l=(pole lv)
        ^-  form:m
        ?>  ?=([[%vase p=*] ~] l)
        =+  !<(=hiss:eyre p.l)
        ;<  sig=(unit httr:eyre)  bind:m  (hiss-request:sio hiss)
        ?~  sig  (pure:m ~)
        (pure:m vase+!>(u.sig) ~)
      ::
          %sleep
        ::  ([vase+@dr ~] => ~
        ::
        |=  l=(pole lv)
        ^-  form:m
        ?>  ?=([[%vase p=*] ~] l)
        =+  !<(for=@dr p.l)
        (sleep:sio for)
      ::
          %get-channels
        ::  ~ => [vase+(list nest) ~]
        ::
        |=  *
        ^-  form:m
        ;<  l=(list nest)  bind:m  get-channels:tm
        (pure:m vase+!>(l) ~)
      ::
          %get-chan-messages
        ::  [vase+nest vase+@ ~] => [vase+(list [time memo]) ~]
        ::
        |=  l=(pole lv)
        ^-  form:m
        ?>  ?=([[%vase p=*] [%vase q=*] ~] l)
        =+  [!<(=nest p.l) !<(n=@ q.l)]
        ;<  l=(list [time memo])  bind:m
          (get-chan-messages:tm nest n)
        ::
        (pure:m vase+!>(l) ~)
      ::
          %get-dm-messages
        ::  [vase+@p vase+@ ~] => [vase+(list [time memo]) ~]
        ::
        |=  l=(pole lv)
        ^-  form:m
        ?>  ?=([[%vase p=*] [%vase q=*] ~] l)
        =+  [!<(her=@p p.l) !<(n=@ q.l)]
        ;<  l=(list [time memo])  bind:m
          (get-dm-messages:tm her n)
        ::
        (pure:m vase+!>(l) ~)
      ::
          %get-club-messages
        ::  [vase+id vase+@ ~] => [vase+(list [time memo]) ~]
        ::
        |=  l=(pole lv)
        ^-  form:m
        ?>  ?=([[%vase p=*] [%vase q=*] ~] l)
        =+  [!<(zem=id-club p.l) !<(n=@ q.l)]
        ;<  l=(list [time memo])  bind:m
          (get-club-messages:tm zem n)
        ::
        (pure:m vase+!>(l) ~)
      ::
          %get-dm-replies
        ::  [vase+@p vase+time ~] => [vase+(list memo) ~]
        ::
        |=  l=(pole lv)
        ^-  form:m
        ?>  ?=([[%vase p=*] [%vase q=*] ~] l)
        =+  [!<(her=@p p.l) !<(key=time q.l)]
        ;<  l=(list memo)  bind:m  (get-dm-replies:tm her key)
        (pure:m vase+!>(l) ~)
      ::
          %get-club-replies
        ::  [vase+id-club vase+time ~] => [vase+(list memo) ~]
        ::
        |=  l=(pole lv)
        ^-  form:m
        ?>  ?=([[%vase p=*] [%vase q=*] ~] l)
        =+  [!<(zem=id-club p.l) !<(key=time q.l)]
        ;<  l=(list memo)  bind:m  (get-club-replies:tm zem key)
        (pure:m vase+!>(l) ~)
      ::
          %get-chan-replies
        ::  [vase+nest vase+time ~] => [vase+(list memo) ~]
        ::
        |=  l=(pole lv)
        ^-  form:m
        ?>  ?=([[%vase p=*] [%vase q=*] ~] l)
        =+  [!<(=nest p.l) !<(key=time q.l)]
        ;<  l=(list memo)  bind:m  (get-chan-replies:tm nest key)
        (pure:m vase+!>(l) ~)
      ::
          %get-chan-members
        ::  [vase+nest ~] => [vase+(set ship) ~]
        ::
        |=  l=(pole lv)
        ^-  form:m
        ?>  ?=([[%vase p=*] ~] l)
        =+  !<(=nest p.l)
        ;<  s=(set ship)  bind:m  (get-chan-members:tm nest)
        (pure:m vase+!>(s) ~)
      ::
          %get-club-members
        ::  [vase+id-club ~] => [vase+(set ship) ~]
        |=  l=(pole lv)
        ^-  form:m
        ?>  ?=([[%vase p=*] ~] l)
        =+  !<(zem=id-club p.l)
        ;<  s=(set ship)  bind:m  (get-club-members:tm zem)
        (pure:m vase+!>(s) ~)
      ::
          %get-roles
        ::  [vase+nest vase+@p ~] => [vase+(set @tas) ~]
        ::
        |=  l=(pole lv)
        ^-  form:m
        ?>  ?=([[%vase p=*] [%vase q=*] ~] l)
        =+  [!<(=nest p.l) !<(her=@p q.l)]
        ;<  s=(set @tas)  bind:m  (get-roles:tm nest her)
        (pure:m vase+!>(s) ~)
      ::
          %add-user-chan
        ::  [vase+nest vase+ship ~] => ~
        ::
        |=  l=(pole lv)
        ^-  form:m
        ?>  ?=([[%vase p=*] [%vase q=*] ~] l)
        =+  [!<(=nest p.l) !<(her=@p q.l)]
        (add-user-chan:tm nest her)
      ::
          %add-user-club
        ::  [vase+id-club vase+ship ~] => ~
        ::
        |=  l=(pole lv)
        ^-  form:m
        ?>  ?=([[%vase p=*] [%vase q=*] ~] l)
        =+  [!<(zem=id-club p.l) !<(her=@p q.l)]
        (add-user-club:tm zem her)
      ::
          %kick-user-chan
        ::  [vase+nest vase+ship ~] => ~
        ::
        |=  l=(pole lv)
        ^-  form:m
        ?>  ?=([[%vase p=*] [%vase q=*] ~] l)
        =+  [!<(=nest p.l) !<(her=@p q.l)]
        (kick-user-chan:tm nest her)
      ::
          %give-role
        ::  [vase+nest vase+ship vase+term ~] => ~
        ::
        |=  l=(pole lv)
        ^-  form:m
        ?>  ?=([[%vase p=*] [%vase q=*] [%vase r=*] ~] l)
        =+  [!<(=nest p.l) !<(her=@p q.l) !<(role=term r.l)]
        (give-role:tm nest her role)
      ::
          %remove-role
        ::  [vase+nest vase+ship vase+term ~] => ~
        ::
        |=  l=(pole lv)
        ^-  form:m
        ?>  ?=([[%vase p=*] [%vase q=*] [%vase r=*] ~] l)
        =+  [!<(=nest p.l) !<(her=@p q.l) !<(role=term r.l)]
        (remove-role:tm nest her role)
      ::
          %post-chan
        ::  [vase+nest vase+story ~] => ~
        ::
        |=  l=(pole lv)
        ^-  form:m
        ?>  ?=([[%vase p=*] [%vase q=*] ~] l)
        =+  [!<(=nest p.l) !<(post=story q.l)]
        (post-chan:tm nest post)
      ::
          %send-dm
        ::  [vase+ship vase+story ~] => ~
        ::
        |=  l=(pole lv)
        ^-  form:m
        ?>  ?=([[%vase p=*] [%vase q=*] ~] l)
        =+  [!<(her=@p p.l) !<(post=story q.l)]
        (send-dm:tm her post)
      ::
          %send-club
        ::  [vase+id-club vase+story ~] => ~
        ::
        |=  l=(pole lv)
        ^-  form:m
        ?>  ?=([[%vase p=*] [%vase q=*] ~] l)
        =+  [!<(zem=id-club p.l) !<(post=story q.l)]
        (send-club:tm zem post)
      ::
          %post-reply
        ::  [vase+nest vase+key vase+story ~] => ~
        ::
        |=  l=(pole lv)
        ^-  form:m
        ?>  ?=([[%vase p=*] [%vase q=*] [%vase r=*] ~] l)
        =+  :+  !<(=nest p.l)
              !<(key=time q.l)
            !<(post=story r.l)
        ::
        (post-reply:tm nest key post)
      ::
          %get-leeches
        ::  ~ => [vase+(set ship) ~]
        ::
        |=  *
        ^-  form:m
        ;<  pals-exist=?  bind:m  (scry ? %gu %pals /$)
        ?.  pals-exist
          ~>  %slog.[2 '%pals missing, "|install ~paldev %pals"']
          (pure:m vase+!>(~) ~)
        ;<  s=(set @p)    bind:m  (scry (set @p) %gx %pals /leeches/noun)
        (pure:m vase+!>(s) ~)
      ::
          %get-targets
        ::  [vase+(unit knot) ~] => [vase+(set ship) ~]
        ::
        |=  l=(pole lv)
        ^-  form:m
        ;<  pals-exist=?  bind:m  (scry ? %gu %pals /$)
        ?.  pals-exist
          ~>  %slog.[2 '%pals missing, "|install ~paldev %pals"']
          ::
          (pure:m vase+!>(~) ~)
        ?>  ?=([[%vase p=*] ~] l)
        =+  !<(tag=(unit @ta) p.l)
        ;<  s=(set @p)  bind:m
          ?~  tag  (scry (set @p) %gx %pals /targets/noun)
          (scry (set @p) %gx %pals /targets/[u.tag]/noun)
        ::
        (pure:m vase+!>(s) ~)
      ==
    --
::
::  Thread builder helping functions
::
=>  |%
    ::  +malloc-write: allocate and immediately write `p` bytes of `q` atom
    ::
    ++  malloc-write
      |=  data=octs
      =/  m  (script:lia-sur:wasm @ acc-mold)
      ^-  form:m
      =,  arr
      ;<  ptr-u=@  try:m  (call-1 'malloc' p.data ~)
      ;<  ~        try:m  (memwrite ptr-u data)
      (return:m ptr-u)
    ::  +malloc-cord: allocate and write a null-terminated cord
    ::
    ++  malloc-cord
      |=  str=cord
      =/  m  (script:lia-sur:wasm @ acc-mold)
      ^-  form:m
      (malloc-write +((met 3 str)) str)
    ::  +ring: complex call, with other calls inlined
    ::
    ++  ring
      |=  [func=cord args=(list $@(@ (script-form @ acc-mold)))]
      =/  m  (script:lia-sur:wasm (list @) acc-mold)
      ^-  form:m
      =,  arr
      =|  args-atoms=(list @)
      |-  ^-  form:m
      ?~  args  (call func (flop args-atoms))
      ?@  i.args  $(args t.args, args-atoms [i.args args-atoms])
      ;<  atom=@  try:m  i.args
      $(args t.args, args-atoms [atom args-atoms])
    ::  +ding: complex call-1
    ::
    ++  ding
      |=  [func=cord args=(list $@(@ (script-form @ acc-mold)))]
      =/  m  (script:lia-sur:wasm @ acc-mold)
      ;<  out=(list @)  try:m  (ring func args)
      ?>  =(~ |1.out)
      (return:m -.out)
    ::  +js-eval: run JS code
    ::
    ++  js-eval
      |=  code=cord
      =/  m  (script:lia-sur:wasm @ acc-mold)
      ^-  form:m
      =,  arr
      ;<  acc=acc-mold  try:m  get-acc
      ::  [run-u=@ ctx-u=@ fil-u=@]
      ::
      =+  (get-js-ctx acc)
      ::
      =/  code-len  (met 3 code)
      ;<  code-u=@  try:m  (malloc-write +(code-len) code)
      ;<  res-u=@   try:m  (call-1 'QTS_Eval' ctx-u code-u code-len fil-u 0 0 ~)
      ;<  *         try:m  (call 'free' code-u ~)
      (return:m res-u)
    ::  +mayb-error: check is JSValue* is an exception
    ::
    ++  mayb-error
      |=  res-u=@
      =/  m  (script:lia-sur:wasm (unit cord) acc-mold)
      ^-  form:m
      =,  arr
      ;<  acc=acc-mold  try:m  get-acc
      =+  (get-js-ctx acc)
      ::
      ;<  err-u=@   try:m  (call-1 'QTS_ResolveException' ctx-u res-u ~)
      ?:  =(0 err-u)  (return:m ~)
      ;<  str-u=@   try:m  (call-1 'QTS_GetString' ctx-u err-u ~)
      ;<  str=cord  try:m  (get-c-string str-u)
      (return:m `str)
    ::  +get-c-string: load a null-terminated string
    ::
    ++  get-c-string
      |=  ptr=@
      =/  m  (script:lia-sur:wasm cord acc-mold)
      ^-  form:m
      =,  arr
      =/  len=@  0
      =/  cursor=@  ptr
      |-  ^-  form:m
      ;<  char=octs  try:m  (memread cursor 1)
      ?.  =(0 q.char)
        $(len +(len), cursor +(cursor))
      ;<  =octs  try:m  (memread ptr len)
      (return:m q.octs)
    ::  +get-js-string: load a JSValue-represented string
    ::
    ++  get-js-string
      |=  val-u=@
      =/  m  (script:lia-sur:wasm cord acc-mold)
      ^-  form:m
      =,  arr
      ;<  acc=acc-mold  try:m  get-acc
      =+  (get-js-ctx acc)
      ::
      ;<  str-u=@  try:m  (call-1 'QTS_GetString' ctx-u val-u ~)
      (get-c-string str-u)
    ::  +tem: cord to octs
    ::
    ++  tem
      |=  c=cord
      ^-  octs
      [(met 3 c) c]
    ::  +ret: render result type to (list lv)
    ::
    ++  ret
      =/  m  runnable:wasm
      |=  out=(each cord (pair cord cord))
      ^-  form:m
      %-  return:m
      ?-  -.out
        %&  ~[i32+& octs+(tem p.out)]
        %|  ~[i32+| octs+(tem p.p.out) octs+(tem q.p.out)]
      ==
    ::  +register-function: associate a function name with a magic number.
    ::  The magic number must be recognized by +qts-host-call-function.
    ::
    ++  register-function
      |=  [name=cord mag-w=@ obj-u=@]
      ::  return: (unit error=cord)
      ::
      =/  m  (script:lia-sur:wasm (unit cord) acc-mold)
      ^-  form:m
      =,  arr
      ;<  acc=acc-mold  try:m  get-acc
      =+  (get-js-ctx acc)
      ;<  nam-u=@  try:m  (malloc-cord name)
      ;<  res-u=@  try:m  (call-1 'QTS_NewFunction' ctx-u mag-w nam-u ~)
      ::
      ;<  err=(unit cord)  try:m  (mayb-error res-u)
      ?^  err  (return:m err)
      ::
      ;<  nam-val-u=@  try:m  (call-1 'QTS_NewString' ctx-u nam-u ~)  ::  free string value?
      ;<  undef-u=@    try:m  (call-1 'QTS_GetUndefined' ~)
      ;<  *            try:m
        %:  call  'QTS_DefineProp'
          ctx-u
          obj-u
          nam-val-u
          res-u
          undef-u  ::  get
          undef-u  ::  set
          0        ::  configurable
          1        ::  enumerable
          1        ::  has_value
          ~
        ==
      ::
      (return:m ~)
    ::  +main: JS code -> main script to run
    ::
    ++  main
      |=  code=cord
      =/  m  runnable:wasm
      ^-  form:m
      =,  arr
      =/  filename=cord  'script-eval.js'
      ;<  run-u=@    try:m  (call-1 'QTS_NewRuntime' ~)
      ;<  ctx-u=@    try:m  (call-1 'QTS_NewContext' run-u 0 ~)
      ;<  fil-u=@    try:m  (malloc-cord filename)
      =|  tor=acc
      =.  tor  tor(run-u run-u, ctx-u ctx-u, fil-u fil-u)
      ;<  ~          try:m  (set-acc !>(tor))
      ;<  global-this-u=@  try:m  (call-1 'QTS_GetGlobalObject' ctx-u ~)
      ;<  undef-u=@        try:m  (call-1 'QTS_GetUndefined' ~)
      ;<  err=(unit cord)  try:m  (register-function 'require' 0 global-this-u)
      ?^  err  (ret |+[u.err 'make require'])
      ::  define `module` object
      ::
      ;<  *  try:m
        %:  ring  'QTS_DefineProp'
          ctx-u
          global-this-u
        ::
          %:  ding  'QTS_NewString'                       ::  property name
            ctx-u
            (malloc-cord 'module')
            ~
          ==
        ::
          (call-1 'QTS_NewObject' ctx-u ~)                ::  init value
          undef-u                                         ::  getter
          undef-u                                         ::  setter
          1                                               ::  configurable
          1                                               ::  enumerable
          1                                               ::  has value
          ~
        ==
      ::  define `console` object
      ::
      ;<  console-str-u=@  try:m
        %:  ding  'QTS_NewString'
          ctx-u
          (malloc-cord 'console')
          ~
        ==
      ::
      ;<  *  try:m
        %:  ring  'QTS_DefineProp'
          ctx-u
          global-this-u
          console-str-u
          (call-1 'QTS_NewObject' ctx-u ~)                ::  init value
          undef-u                                         ::  getter
          undef-u                                         ::  setter
          1                                               ::  configurable
          1                                               ::  enumerable
          1                                               ::  has value
          ~
        ==
      ::
      ;<  console-u=@  try:m
        (call-1 'QTS_GetProp' ctx-u global-this-u console-str-u ~)
      ::
      ;<  *  try:m  (register-function 'log' 1 console-u)
      ;<  *  try:m  (register-function 'error' 2 console-u)
      ;<  *  try:m  (register-function 'warn' 3 console-u)
      ;<  *  try:m  (register-function 'info' 4 console-u)
      ::
      ::  define fetch
      ::
      ;<  *  try:m  (register-function 'fetch_sync' 7 global-this-u)
      ;<  fun-u=@  try:m
        %-  js-eval
        '''
        var _fetch = function(url, options = { method: "GET" }) {
          return new Promise((resolve, reject) => {
            const res = globalThis.fetch_sync(url, options);
            resolve(res);
          });
        };
        _fetch
        '''
      ::
      ;<  *  try:m
        %:  ring  'QTS_DefineProp'
          ctx-u
          global-this-u
          (ding 'QTS_NewString' ctx-u (malloc-cord 'fetch') ~)
          fun-u
          undef-u  ::  get
          undef-u  ::  set
          0        ::  configurable
          1        ::  enumerable
          1        ::  has_value
          ~
        ==
      ::
      ::
      :: imports the interface library via require, exports a function to module.exports
      ::
      ;<  res-u=@          try:m  (js-eval code)
      ;<  err=(unit cord)  try:m  (mayb-error res-u)
      ?^  err  (ret |+[u.err 'failed to export the script function'])
      ;<  res-u=@          try:m
        %-  js-eval
        '''
        globalThis.__result = undefined;
        Promise.resolve(module.exports()).then(result => {
          globalThis.__result = result;
        });
        '''
      ::
      ;<  dump-u=@  try:m  (call-1 'malloc' 4 ~)  ::  XX use scratch arena for things like that
      ;<  *         try:m
        (call 'QTS_ExecutePendingJob' run-u ^~((sub (bex 32) 1)) dump-u ~)
      ::
      ;<  err=(unit cord)  try:m  (mayb-error res-u)
      ?^  err  (ret |+[u.err 'failed to call the exported function'])
      ;<  pro-u=@  try:m  (js-eval 'globalThis.__result')
      ;<  str=cord         try:m  (get-js-string pro-u)
      (ret &+str)
    ::  +get-result: parse (list lv) to get result type.
    ::  Must roundtrip with +ret.
    ::
    ++  get-result
      |=  res=(pole lv)
      ^-  (each cord (pair cord cord))
      ?+  res  !!
        [[%i32 %&] [%octs o=octs] ~]  &+q.o.res
        [[%i32 %|] [%octs p=octs] [%octs q=octs] ~]  |+[q.p.res q.q.res]
      ==
    ::  +js-val-cord-compare: compare a JSValue* with a string from cord
    ::
    ++  js-val-cord-compare
      |=  [val-u=@ =cord]
      =/  m  (script:lia-sur:wasm ? acc-mold)
      ^-  form:m
      =,  arr
      ;<  acc=acc-mold  try:m  get-acc
      =+  (get-js-ctx acc)
      ::
      ;<  crd-u=@  try:m  (malloc-cord cord)
      ;<  str-u=@  try:m  (call-1 'QTS_NewString' ctx-u crd-u ~)
      ;<  is-eq=@  try:m  (call-1 'QTS_IsEqual' ctx-u val-u str-u 0 ~)  :: QTS_EqualOp_SameValue
      ;<  *        try:m  (call 'QTS_FreeValuePointer' ctx-u str-u ~)
      ;<  *        try:m  (call 'free' crd-u ~)
      (return:m !=(is-eq 0))
    ::  +make-error: create an Exception object with a custom message
    ::
    ++  make-error
      |=  txt=cord
      =/  m  (script:lia-sur:wasm @ acc-mold)
      ^-  form:m
      =,  arr
      ;<  acc=acc-mold  try:m  get-acc
      =+  (get-js-ctx acc)
      ::
      ;<  err-u=@  try:m  (call-1 'QTS_NewError' ctx-u ~)
      =/  field=cord  'message'
      ;<  *        try:m
        %:  ring  'QTS_SetProp'
          ctx-u
          err-u
          (ding 'QTS_NewString' ctx-u (malloc-cord field) ~)
          (ding 'QTS_NewString' ctx-u (malloc-cord txt) ~)
          ~
        ==
      ::
      (return:m err-u)
    ::  +urbit-thread-make-object: construct a JS object to be imported with
    ::  `require`. Returns a pointer to that object.
    ::  Every registered functions' magic number must be recognized by
    ::  +qts-host-call-function
    ::
    ++  urbit-thread-make-object
      =/  m  (script:lia-sur:wasm @ acc-mold)
      ^-  form:m
      =,  arr
      ;<  acc=acc-mold  try:m  get-acc
      =+  (get-js-ctx acc)
      ::
      ;<  undef-u=@        try:m  (call-1 'QTS_GetUndefined' ~)
      ;<  obj-u=@          try:m  (call-1 'QTS_NewObject' ctx-u ~)
      ::
      ;<  *  try:m  (register-function 'load_txt_file' 5 obj-u)
      ;<  *  try:m  (register-function 'store_txt_file' 6 obj-u)
      ;<  *  try:m  (register-function 'sleep' 24 obj-u)
      ;<  *  try:m  (register-function 'restart' 25 obj-u)
      ::
      :: ;<  *  try:m  (register-function 'foo' 1 obj-u)
      ::
      ::  add urbit.tlon object for Tlon API
      ::
      ;<  tlon-str-u=@  try:m
        %:  ding  'QTS_NewString'
          ctx-u
          (malloc-cord 'tlon')
          ~
        ==
      ::
      ;<  *  try:m
        %:  ring  'QTS_DefineProp'
          ctx-u
          obj-u
          tlon-str-u
          (call-1 'QTS_NewObject' ctx-u ~)                ::  init value
          undef-u                                         ::  getter
          undef-u                                         ::  setter
          1                                               ::  configurable
          1                                               ::  enumerable
          1                                               ::  has value
          ~
        ==
      ::
      ;<  tlon-u=@  try:m
        (call-1 'QTS_GetProp' ctx-u obj-u tlon-str-u ~)
      ::
      =*  reg  register-function
      ;<  *  try:m  %:  reg  'get_channels'           8   tlon-u  ==
      ;<  *  try:m  %:  reg  'get_channel_messages'   9   tlon-u  ==
      ;<  *  try:m  %:  reg  'get_dm_messages'        10  tlon-u  ==
      ;<  *  try:m  %:  reg  'get_dm_replies'         11  tlon-u  ==
      ;<  *  try:m  %:  reg  'get_channel_replies'    12  tlon-u  ==
      ;<  *  try:m  %:  reg  'get_channel_members'    13  tlon-u  ==
      ;<  *  try:m  %:  reg  'get_roles'              14  tlon-u  ==
      ;<  *  try:m  %:  reg  'invite_user_channel'    15  tlon-u  ==
      ;<  *  try:m  %:  reg  'invite_user_groupchat'  16  tlon-u  ==
      ;<  *  try:m  %:  reg  'kick_user_channel'      17  tlon-u  ==
      ;<  *  try:m  %:  reg  'give_role'              18  tlon-u  ==
      ;<  *  try:m  %:  reg  'remove_role'            19  tlon-u  ==
      ;<  *  try:m  %:  reg  'post_channel'           20  tlon-u  ==
      ;<  *  try:m  %:  reg  'send_dm'                21  tlon-u  ==
      ;<  *  try:m  %:  reg  'reply_channel'          22  tlon-u  ==
      ;<  *  try:m  %:  reg  'get_groupchat_members'  23  tlon-u  ==
      ::
      ::  add urbit.pals object for Pals API
      ::
      ;<  pals-str-u=@  try:m
        %:  ding  'QTS_NewString'
          ctx-u
          (malloc-cord 'pals')
          ~
        ==
      ::
      ;<  *  try:m
        %:  ring  'QTS_DefineProp'
          ctx-u
          obj-u
          pals-str-u
          (call-1 'QTS_NewObject' ctx-u ~)                ::  init value
          undef-u                                         ::  getter
          undef-u                                         ::  setter
          1                                               ::  configurable
          1                                               ::  enumerable
          1                                               ::  has value
          ~
        ==
      ::
      ;<  pals-u=@  try:m
        (call-1 'QTS_GetProp' ctx-u obj-u pals-str-u ~)
      ::
      ;<  *  try:m  %:  reg  'get_leeches'  26  pals-u  ==
      ;<  *  try:m  %:  reg  'get_targets'  27  pals-u  ==
      ::
      (return:m obj-u)
    ::  +throw-error: returns a pointer to JSException
    ::
    ++  throw-error
      |=  err=cord
      =/  m  (script:lia-sur:wasm @ acc-mold)
      ^-  form:m
      =,  arr
      ;<  acc=acc-mold  try:m  get-acc
      =+  (get-js-ctx acc)
      (ding 'QTS_Throw' ctx-u (make-error err) ~)
    ::  +parse-path: friendly path parser, replaces .ext with /ext
    ::
    ++  parse-path
      |=  xap=cord
      |^  ^-  (unit path)
      (rush xap path-rule)
      ::  path element sans `.`
      ::
      ++  urs-ab-dotless
        %+  cook
          |=(a=tape (rap 3 ^-((list @) a)))
        (star ;~(pose nud low hep sig cab))
      ::
      ++  path-rule
        %+  sear
          |=  p=path
          ^-  (unit path)
          ?:  ?=([~ ~] p)  `~
          ?.  =(~ (rear p))  `p
          ~
        ;~  pfix
          ::  optional starting /
          ::
          (punt fas)
        ::::
          ::  foo/bar/baz.abc
          ::
          |-
          =*  this  $
          %+  knee  *path  |.  ~+
          ;~  pose
            ::  done
            ::
            (full (easy ~))
          ::::
            ::  foo.bar
            ::
            %+  cook  |=([a=@ta b=@ta] ~[a b])
            (full ;~(plug urs-ab-dotless ;~(pfix dot urs:ab)))
          ::::
            ::  foo | foo/...
            ::
            ;~(plug urs:ab ;~(pose (full (easy ~)) ;~(pfix fas this)))
          ==
        ==
      --
    ::  +return-undefined: return a pointer to a copy of `undefined` constant
    ::
    ::    apparently QuickJS crashes when it tries to free a constant pointer
    ::    return by QTS_GetUndefined and friends, so we duplicate a value
    ::    for safe return
    ::
    ++  return-undefined
      =/  m  (script:lia-sur:wasm @ acc-mold)
      ^-  form:m
      =,  arr
      ;<  acc=acc-mold  try:m  get-acc
      =+  (get-js-ctx acc)
      ;<  undef-const-u=@  try:m  (call-1 'QTS_GetUndefined' ~)
      (call-1 'QTS_DupValuePointer' ctx-u undef-const-u ~)
    ::  +load-json: return a JSON noun from QuickJS
    ::
    ++  load-json
      |=  ptr-u=@
      =/  m  (script:lia-sur:wasm json acc-mold)
      ^-  form:m
      =,  arr
      ;<  acc=acc-mold  try:m  get-acc
      =+  (get-js-ctx acc)
      ::
      ;<  type-u=@   try:m  (call-1 'QTS_Typeof' ctx-u ptr-u ~)
      ;<  type=cord  try:m  (get-c-string type-u)
      ?+    type  ~&(json-unsupported-type+type (return:m ~))
          ?(%'number' %'bigint')
        ;<  float=@rd  try:m  (call-1 'QTS_GetFloat64' ctx-u ptr-u ~)
        (return:m n+(rsh 3^2 (scot %rd float)))
      ::
          %'string'
        ;<  str=cord  try:m  (get-js-string ptr-u)
        (return:m s+str)
      ::
          %'boolean'
        ;<  float=@rd  try:m  (call-1 'QTS_GetFloat64' ctx-u ptr-u ~)
        (return:m b+!=(float 0))
      ::
          %'object'
        ::  %a, %o or ~
        ::  test for ~
        ::
        ;<  null-u=@  try:m  (call-1 'QTS_GetNull' ~)
        ;<  is-eq=@   try:m  (call-1 'QTS_IsEqual' ctx-u ptr-u null-u 0 ~)
        ?:  !=(0 is-eq)
          (return:m ~)
        ::  test for %a
        ::
        =/  name  'length'
        ;<  len-u=@  try:m
          %:  ding  'QTS_GetProp'
            ctx-u
            ptr-u
            (ding 'QTS_NewString' ctx-u (malloc-write +((met 3 name)) name) ~)
            ~
          ==
        ::
        ;<  err=(unit cord)  try:m  (mayb-error len-u)
        ;<  undef-u=@        try:m  (call-1 'QTS_GetUndefined' ~)
        ::
        ;<  is-undef=@  try:m  (call-1 'QTS_IsEqual' ctx-u len-u undef-u 0 ~)
        ?:  |(?=(^ err) !=(is-undef 0))  ::  obj.length either failed or undefined
          ::  object
          ::
          ;<  out-ptrs-u=@  try:m  (call-1 'malloc' 4 ~)
          ;<  out-len-u=@   try:m  (call-1 'malloc' 4 ~)
          ;<  err-u=@       try:m
            (call-1 'QTS_GetOwnPropertyNames' ctx-u out-ptrs-u out-len-u ptr-u 1 ~)  ::  JS_GPN_STRING_MASK
          ::
          ?:  !=(err-u 0)
            ;<  str=cord  try:m  (get-js-string err-u)
            ~&('GetOwnPropertyNames error'^str (return:m ~))
          ::
          ;<  len-octs=octs  try:m  (memread out-len-u 4)
          =/  len-w=@  q.len-octs
          ;<  arr-octs=octs  try:m  (memread out-ptrs-u 4)
          =/  arr-u=@  q.arr-octs
          =|  pairs=(list (pair @t json))
          ;<  *  try:m  (call 'free' out-len-u ~)
          ;<  *  try:m  (call 'free' out-ptrs-u ~)
          |-  ^-  form:m
          ?:  =(len-w 0)  (return:m o+(molt pairs))
          =/  idx=@  (dec len-w)
          ;<  nam-val-octs=octs  try:m  (memread (add arr-u (mul 4 idx)) 4)
          =/  nam-val-u=@  q.nam-val-octs
          ;<  name=cord    try:m  (get-js-string nam-val-u)
          ;<  val-u=@      try:m
            %:  call-1  'QTS_GetProp'
              ctx-u
              ptr-u
              nam-val-u
              ~
            ==
          ::
          ;<  jon-child=json  try:m  (load-json val-u)
          $(len-w (dec len-w), pairs [[name jon-child] pairs])
        ::  array
        ::
        ;<  len-d=@rd  try:m  (call-1 'QTS_GetFloat64' ctx-u len-u ~)
        =/  len=@  (abs:si (need (toi:rd len-d)))
        =|  vals=(list json)
        |-  ^-  form:m
        ?:  =(len 0)  (return:m a+vals)
        =/  idx=@  (dec len)
        ;<  val-u=@  try:m
          %:  ding  'QTS_GetProp'
            ctx-u
            ptr-u
            (call-1 'QTS_NewFloat64' ctx-u (sun:rd idx) ~)
            ~
          ==
        ::
        ;<  jon-child=json  try:m  (load-json val-u)
        $(len (dec len), vals [jon-child vals])
      ==
    ::  +store-json-name: create a global object from JSON noun
    ::
    ++  store-json-name
      |=  [name=cord =json]
      =/  m  (script:lia-sur:wasm ,~ acc-mold)
      ^-  form:m
      =,  arr
      ;<  acc=acc-mold  try:m  get-acc
      =+  (get-js-ctx acc)
      ::
      ;<  undef-u=@  try:m  (call-1 'QTS_GetUndefined' ~)
      ::
      ;<  *  try:m
        %:  ring  'QTS_DefineProp'
          ctx-u
          (call-1 'QTS_GetGlobalObject' ctx-u ~)
          (ding 'QTS_NewString' ctx-u (malloc-write +((met 3 name)) name) ~)
          (store-json json)
          undef-u  ::  get
          undef-u  ::  set
          1        ::  configurable
          1        ::  enumerable
          1        ::  has_value
          ~
        ==
      ::
      (return:m ~)
    ::  +store-json: put JSON noun into QuickJS context
    ::  and return JSValue pointer to it
    ::
    ++  store-json
      |=  jon=json
      =/  m  (script:lia-sur:wasm @ acc-mold)
      ^-  form:m
      =,  arr
      ;<  acc=acc-mold  try:m  get-acc
      =+  (get-js-ctx acc)
      ::
      =/  jon-cod=cord  (en:json:html jon)
      ::  escape backslashes and single quotes in JSON.parse
      ::
      =.  jon-cod
        %+  rap  3
        %+  rash  jon-cod
        ^~  %-  star
        ;~  pose
          (cold '\\\\' bas)  ::  \ -> \\
          (cold '\\\'' soq)  ::  ' -> \'
          next
        ==
      ::
      =/  code=cord
        (rap 3 'JSON.parse(\'' jon-cod '\')' ~)
      ::
      ;<  res-u=@  try:m
        %:  ding  'QTS_Eval'
          ctx-u
          (malloc-write +((met 3 code)) code)
          (met 3 code)
          fil-u
          1
          0
          ~
        ==
      ::
      ;<  err=(unit cord)  try:m  (mayb-error res-u)
      ?^  err  ~|  u.err  (return:m res-u)
      (return:m res-u)
    ::  +parse-url: friendly url parsing. Falls back to https
    ::
    ++  parse-url
      |=  lur=cord
      ^-  (unit purl:eyre)
      ?^  pur=(de-purl:html lur)  pur
      (de-purl:html (rap 3 'https://' lur ~))
    ::  +parse-methods: parse JSON to $moth:eyre
    ::
    ++  parse-methods
      |=  obj=(map @t json)
      ^-  (unit moth:eyre)
      =/  met=(unit meth:eyre)
        ?~  tod=(~(get by obj) %method)  `%get
        ::  handle null value
        ::
        ?~  u.tod  ~
        ?.  ?=(%s -.u.tod)  ~
        ?+  p.u.tod  ~
          %'CONNECT'  `%conn
          %'DELETE'   `%delt
          %'GET'      `%get
          %'HEAD'     `%head
          %'OPTIONS'  `%opts
          %'POST'     `%post
          %'PUT'      `%put
          %'TRACE'    `%trac
        ==
      ::
      ?~  met  ~
      =/  mat=(unit math:eyre)
        ?~  tod=(~(get by obj) %headers)  `~
        ?~  u.tod  ~
        ::  array of key-value pairs
        ::
        ?:  ?=(%a -.u.tod)
          =/  l=(unit (list [@t @t]))
            |-  ^-  (unit (list [@t @t]))
            ?~  p.u.tod  `~
            ?.  ?=([%a [[%s *] [%s *] ~]] i.p.u.tod)  ~
            =/  tel=(unit (list [@t @t]))  $(p.u.tod t.p.u.tod)
            ?~  tel  ~
            =*  arr  p.i.p.u.tod
            `[[p.i.arr p.i.t.arr] u.tel]
          ::
          ?~  l  ~
          :-  ~  =<  q
          %^  spin  u.l  *math:eyre
          |=  [[k=@t v=@t] j=(jar @t @t)]
          ^-  [* math:eyre]
          `(~(add ja j) k v)
        ::  plain object
        ::
        ?.  ?=(%o -.u.tod)  ~
        %-  ~(rep by p.u.tod)
        |:  [[k=*@t v=*json] acc=`(unit math:eyre)`[~ *math:eyre]]
        ^-  (unit math:eyre)
        ?~  acc  ~
        ?.  ?=([%s *] v)  ~
        acc(u (~(put by u.acc) k ~[p.v]))
      ::
      ?~  mat  ~
      =/  bod=(unit (unit octs))
        ?~  dob=(~(get by obj) %body)  `~
        ?.  ?=([%s *] u.dob)  ~
        ``(tem p.u.dob)
      ::
      ?~  bod  ~
      `[u.met u.mat u.bod]
    --
::
::  Wasm & JS imports
::
=>  |%
    ++  throw-args
      |=  [name=cord got=@ need=@]
      %-  throw-error
      %:  rap  3
        'Not enough arguments for function "'  name  '", got '
        (scot %ud got)  ', need at least '  (scot %ud need)
        ~
      ==
    ::
    ++  throw-path
      |=  xap=cord
      %-  throw-error
      %:  rap  3
        'Invalid path: "'  xap
        ~
      ==
    ::
    ++  throw-url
      |=  lur=cord
      %-  throw-error
      %:  rap  3
        'Invalid URL: "'  lur
        ~
      ==
    ::
    ++  throw-methods
      |=  *
      (throw-error 'Failed parsing `fetch` methods')
    ::
    ++  throw-integer
      |=  float=@rd
      %-  throw-error
      %:  rap  3
        'Type error: '  (rsh [3 2] (scot %rd float))  ' cannot be an integer'
        ~
      ==
    :: +require: NodeJS-like import interface
    ::
    ++  require
      |=  [ctx-u=@ this-u=@ argc-w=@ argv-u=@]
      =/  m  (script:lia-sur:wasm @ acc-mold)
      ^-  form:m
      =,  arr
      ?.  (gte argc-w 1)  (throw-args 'require' argc-w 1)
      ;<  is-urbit-thread=?  try:m  (js-val-cord-compare argv-u 'urbit_thread')
      ?:  is-urbit-thread  urbit-thread-make-object
      ::
      ::  ;<  is-foo-bar=?  try:m  (js-val-cord-compare argv-u 'foo_bar')
      ::  ?:  is-foo-bar  foo-bar-make-object
      ::  ...
      ::
      ::  If the string is not matched: throw error
      ::
      ;<  str=cord  try:m  (get-js-string argv-u)
      (throw-error (rap 3 'Module "' str '" not available' ~))
    ::
    ++  console-log
      |=  [ctx-u=@ this-u=@ argc-w=@ argv-u=@]
      =/  m  (script:lia-sur:wasm @ acc-mold)
      ^-  form:m
      =,  arr
      =|  strs=(list cord)
      |-  ^-  form:m
      ?:  =(argc-w 0)
        ~&  `@t`(rap 3 (join ' ' strs))
        return-undefined
      =.  argc-w  (dec argc-w)
      ;<  str=cord  try:m  (get-js-string (add (mul 8 argc-w) argv-u))
      $(strs [str strs])
    ::
    ++  console-error
      |=  [ctx-u=@ this-u=@ argc-w=@ argv-u=@]
      =/  m  (script:lia-sur:wasm @ acc-mold)
      ^-  form:m
      =,  arr
      =|  strs=(list cord)
      |-  ^-  form:m
      ?:  =(argc-w 0)
        ~&  >>>  `@t`(rap 3 (join ' ' strs))
        return-undefined
      =.  argc-w  (dec argc-w)
      ;<  str=cord  try:m  (get-js-string (add (mul 8 argc-w) argv-u))
      $(strs [str strs])
    ::
    ++  console-warn
      |=  [ctx-u=@ this-u=@ argc-w=@ argv-u=@]
      =/  m  (script:lia-sur:wasm @ acc-mold)
      ^-  form:m
      =,  arr
      =|  strs=(list cord)
      |-  ^-  form:m
      ?:  =(argc-w 0)
        ~&  >>  `@t`(rap 3 (join ' ' strs))
        return-undefined
      =.  argc-w  (dec argc-w)
      ;<  str=cord  try:m  (get-js-string (add (mul 8 argc-w) argv-u))
      $(strs [str strs])
    ::
    ++  load-txt-file
      |=  [ctx-u=@ this-u=@ argc-w=@ argv-u=@]
      =/  m  (script:lia-sur:wasm @ acc-mold)
      ^-  form:m
      =,  arr
      ?.  (gte argc-w 1)  (throw-args 'load_txt_file' argc-w 1)
      ;<  xap=cord  try:m  (get-js-string argv-u)
      ?~  pax=(parse-path xap)  (throw-path xap)
      ;<  res=(pole lv)  try:m  (get-txt-file:ext u.pax)
      ?~  res  (throw-error (rap 3 'No .txt file at path ' xap ~))
      ?>  ?=([[%octs p=octs] ~] res)
      (ding 'QTS_NewString' ctx-u (malloc-cord q.p.res) ~)
    ::
    ++  store-txt-file
      |=  [ctx-u=@ this-u=@ argc-w=@ argv-u=@]
      =/  m  (script:lia-sur:wasm @ acc-mold)
      ^-  form:m
      =,  arr
      ?.  (gte argc-w 2)  (throw-args 'store_txt_file' argc-w 2)
      ;<  xap=cord  try:m  (get-js-string argv-u)
      ;<  txt=cord  try:m  (get-js-string (add argv-u 8))  ::  sizeof JSValue == 8 in Wasm build of QuickJS
      ?~  pax=(parse-path xap)  (throw-path xap)
      =/  las=@ta  (rear u.pax)
      ?.  =(%txt las)
        (throw-error (rap 3 'Invalid path extension: want txt, got ' las ~))
      ;<  *         try:m  (set-txt-file:ext u.pax txt)
      return-undefined
    ::
    ++  host-fetch-url
      |=  [ctx-u=@ this-u=@ argc-w=@ argv-u=@]
      =/  m  (script:lia-sur:wasm @ acc-mold)
      ^-  form:m
      =,  arr
      ?.  (gte argc-w 1)  (throw-args 'fetch_sync' argc-w 1)
      ::  (either a string or URL object)
      ::
      ;<  url-jon=json  try:m  (load-json argv-u)
      =/  lur=(unit @t)
        ?~  url-jon  ~
        ?+    -.url-jon  ~
            %s  `p.url-jon
            %o
          ?~  href=(~(get by p.url-jon) %href)  ~
          ?.  ?=(%s -.u.href)  ~
          `p.u.href
        ==
      ::
      ?~  lur   (throw-error 'Unrecognized type in fetch_sync')
      ;<  tom=json  try:m
        =/  m  (script:lia-sur:wasm json acc-mold)
        ^-  form:m
        ?:  =(1 argc-w)  (return:m o+~)
        (load-json (add argv-u 8))
      ::
      ?~  purl=(parse-url u.lur)  (throw-url u.lur)
      ?.  ?=([%o *] tom)  (throw-methods tom)
      ?~  moth=(parse-methods p.tom)  (throw-methods tom)
      ;<  res=(pole lv)  try:m  (fetch-url:ext u.purl u.moth)
      ?~  res  (throw-error (rap 3 'Failed http request: ' u.lur ~))
      ?>  ?=([[%vase p=*] ~] res)
      =+  !<(=httr:eyre p.res)
      =/  jon=json
        =,  enjs:format
        %-  pairs
        =-  ?~(r.httr - [body+s+q.u.r.httr -])
        :~  status+(numb p.httr)
            :-  'statusText'
            `json`s+(crip "Code {<p.httr>}")  ::  XX proper statusText
        ::
            headers+`json`(pairs (turn q.httr |=([p=@t q=@t] [p s+q])))
        ==
      ::
      (store-json jon)
    ::
    ++  sleep
      |=  [ctx-u=@ this-u=@ argc-w=@ argv-u=@]
      =/  m  (script:lia-sur:wasm @ acc-mold)
      ^-  form:m
      =,  arr
      ?.  (gte argc-w 1)  (throw-args 'sleep' argc-w 1)
      ;<  float=@rd  try:m  (call-1 'QTS_GetFloat64' ctx-u argv-u ~)
      ?~  n=(bind (toi:rd float) abs:si)  (throw-integer float)
      ;<  *  try:m  (sleep:ext (mul u.n ~s1))
      return-undefined
    ::  does not return
    ::
    ++  restart
      |=  [ctx-u=@ this-u=@ argc-w=@ argv-u=@]
      =/  m  (script:lia-sur:wasm @ acc-mold)
      ^-  form:m
      =,  arr
      ::  signal to the host that the upcoming Wasm crash is
      ::  part of freeing the state
      ::
      ;<  *  try:m  restart:ext
      ~&  >  'Freeing Wasm VM by crashing it'
      fail:m
    ::
    ::  +clock-time-get: WASI import to get time
    ::
    ++  clock-time-get
      |=  args=(pole cw)
      =/  m  (script:lia-sur:wasm (list cw) acc-mold)
      ^-  form:m
      ?>  ?=([[%i32 @] [%i64 @] [%i32 time-u=@] ~] args)
      =,  arr  =,  args
      ;<  l=(pole lv)   try:m  get-bowl:ext
      ?>  ?=([[%vase owl=*] ~] l)
      =+  !<(bol=bowl:rand owl.l)
      ;<  tor=acc-mold  try:m  get-acc
      =+  !<(=acc tor)
      =.  acc  acc(bowl `bol)
      ;<  ~             try:m  (set-acc !>(acc))
      ::
      =/  time=@da  now.bol
      ::  WASI time is in ns
      ::
      =/  ntime  (mul 1.000.000 (unm:chrono:userlib time))
      ;<  ~  try:m  (memwrite time-u 8 ntime)
      (return:m i32+0 ~)
    ::  ++enjs: encode to JSON. We roll our own en/decodings to ensure
    ::  roundtripping
    ::
    ++  enjs
      =,  enjs:format
      |%
      ::  replaces ++ship:enjs:format and is different from Tlon def
      ::
      ++  ship
        |=  a=@p
        ^-  json
        s+(scot %p a)
      ::  time is used as a unique key, we need to preserve it
      ::
      ++  time
        |=  t=@
        ^-  json
        s+(rap 3 +>:(scow %ui t))
      ::
      ++  memo
        |=  m=memo:channels-sur
        ^-  json
        %-  pairs
        :~  content/(story:enjs:sj content.m)
            author/(ship ?@(a=author.m a ship.a))
            sent/(time sent.m)
        ==
      --
    ::  ++dejs: decode from JSON
    ::
    ++  dejs
      =,  dejs:format
      |%
      ++  ship
        |=  jon=json
        ^-  @p
        ?>  ?=(%s -.jon)
        (slav %p p.jon)
      ::
      ++  memo
        ^-  $-(json memo:channels-sur)
        %-  ot
        :~  content+story:dejs:sj
            author+ship
            sent+di
        ==
      ::
      ++  time
        ^-  $-(json @da)
        (su dim:ag)
      --
    ::  TM API functions linked to JS environment
    ::
    ++  tm-js
      ::  Nest: string
      ::  Story: (definition is large, refer to gist Quodss/hooks-js.md)
      ::  Memo: {content: Story, author: string, sent: number}
      ::
      |%
      ++  rule-ship-club
        %+  cook  |=((each @p id-club) +<)
        ;~  pose
          (stag %& ;~(pfix sig fed:ag))
          (stag %| sym)
        ==
      ::
      ::  () => Nest[]
      ::
      ++  get-channels
        |=  [ctx-u=@ this-u=@ argc-w=@ argv-u=@]
        =/  m  (script:lia-sur:wasm @ acc-mold)
        ^-  form:m
        =,  arr
        ;<  res=(pole lv)  try:m  get-channels:ext
        ?>  ?=([[%vase p=*] ~] res)
        =+  !<(nests=(list nest:channels-sur) p.res)
        (store-json a+(turn nests nest:enjs:cj))
      ::  (Nest, number) => {key: number, message: Memo}[]
      ::
      ++  get-channel-messages
        |=  [ctx-u=@ this-u=@ argc-w=@ argv-u=@]
        =/  m  (script:lia-sur:wasm @ acc-mold)
        ^-  form:m
        =,  arr
        ?.  (gte argc-w 2)  (throw-args 'get_channel_messages' argc-w 2)
        ;<  nest-str=cord  try:m  (get-js-string argv-u)
        ?~  nest=(mole |.((rash nest-str nest-rule:dejs:cj)))
          %-  throw-error
          (rap 3 'SyntaxError: ' nest-str ' is not a valid Nest' ~)
        ;<  acc=acc-mold  try:m  get-acc
        =+  (get-js-ctx acc)
        ::
        ;<  float=@rd  try:m  (call-1 'QTS_GetFloat64' ctx-u (add 8 argv-u) ~)
        ?~  n=(bind (toi:rd float) abs:si)  (throw-integer float)
        ;<  res=(pole lv)  try:m  (get-chan-messages:ext u.nest u.n)
        ?>  ?=([[%vase p=*] ~] res)
        =+  !<(l=(list [time memo:channels-sur]) p.res)
        %-  store-json
        :-  %a
        %+  turn  l
        |=  [t=time m=memo:channels-sur]
        ^-  json
        =,  enjs:format
        %-  pairs
        :~  key+(time:enjs t)
            message+(memo:enjs m)
        ==
      ::  (string, number) => {key: number, message: Memo}[]
      ::  input string is either @p or club id
      ::
      ++  get-dm-messages
        |=  [ctx-u=@ this-u=@ argc-w=@ argv-u=@]
        =/  m  (script:lia-sur:wasm @ acc-mold)
        ^-  form:m
        =,  arr
        ?.  (gte argc-w 2)  (throw-args 'get_dm_messages' argc-w 2)
        ;<  dm-id-str=cord  try:m  (get-js-string argv-u)
        ?~  who=(mole |.((rash dm-id-str rule-ship-club)))  ::  XX remove inner parens and parser spins forever, why???
          %-  throw-error
          (rap 3 'SyntaxError: ' dm-id-str ' is not a valid DM id' ~)
        ;<  float=@rd  try:m  (call-1 'QTS_GetFloat64' ctx-u (add 8 argv-u) ~)
        ?~  n=(bind (toi:rd float) abs:si)  (throw-integer float)
        ;<  res=(pole lv)  try:m
          ?:  ?=(%& -.u.who)
            (get-dm-messages:ext p.u.who u.n)
          (get-club-messages:ext p.u.who u.n)
        ::
        ?>  ?=([[%vase p=*] ~] res)
        =+  !<(l=(list [time memo:channels-sur]) p.res)
        %-  store-json
        :-  %a
        %+  turn  l
        |=  [t=time m=memo:channels-sur]
        ^-  json
        =,  enjs:format
        %-  pairs
        :~  key+(time:enjs t)
            message+(memo:enjs m)
        ==
      ::  (string, key=number) => Memo[]
      ::  input string is either @p or club id
      ::
      ++  get-dm-replies
        |=  [ctx-u=@ this-u=@ argc-w=@ argv-u=@]
        =/  m  (script:lia-sur:wasm @ acc-mold)
        ^-  form:m
        =,  arr
        ?.  (gte argc-w 2)  (throw-args 'get_dm_replies' argc-w 2)
        ;<  dm-id-str=cord  try:m  (get-js-string argv-u)
        ?~  who=(mole |.((rash dm-id-str rule-ship-club)))
          %-  throw-error
          (rap 3 'SyntaxError: ' dm-id-str ' is not a valid DM id' ~)
        ;<  key-str=cord  try:m  (get-js-string (add 8 argv-u))
        ?~  key=(rush key-str dim:ag)
          %-  throw-error
          (rap 3 'SyntaxError: ' key-str ' is not a valid message identifier' ~)
        ;<  res=(pole lv)  try:m
          ?:  ?=(%& -.u.who)
            (get-dm-replies:ext p.u.who u.key)
          (get-club-replies:ext p.u.who u.key)
        ::
        ?>  ?=([[%vase p=*] ~] res)
        =+  !<(l=(list memo:channels-sur) p.res)
        (store-json a+(turn l memo:enjs))
      ::  (Nest, key=number) => Memo[]
      ::
      ++  get-channel-replies
        |=  [ctx-u=@ this-u=@ argc-w=@ argv-u=@]
        =/  m  (script:lia-sur:wasm @ acc-mold)
        ^-  form:m
        =,  arr
        ?.  (gte argc-w 2)  (throw-args 'get_channel_replies' argc-w 2)
        ;<  nest-str=cord  try:m  (get-js-string argv-u)
        ?~  nest=(mole |.((rash nest-str nest-rule:dejs:cj)))
          %-  throw-error
          (rap 3 'SyntaxError: ' nest-str ' is not a valid Nest' ~)
        ;<  key-str=cord  try:m  (get-js-string (add 8 argv-u))
        ?~  key=(rush key-str dim:ag)
          %-  throw-error
          (rap 3 'SyntaxError: ' key-str ' is not a valid message identifier' ~)
        ;<  res=(pole lv)  try:m  (get-chan-replies:ext u.nest u.key)
        ?>  ?=([[%vase p=*] ~] res)
        =+  !<(l=(list memo:channels-sur) p.res)
        (store-json a+(turn l memo:enjs))
      ::  (Nest) => string[]
      ::
      ++  get-channel-members
        |=  [ctx-u=@ this-u=@ argc-w=@ argv-u=@]
        =/  m  (script:lia-sur:wasm @ acc-mold)
        ^-  form:m
        =,  arr
        ?.  (gte argc-w 1)  (throw-args 'get_channel_members' argc-w 1)
        ;<  nest-str=cord  try:m  (get-js-string argv-u)
        ?~  nest=(mole |.((rash nest-str nest-rule:dejs:cj)))
          %-  throw-error
          (rap 3 'SyntaxError: ' nest-str ' is not a valid Nest' ~)
        ;<  res=(pole lv)  try:m  (get-chan-members:ext u.nest)
        ?>  ?=([[%vase p=*] ~] res)
        =+  !<(s=(set @p) p.res)
        (store-json a+(turn ~(tap in s) ship:enjs))
      ::  (Nest, ship=string) => string[]
      ::
      ++  get-roles
        |=  [ctx-u=@ this-u=@ argc-w=@ argv-u=@]
        =/  m  (script:lia-sur:wasm @ acc-mold)
        ^-  form:m
        =,  arr
        ?.  (gte argc-w 2)  (throw-args 'get_roles' argc-w 2)
        ;<  nest-str=cord  try:m  (get-js-string argv-u)
        ?~  nest=(mole |.((rash nest-str nest-rule:dejs:cj)))
          %-  throw-error
          (rap 3 'SyntaxError: ' nest-str ' is not a valid Nest' ~)
        ;<  ship-str=cord  try:m  (get-js-string (add 8 argv-u))
        ?~  ship=(slaw %p ship-str)
          %-  throw-error
          (rap 3 'SyntaxError: ' ship-str ' is not a valid ship' ~)
        ;<  res=(pole lv)  try:m  (get-roles:ext u.nest u.ship)
        ?>  ?=([[%vase p=*] ~] res)
        =+  !<(s=(set @tas) p.res)
        (store-json a+(turn ~(tap in s) (lead %s)))
      ::  (Nest, ship=string) => ()
      ::
      ++  invite-user-channel
        |=  [ctx-u=@ this-u=@ argc-w=@ argv-u=@]
        =/  m  (script:lia-sur:wasm @ acc-mold)
        ^-  form:m
        =,  arr
        ?.  (gte argc-w 2)  (throw-args 'invite_user_channel' argc-w 2)
        ;<  nest-str=cord  try:m  (get-js-string argv-u)
        ?~  nest=(mole |.((rash nest-str nest-rule:dejs:cj)))
          %-  throw-error
          (rap 3 'SyntaxError: ' nest-str ' is not a valid Nest' ~)
        ;<  ship-str=cord  try:m  (get-js-string (add 8 argv-u))
        ?~  ship=(slaw %p ship-str)
          %-  throw-error
          (rap 3 'SyntaxError: ' ship-str ' is not a valid ship' ~)
        ;<  *  try:m  (add-user-chan:ext u.nest u.ship)
        return-undefined
      ::  (id=string ship=string) => ()
      ::
      ++  invite-user-groupchat
        |=  [ctx-u=@ this-u=@ argc-w=@ argv-u=@]
        =/  m  (script:lia-sur:wasm @ acc-mold)
        ^-  form:m
        =,  arr
        ?.  (gte argc-w 2)  (throw-args 'invite_user_groupchat' argc-w 2)
        ;<  id-str=cord  try:m  (get-js-string argv-u)
        ?~  id=(rush id-str sym)
          %-  throw-error
          (rap 3 'SyntaxError: ' id-str ' is not a valid groupchat ID' ~)
        ;<  ship-str=cord  try:m  (get-js-string (add 8 argv-u))
        ?~  ship=(slaw %p ship-str)
          %-  throw-error
          (rap 3 'SyntaxError: ' ship-str ' is not a valid ship' ~)
        ;<  *  try:m  (add-user-club:ext u.id u.ship)
        return-undefined
      ::  (Nest ship=string) => ()
      ::
      ++  kick-user-channel
        |=  [ctx-u=@ this-u=@ argc-w=@ argv-u=@]
        =/  m  (script:lia-sur:wasm @ acc-mold)
        ^-  form:m
        =,  arr
        ?.  (gte argc-w 2)  (throw-args 'kick_user_channel' argc-w 2)
        ;<  nest-str=cord  try:m  (get-js-string argv-u)
        ?~  nest=(mole |.((rash nest-str nest-rule:dejs:cj)))
          %-  throw-error
          (rap 3 'SyntaxError: ' nest-str ' is not a valid Nest' ~)
        ;<  ship-str=cord  try:m  (get-js-string (add 8 argv-u))
        ?~  ship=(slaw %p ship-str)
          %-  throw-error
          (rap 3 'SyntaxError: ' ship-str ' is not a valid ship' ~)
        ;<  *  try:m  (kick-user-chan:ext u.nest u.ship)
        return-undefined
      ::  (Nest ship=string role=string) => ()
      ::
      ++  give-role
        |=  [ctx-u=@ this-u=@ argc-w=@ argv-u=@]
        =/  m  (script:lia-sur:wasm @ acc-mold)
        ^-  form:m
        =,  arr
        ?.  (gte argc-w 3)  (throw-args 'give_role' argc-w 3)
        ;<  nest-str=cord  try:m  (get-js-string argv-u)
        ?~  nest=(mole |.((rash nest-str nest-rule:dejs:cj)))
          %-  throw-error
          (rap 3 'SyntaxError: ' nest-str ' is not a valid Nest' ~)
        ;<  ship-str=cord  try:m  (get-js-string (add 8 argv-u))
        ?~  ship=(slaw %p ship-str)
          %-  throw-error
          (rap 3 'SyntaxError: ' ship-str ' is not a valid ship' ~)
        ;<  role-str=cord  try:m  (get-js-string (add 16 argv-u))
        ?~  role=(slaw %tas role-str)
          %-  throw-error
          (rap 3 'SyntaxError: ' role-str ' is not a valid role' ~)
        ;<  *  try:m  (give-role:ext u.nest u.ship u.role)
        return-undefined
      ::  (Nest ship=string role=string) => ()
      ::
      ++  remove-role
        |=  [ctx-u=@ this-u=@ argc-w=@ argv-u=@]
        =/  m  (script:lia-sur:wasm @ acc-mold)
        ^-  form:m
        =,  arr
        ?.  (gte argc-w 3)  (throw-args 'remove_role' argc-w 3)
        ;<  nest-str=cord  try:m  (get-js-string argv-u)
        ?~  nest=(mole |.((rash nest-str nest-rule:dejs:cj)))
          %-  throw-error
          (rap 3 'SyntaxError: ' nest-str ' is not a valid Nest' ~)
        ;<  ship-str=cord  try:m  (get-js-string (add 8 argv-u))
        ?~  ship=(slaw %p ship-str)
          %-  throw-error
          (rap 3 'SyntaxError: ' ship-str ' is not a valid ship' ~)
        ;<  role-str=cord  try:m  (get-js-string (add 16 argv-u))
        ?~  role=(slaw %tas role-str)
          %-  throw-error
          (rap 3 'SyntaxError: ' role-str ' is not a valid role' ~)
        ;<  *  try:m  (remove-role:ext u.nest u.ship u.role)
        return-undefined
      ::  (Nest, post=string) => ()  XX more complex stories? markdown-esque parsing?
      ::
      ++  post-channel
        |=  [ctx-u=@ this-u=@ argc-w=@ argv-u=@]
        =/  m  (script:lia-sur:wasm @ acc-mold)
        ^-  form:m
        =,  arr
        ?.  (gte argc-w 2)  (throw-args 'post_channel' argc-w 2)
        ;<  nest-str=cord  try:m  (get-js-string argv-u)
        ?~  nest=(mole |.((rash nest-str nest-rule:dejs:cj)))
          %-  throw-error
          (rap 3 'SyntaxError: ' nest-str ' is not a valid Nest' ~)
        ;<  story-str=cord  try:m  (get-js-string (add 8 argv-u))
        =/  =story:channels-sur  [inline+[story-str]~]~
        ;<  *  try:m  (post-chan:ext u.nest story)
        return-undefined
      ::  (string, post=string) => ()
      ::  input string is either @p or club id
      ::
      ++  send-dm
        |=  [ctx-u=@ this-u=@ argc-w=@ argv-u=@]
        =/  m  (script:lia-sur:wasm @ acc-mold)
        ^-  form:m
        =,  arr
        ?.  (gte argc-w 2)  (throw-args 'send_dm' argc-w 2)
        ;<  dm-id-str=cord  try:m  (get-js-string argv-u)
        ?~  who=(mole |.((rash dm-id-str rule-ship-club)))
          %-  throw-error
          (rap 3 'SyntaxError: ' dm-id-str ' is not a valid DM id' ~)
        ;<  story-str=cord  try:m  (get-js-string (add 8 argv-u))
        =/  =story:channels-sur  [inline+[story-str]~]~
        ;<  *  try:m
          ?-  -.u.who
            %&  (send-dm:ext p.u.who story)
            %|  (send-club:ext p.u.who story)
          ==
        ::
        return-undefined
      ::  (Nest, key=string, post=string) => ()
      ::
      ++  reply-channel
        |=  [ctx-u=@ this-u=@ argc-w=@ argv-u=@]
        =/  m  (script:lia-sur:wasm @ acc-mold)
        ^-  form:m
        =,  arr
        ?.  (gte argc-w 3)  (throw-args 'post_reply' argc-w 3)
        ;<  nest-str=cord  try:m  (get-js-string argv-u)
        ?~  nest=(mole |.((rash nest-str nest-rule:dejs:cj)))
          %-  throw-error
          (rap 3 'SyntaxError: ' nest-str ' is not a valid Nest' ~)
        ;<  key-str=cord  try:m  (get-js-string (add 8 argv-u))
        ?~  key=(rush key-str dim:ag)
          %-  throw-error
          (rap 3 'SyntaxError: ' key-str ' is not a valid message identifier' ~)
        ;<  story-str=cord  try:m  (get-js-string (add 16 argv-u))
        =/  =story:channels-sur  [inline+[story-str]~]~
        ;<  *  try:m  (post-reply:ext u.nest u.key story)
        return-undefined
      ::  (id=string) => string[]
      ::
      ++  get-club-members
        |=  [ctx-u=@ this-u=@ argc-w=@ argv-u=@]
        =/  m  (script:lia-sur:wasm @ acc-mold)
        ^-  form:m
        =,  arr
        ?.  (gte argc-w 1)  (throw-args 'get_groupchat_members' argc-w 1)
        ;<  id-str=cord  try:m  (get-js-string argv-u)
        ?~  id=(rush id-str sym)
          %-  throw-error
          (rap 3 'SyntaxError: ' id-str ' is not a valid groupchat ID' ~)
        ;<  res=(pole lv)  try:m  (get-club-members:ext u.id)
        ?>  ?=([[%vase p=*] ~] res)
        =+  !<(s=(set @p) p.res)
        (store-json a+(turn ~(tap in s) ship:enjs))
      --
    ::  Pals functions linked to JS environment
    ::
    ++  pals-js
      |%
      ::  () => string[]
      ::
      ++  leeches
        |=  [ctx-u=@ this-u=@ argc-w=@ argv-u=@]
        =/  m  (script:lia-sur:wasm @ acc-mold)
        ^-  form:m
        =,  arr
        ;<  res=(pole lv)  try:m  get-leeches:ext
        ?>  ?=([[%vase p=*] ~] res)
        =+  !<(s=(set @p) p.res)
        (store-json a+(turn ~(tap in s) ship:enjs))
      ::  (?tag=string) => string[]
      ::
      ++  targets
        |=  [ctx-u=@ this-u=@ argc-w=@ argv-u=@]
        =/  m  (script:lia-sur:wasm @ acc-mold)
        |^  ^-  form:m
        =,  arr
        ?:  =(argc-w 0)
          ;<  res=(pole lv)  try:m  (get-targets:ext ~)
          (store-json (ships res))
        ;<  tag-str=cord  try:m  (get-js-string argv-u)
        ?:  =(~ tag-str)
          ;<  res=(pole lv)  try:m  (get-targets:ext ~)
          (store-json (ships res))
        ?.  ((sane %ta) tag-str)
          ~&  >>  "Insane tag: {(trip tag-str)}"
          (call-1 'QTS_NewArray' ctx-u ~)
        ;<  res=(pole lv)  try:m  (get-targets:ext ~ `@ta`tag-str)
        (store-json (ships res))
        ::
        ++  ships
          |=  res=(pole lv)
          ^-  json
          ?>  ?=([[%vase p=*] ~] res)
          =+  !<(s=(set @p) p.res)
          a+(turn ~(tap in s) ship:enjs)
        --
      --
    ::  +qts-host-call-function: Wasm import to resolve JS imports
    ::
    ++  qts-host-call-function
      |=  args=(pole cw)
      =/  m  (script:lia-sur:wasm (list cw) acc-mold)
      ^-  form:m
      ?>  ?=  $:  [%i32 ctx-u=@]
                  [%i32 this-u=@]
                  [%i32 argc-w=@]
                  [%i32 argv-u=@]
                  [%i32 magic-w=@]
                  ~
              ==
          args
      ::
      =,  arr  =,  args
      ;<  acc=acc-mold  try:m  get-acc
      =/  arrow=$-([@ @ @ @] (script-form @ acc-mold))
        ~+
        ?+  magic-w.args  !!
        ::  put JS imports here
        ::
          %0   require
          %1   console-log
          %2   console-error
          %3   console-warn
          %4   console-log  ::  console_info alias
          %5   load-txt-file
          %6   store-txt-file
          %7   host-fetch-url
          %8   get-channels:tm-js
          %9   get-channel-messages:tm-js
          %10  get-dm-messages:tm-js
          %11  get-dm-replies:tm-js
          %12  get-channel-replies:tm-js
          %13  get-channel-members:tm-js
          %14  get-roles:tm-js
          %15  invite-user-channel:tm-js
          %16  invite-user-groupchat:tm-js
          %17  kick-user-channel:tm-js
          %18  give-role:tm-js
          %19  remove-role:tm-js
          %20  post-channel:tm-js
          %21  send-dm:tm-js
          %22  reply-channel:tm-js
          %23  get-club-members:tm-js
          %24  sleep
          %25  restart
          %26  leeches:pals-js
          %27  targets:pals-js
        ==
      ::
      ;<  val-u=@  try:m  (arrow ctx-u this-u argc-w argv-u)
      (return:m i32+val-u ~)
    ::  +emscripten-notify-memory-growth: ES-generated Wasm import to let
    ::  the host update its memory view. Urwasm memory model is not affected
    ::  by reallocations, so we do nothing.
    ::
    ++  emscripten-notify-memory-growth
      |=  *
      =/  m  (script:lia-sur:wasm (list cw) acc-mold)
      (return:m ~)
    --
::
=/  imports=(import:lia-sur:wasm acc-mold)
  :-  !>(*acc)
  =/  m  (script:lia-sur:wasm (list cw) acc-mold)
  %-  ~(gas by *(map (pair cord cord) $-((list cw) form:m)))
  :~
    ['wasi_snapshot_preview1'^'clock_time_get' clock-time-get]
    ['env'^'qts_host_call_function' qts-host-call-function]
    ['env'^'emscripten_notify_memory_growth' emscripten-notify-memory-growth]
  ==
::
::  Thread builder
::  (JS code => _!>(*[%0 ?([%& p=result=cord] [%| p=how=cord q=where=cord])]))
::
=/  hint  %rand
|=  code=cord
^-  shed:khan
=/  m  (strand vase)
;<  res=(each cord (pair cord cord))  bind:m
  =/  m  (strand (each cord (pair cord cord)))
  ;<  *  bind:m  (pure:m &+%$)
  |-  ^-  form:m
  =*  restart-loop  $
  =/  =seed:lia-sur:wasm  [quick-js-wasm (return:runnable:wasm ~) ~ imports]
  =^  [yil=(yield (list lv)) *]  seed  (run:wasm &+(main code) seed hint)
  |-  ^-  form:m
  =*  block-loop  $
  ?-    -.yil
      %0
    (pure:m (get-result p.yil))
  ::
      %1
    ?:  ?=(%restart name.yil)
      ::  free state, run anew
      ::
      =^  *  seed  (run:wasm |+~ seed hint)
      restart-loop
    ::  resolve block, continue
    ::
    ;<  res=(list lv)  bind:m  ((fetch-thread name.yil) args.yil)
    =^  [yil1=(yield (list lv)) *]  seed  (run:wasm |+res seed hint)
    block-loop(yil yil1)
  ::
      %2
    (strand-fail:rand %thread-js ~['Wasm VM crashed'])
  ==
::  ;<  res
(pure:m !>(0+res))