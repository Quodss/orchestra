/-  *orchestra, spider
/+  dbug, default-agent, verb, server, schooner
/+  sio=strandio
/+  thread-builder-js
=*  stub  ~|(%stub !!)
=*  name-term  %orchestra
=*  name-mold  $orchestra
=/  our-url    (cat 3 '/apps/' name-term)
=/  seconds-mask  (mix (not 7 1 0) (not 6 1 0))
|%
+$  versioned-persistent-state
  $%  state-0
  ==
::
+$  strand-state
  $+  strand-state
  $:  src=strand-source
      params=strand-params
      is-running=?
      params-counter=@
      fires-at=(unit @da)
      hash=@uv
  ==
::
+$  state-0
  $+  state-0
  $:  version=%0
      suspend-counter=@
      strands=(map strand-id strand-state)
      products=(map strand-id (pair (each vase tang) time))
  ==
::
+$  state-diff
  $+  state-diff
  $:  strands=strand-diff
      products=product-diff
  ==
::
+$  strand-diff-v
  $%  [%new s=strand-state]
      [%edit s=strand-state-diff]
      [%del ~]
  ==
::
+$  strand-diff  (map strand-id strand-diff-v)
::
+$  strand-state-diff-v
  $%  [%source src=strand-source]
      [%params p=strand-params]
      [%running flag=?]
  ==
::
+$  strand-state-diff  (set strand-state-diff-v)
::
+$  product-diff-v
  $%  [%new p=(each vase tang) q=time]
      [%del ~]
  ==
::
+$  product-diff  (map strand-id product-diff-v)
::
+$  polling  (map time [stale=? s=persistent])
+$  transient-state
  $:  =polling
  ==
::
+$  persistent  state-0
+$  state  [persistent transient-state]
+$  card  card:agent:gall
+$  sign  sign:agent:gall
+$  poll-responder-yield  [diff=(unit state-diff) new=persistent]
--
::  lib core
|%
++  report-parser-fail
  |=  [=hair txt=cord]
  ^-  tang
  =*  lyn  p.hair
  =*  col  q.hair
  :~  leaf+"syntax error at [{<lyn>} {<col>}] in source"
  ::
    =/  =wain  (to-wain:format txt)
    ?:  (gth lyn (lent wain))
      '<<end of file>>'
    (snag (dec lyn) wain)
  ::
    leaf+(runt [(dec col) '-'] "^")
  ==
::
++  parse-request-product
  |=  req=cord
  ^-  (unit strand-id)
  ?:  =('' req)  ~
  `(rash req stap)
::
++  render-tang
  |=  =tang
  ^-  tape
  %-  zing
  ^-  (list tape)
  %-  zing
  %+  join  `(list tape)`~["\0a"]
  ^-  (list (list tape))
  (turn tang (cury wash 0 80))
::
++  render-source-cord
  |=  src=strand-source
  ^-  cord
  ?-    -.src
      %hoon
    ?:  =(~ deps.src)  txt.src
    %+  rap  3
    ^-  (list cord)
    %-  zing
    ^-  (list (list cord))
    :~  """
        ##  {(render-deps-tape deps.src)}
        ::\0a
        """
        ~[txt.src]
    ==
  ::
      %js  txt.src
  ==
::
++  render-deps-tape
  |=  deps=(list (pair term path))
  ^-  tape
  ?~  deps  ""
  |-  ^-  tape
  ?~  t.deps  "{(trip p.i.deps)}={(trip (spat q.i.deps))}"
  "{(trip p.i.deps)}={(trip (spat q.i.deps))}, {$(deps t.deps)}"
::
++  get-state-diff
  |=  [old=persistent new=persistent]
  ^-  (unit state-diff)
  ?:  =(old new)  ~
  ?>  =(version.old version.new)
  ?>  =(suspend-counter.old suspend-counter.new)
  =/  =strand-diff  (get-strand-diff strands.old strands.new)
  =/  =product-diff  (get-product-diff products.old products.new)
  ?:  &(?=(~ strand-diff) ?=(~ product-diff))
    ~
  `[strand-diff product-diff]
::
++  get-strand-diff
  |=  [old=(map strand-id strand-state) new=(map strand-id strand-state)]
  ^-  strand-diff
  =/  gone  (~(dif by old) new)
  =/  plus  (~(dif by new) old)
  =/  edit  ~(key by (~(int by old) new))
  =/  out=strand-diff
    %-  ~(rep in edit)
    |=  [k=strand-id acc=strand-diff]
    =/  old  (~(got by old) k)
    =/  new  (~(got by new) k)
    (~(put by acc) k %edit (get-strand-state-diff old new))
  ::
  %.  `strand-diff`(~(run by plus) (lead %new))
  %~  uni  by
  %.  `strand-diff`(~(run by gone) _[%del ~])
  %~  uni  by
  out
::
++  get-strand-state-diff
  |=  [old=strand-state new=strand-state]
  ^-  strand-state-diff
  =-  ?>  ?=(^ -)  -
  ^-  strand-state-diff
  =|  out=strand-state-diff
  =*  put  ~(put in out)
  =?  out  !=(src.old src.new)                (put %source src.new)
  =?  out  !=(params.old params.new)          (put %params params.new)
  =?  out  !=(is-running.old is-running.new)  (put %running is-running.new)
  out
::
++  get-product-diff
  =*  products  ,(map strand-id (pair (each vase tang) time))
  |=  [old=products new=products]
  ^-  product-diff
  =/  sub  (~(dif by old) new)
  =/  out=product-diff  (~(run by sub) _[%del ~])
  %-  ~(rep by new)
  |=  [[k=strand-id v=(pair (each vase tang) time)] acc=_out]
  ^+  acc
  =/  old=(unit (pair (each vase tang) time))  (~(get by old) k)
  ?:  |(?=(~ old) =(u.old v))  acc
  (~(put by acc) k %new v)
::
++  enjs
  =,  enjs:format
  |%
  ++  state
    |=  s=persistent
    ^-  json
    %-  pairs
    :~  strands+(pairs (turn ~(tap by strands.s) strand-state-kv))
        products+(pairs (turn ~(tap by products.s) product-kv))
    ==
  ::
  ++  strand-state-kv
    |=  [k=strand-id v=^strand-state]
    ^-  [@t json]
    [(spat k) (strand-state v)]
  ::
  ++  product-kv
    |=  [k=strand-id v=(pair (each vase tang) @da)]
    ^-  [@t json]
    :-  (spat k)
    (urtime-sec q.v)
  ::
  ++  diff
    |=  d=state-diff
    ^-  json
    %-  pairs
    :~  strands+a+(turn ~(tap by strands.d) strand-diff-kv)
        products+a+(turn ~(tap by products.d) product-diff-kv)
    ==
  ::
  ++  strand-diff-kv
    |=  [k=strand-id v=strand-diff-v]
    ^-  json
    %-  pairs
    :~
      id+s+(spat k)
    ::
      :-  %diff
      %-  frond
      :-  -.v
      ^-  json
      ?-  -.v
        %del   ~
        %new   (strand-state s.v)
        %edit  (strand-state-diff s.v)
      ==
    ==
  ::
  ++  product-diff-kv
    |=  [k=strand-id v=product-diff-v]
    ^-  json
    %-  pairs
    :~
      id+s+(spat k)
    ::
      :-  %diff
      %-  frond
      :-  -.v
      ^-  json
      ?-  -.v
        %del  ~
        %new  (urtime-sec q.v)
      ==
    ==
  ::
  ++  urtime-sec
    |=  time=@da
    ^-  json
    :-  %s
    (scot %da (dis time seconds-mask))
  ::
  ++  urgap-sec
    |=  gap=@dr
    ^-  json
    :-  %s
    (scot %dr (dis gap seconds-mask))
  ::
  ++  jall
    |=  a=(unit json)
    ^-  json
    ?~  a  ~
    u.a
  ::
  ++  strand-state
    |=  s=^strand-state
    ^-  json
    %-  pairs
    :~  source+s+(render-source-cord src.s)
        params+(strand-params params.s)
        running+b+is-running.s
        fires+(jall (bind fires-at.s urtime-sec))
    ==
  ::
  ++  strand-params
    |=  p=^strand-params
    ^-  json
    %-  pairs
    :~  'run_every'^(jall (bind run-every.p urgap-sec))
    ==
  ::
  ++  strand-state-diff
    |=  d=^strand-state-diff
    ^-  json
    %-  pairs
    (turn ~(tap in d) strand-state-diff-v)
  ::
  ++  strand-state-diff-v
    |=  d=^strand-state-diff-v
    ^-  [@t json]
    :-  -.d
    ^-  json
    ?-  -.d
      %source   s+(render-source-cord src.d)
      %params   (strand-params p.d)
      %running  b+flag.d
    ==
  --
++  set-running-flag
  |=  =flag
  ^-  $-(strand-state strand-state)
  |=  strand-state
  ^-  strand-state
  +<(is-running flag)
::
++  inc-params-counter  |=(strand-state +<(params-counter +(params-counter)))
++  set-fires-at
  |=  new=(unit time)
  ^-  $-(strand-state strand-state)
  |=  strand-state
  ^-  strand-state
  +<(fires-at new)
::
++  comp
  |=  [a=$-(strand-state strand-state) b=$-(strand-state strand-state)]
  ^-  $-(strand-state strand-state)
  |=  strand-state
  (a (b +<))
--
::
%+  verb  |
%-  agent:dbug
=|  =state
=*  persistent-state  -.state
=*  strand  strand:spider
^-  agent:gall
=<
  |_  =bowl:gall
  +*  this     .
      def  ~(. (default-agent this %|) bowl)
      hc   ~(. helper-core bowl)
  ::
  ++  on-init
    =+  .^  tree=(list (list tid:spider))
          %gx
          /(scot %p our.bowl)/spider/(scot %da now.bowl)/tree/noun
        ==
    ::
    :_  this
    ^-  (list card)
    :-  [%pass /eyre/connect %arvo %e %connect `/apps/[name-term] name-term]
    :-  [%pass /cleanup/0 %arvo %b %wait (add now.bowl ~h1)]
    ^-  (list card)
    %+  murn  tree
    |=  id=(list tid:spider)
    ^-  (unit card)
    ?.  ?=([tid:spider ~] id)  ~
    ?.  =(name-term (cut 3 [0 (met 3 name-term)] i.id))
      ~
    ~&  ['stopping script from previous installation: ' i.id]
    `(poke-spider:hc /cancel %spider-stop !>([i.id |]))
  ::
  ++  on-save   !>(-.state)
  ++  on-load
    |=  old=vase
    ^-  [(list card) _this]
    =/  ver-state  !<(versioned-persistent-state old)
    =.  -.state  ver-state
    ::  stop all old threads on load
    ::  we do that by hand and not by poking ourselves with %stop
    ::  because we want to create the stop cards before the imminent
    ::  suspend counter increment
    ::
    =^  cards-stop=(list card)  strands.state
      |-  ^-  (quip card _strands.state)
      ?~  strands.state  [~ ~]
      =/  n-cards=(list card)
        ?.  is-running.q.n.strands.state  ~
        ~[(emit-spider-stop:hc p.n.strands.state)]
      ::
      =^  l-cards  l.strands.state  $(strands.state l.strands.state)
      =^  r-cards  r.strands.state  $(strands.state r.strands.state)
      [(zing n-cards l-cards r-cards ~) strands.state(is-running.q.n |)]
    ::  invalidate old timers and routines
    ::
    =.  suspend-counter.state  +(suspend-counter.state)
    ::  run all threads that were waiting for a timer
    ::
    =/  cards-run=(list card)
      %-  ~(rep by strands.state)
      |=  [[k=strand-id v=strand-state] acc=(list card)]
      ^+  acc
      ?~  fires-at.v  acc
      ?:  (lte u.fires-at.v now.bowl)  [(emit-us-run:hc k) acc]
      [(emit-us-run-defer:hc k u.fires-at.v) acc]
    ::
    :_  this
    =/  wir  /cleanup/(scot %ud suspend-counter.state)
    :-  [%pass wir %arvo %b %wait (add now.bowl ~h1)]
    (weld cards-stop cards-run)
  ::
  ++  on-poke
    |=  [=mark =vase]
    ^-  [(list card) _this]
    =^  cards  state
      ?+    mark  (on-poke:def mark vase)
          %handle-http-request
        (handle-http:hc !<([@ta =inbound-request:eyre] vase))
      ::
          %orchestra-action
        ?>  =(src.bowl our.bowl)
        (take-action:hc !<(action vase))
      ==
    ::
    [[send-fact-state:hc cards] this]
  ::
  ++  on-peek
    |=  path=(pole knot)
    ^-  (unit (unit cage))
    ?+    path  (on-peek:def path)
      [%x %strands ~]          [~ ~ [%noun !>(strands.state)]]
      [%x %products ~]         [~ ~ [%noun !>(products.state)]]
      [%x %suspend-counter ~]  [~ ~ [%noun !>(suspend-counter.state)]]
    ==
  ::
  ++  on-watch
    |=  path=(pole knot)
    ^-  (quip card _this)
    =^  cards  state
      ?+    path  (on-watch:def path)
          [%http-response *]
        `state
      ::
          [%state-updates ~]
        ?>  =(our.bowl src.bowl)
        `state
      ==
    [cards this]
  ::
  ++  on-arvo
    |=  [wire=(pole knot) =sign-arvo]
    ^-  (quip card _this)
    =^  cards=(list card)  this
      ?+    wire  (on-arvo:def wire sign-arvo)
          [%eyre %connect ~]  `this
      ::
          [%build-strand suspend=@ta id=*]
        =/  id  id.wire
        =/  suspend=@ud  (slav %ud suspend.wire)
        ::
        ?.  =(suspend suspend-counter.state)
          `this
        ?>  ?=([%khan %arow *] sign-arvo)
        ?~  strand=(~(get by strands.state) id)
          `this
        ?:  ?=(%| -.p.sign-arvo)
          =.  products.state
            %+  ~(put by products.state)  id
            [|+['build thread failed' tang.p.p.sign-arvo] now.bowl]
          ::
          =.  strands.state
            (strand-lens:hc id (comp (set-running-flag |) (set-fires-at ~)))
          ::
          `this
        =+  !<(res=(each vase tang) q.p.p.sign-arvo)
        ?:  ?=(%| -.res)
          =.  products.state
            (~(put by products.state) id |+['build faiked' p.res] now.bowl)
          ::
          =.  strands.state
            (strand-lens:hc id (comp (set-running-flag |) (set-fires-at ~)))
          ::
          `this
        =/  tid  (make-tid:hc id)
        =/  args=inline-args:spider  [~ `tid bek:hc !<(shed:khan p.res)]
        =/  wir-watch
          [ %run-watch
            (scot %ud suspend-counter.state)
            id
          ]
        ::
        =/  wir-poke
          [ %run-poke
            (scot %ud suspend-counter.state)
            id
          ]
        ::
        =/  cards
          :~  (watch-spider:hc wir-watch /thread-result/[tid])
              (poke-spider:hc wir-poke+id spider-inline+!>(args))
          ==
        ::
        =/  params  params.u.strand
        =^  cards  this
          ?~  run-every.params
            =.  strands.state  (strand-lens:hc id (set-fires-at ~))
            [cards this]
          =/  wait-for=@dr  u.run-every.params
          =/  fires-at=time  (add now.bowl wait-for)
          =.  strands.state  (strand-lens:hc id (set-fires-at `fires-at))
          :_  this
          :_  cards
          =;  wir  [%pass wir %arvo %b %wait fires-at]
          [ %timer
            (scot %ud suspend-counter.state)
            (scot %ud params-counter.u.strand)
            (scot %uv hash.u.strand)
            id
          ]
        ::
        [cards this]
      ::
          [%timer suspend=@ta params=@ta hash=@ta id=*]
        =/  suspend-counter  (slav %ud suspend.wire)
        =/  params-counter   (slav %ud params.wire)
        =/  hash             (slav %uv hash.wire)
        =/  id  id.wire
        ::
        ?>  ?=([%behn %wake *] sign-arvo)
        ?.  =(suspend-counter suspend-counter.state)
          `this
        ?~  strand=(~(get by strands.state) id)
          `this
        ?.  =(params-counter params-counter.u.strand)
          `this
        ?.  =(hash hash.u.strand)
          `this
        %-  ?~  error.sign-arvo  same  (slog u.error.sign-arvo)
        =^  cards=(list card)  this
          ?.  is-running.u.strand
            :_  this  :_  ~
            (poke-self:hc /restart %run id)
          ?~  run-every.params.u.strand
            =.  strands.state  (strand-lens:hc id (set-fires-at ~))
            `this
          =/  wait-for=@dr  u.run-every.params.u.strand
          =/  fires-at=time  (add now.bowl wait-for)
          =.  strands.state  (strand-lens:hc id (set-fires-at `fires-at))
          :_  this  :_  ~
          [%pass wire %arvo %b %wait fires-at]
        ::
        [cards this]
      ::
          [%poll-responder suspend=@ta eyre-id=@ta stamp=@ta ~]
        =/  suspend=@ud  (slav %ud suspend.wire)
        =/  stamp=@da    (slav %da stamp.wire)
        ::
        ?.  =(suspend suspend-counter.state)
          `this
        ?>  ?=([%khan %arow *] sign-arvo)
        =^  response=json  this
          =,  enjs:format
          ?:  ?=(%| -.p.sign-arvo)
            ~&  %polling-responder-failure
            =.  polling.state
              (~(put by polling.state) stamp |+persistent-state)
            ::
            :_  this
            (frond %full (state:enjs persistent-state))
          =+  !<(yil=poll-responder-yield q.p.p.sign-arvo)
          =.  polling.state  (~(put by polling.state) stamp |+new.yil)
          ?~  diff.yil  [~ this]
          :_  this
          (diff:enjs u.diff.yil)
        ::
        :_  this
        (response:schooner eyre-id.wire 200 ~ json+response)
      ::
          [%cleanup suspend=@ta ~]
        =/  suspend-counter  (slav %ud suspend.wire)
        ::
        ?.  =(suspend-counter suspend-counter.state)
          `this
        =.  polling.state
          %-  ~(rep by polling.state)
          |=  [[k=time v=[stale=? s=state-0]] acc=polling]
          ^+  acc
          ?:  stale.v  acc
          (~(put by acc) k v(stale &))
        ::
        :_  this  :_  ~
        [%pass wire %arvo %b %wait (add now.bowl ~h1)]
      ==
    ::
    [[send-fact-state:hc cards] this]
  ::
  ++  on-agent
    |=  [wire=(pole knot) =sign]
    ^-  (quip card _this)
    =^  cards  this
      ?+    wire  (on-agent:def wire sign)
          [%run-watch suspend=@ta id=*]
        =/  suspend-counter  (slav %ud suspend.wire)
        =/  id  id.wire
        ?+    -.sign  (on-agent:def wire sign)
            %fact
          ?.  =(suspend-counter suspend-counter.state)
            `this
          ?.  (~(has by strands.state) id)
            `this
          =.  strands.state  (strand-lens:hc id (set-running-flag |))
          ?+    p.cage.sign  (on-agent:def wire sign)
              %thread-fail
            =+  !<(res=(pair term tang) q.cage.sign)
            =.  products.state  (~(put by products.state) id |+q.res now.bowl)
            `this
          ::
              %thread-done
            =.  products.state
              (~(put by products.state) id &+q.cage.sign now.bowl)
            ::
            `this
          ==
        ==
      ==
    ::
    [[send-fact-state:hc cards] this]
  ::
  ++  on-fail   on-fail:def
  ++  on-leave  on-leave:def
  --
|%
++  helper-core
  |_  =bowl:gall
  +*  this  .
      def   ~(. (default-agent this %|) bowl)
  ::
  ++  strand-lens
    |=  [id=strand-id gate=$-(strand-state strand-state)]
    ^+  strands.state
    (~(jab by strands.state) id gate)
  ::
  ++  strand-lens-opt
    |=  [id=strand-id gate=$-(strand-state strand-state)]
    ^+  strands.state
    ?.  (~(has by strands.state) id)  strands.state
    (~(jab by strands.state) id gate)
  ::
  ++  handle-http
    |=  [eyre-id=@ta =inbound-request:eyre]
    ^-  (quip card _state)
    =/  ,request-line:server
      (parse-request-line:server url.request.inbound-request)
    ::
    =+  send=(cury response:schooner eyre-id)
    ?+    method.request.inbound-request  [(send [405 ~ [%stock ~]]) state]
        ?(%'GET' %'POST')
      =/  site=(pole knot)  site
      ?+    site  [(send [404 ~ [%plain "404 - Not Found"]]) state]
          ?([%apps name-mold %$ ~] [%'~' name-mold ~])
        :_  state
        (send 302 ~ [%redirect our-url])
      ::
          [%apps name-mold ~]
        ?.  authenticated.inbound-request
          :_  state
          %-  send
          [302 ~ [%login-redirect our-url]]
        =/  time  now.bowl
        [(send [200 ~ manx+(form time)]) state]
      ::
          [%apps name-mold %poll time=@ta ~]
        ?.  authenticated.inbound-request  `state
        =/  stamp=time  (slav %da time.site)
        =^  jon=(unit json)  state
          ?~  stash=(~(get by polling.state) stamp)
            ~&  %first-poll
            =.  polling.state
              (~(put by polling.state) stamp |+persistent-state)
            ::
            :_  state
            `(frond:enjs:format %full (state:enjs persistent-state))
          :_  state
          ?~  diff=(get-state-diff s.u.stash persistent-state)  ~
          `(diff:enjs u.diff)
        ::
        :_  state
        ?^  jon  (send [200 ~ json+u.jon])
        (dispatch-poll-responder eyre-id persistent-state stamp)
      ::
          [%apps name-mold %product ~]
        ?.  authenticated.inbound-request  `state
        ?~  body.request.inbound-request   `state
        =/  id=(unit strand-id)
          (parse-request-product q.u.body.request.inbound-request)
        ::
        =;  jon=json  [(send [200 ~ json+jon]) state]
        ?~  id  ~
        ?~  pro=(~(get by products.state) u.id)  ~  ::  null
        =/  rand  (~(get by strands.state) u.id)
        =-  [%o ['u' s+-] ~ ~]                      ::  {u: string}
        %-  crip
        %+  weld  "{(scow %da (dis q.u.pro seconds-mask))}\0a"
        ^-  tape
        ?:  |(?=(~ rand) ?=(%hoon -.src.u.rand))
          ?:  ?=(%| -.p.u.pro)
            %+  weld  "Error:\0a"
            (render-tang p.p.u.pro)
          %+  weld  "Success:\0a"
          ^-  tape
          (zing (join "\0a" (wash 0^80 (cain p.p.u.pro))))
        ::  (-.src.u.rand == %js)
        ::
        ?:  ?=(%| -.p.u.pro)
          %+  weld  "Thread error:\0a"
          (render-tang p.p.u.pro)
        =/  js-res
          %-  mole  |.
          !<  [%0 out=(each cord (pair cord cord))]
          p.p.u.pro
        ::
        ?~  js-res  "Unrecognized JS result"
        =/  out  out.u.js-res
        ?-    -.out
            %&
          "Success:\0a{(trip p.out)}"
        ::
            %|
          "JS error:\0a{(trip p.p.out)}\0a{(trip q.p.out)}"
        ==
      ==
    ==
  ::
  ++  dispatch-poll-responder
    |=  [eyre-id=@ta stash=persistent stamp=@da]
    ^-  (list card)
    :_  ~
    =/  wir=wire
      :~  %poll-responder
          (scot %ud suspend-counter.state)
          eyre-id
          (scot %da stamp)
      ==
    ::
    (send-shed wir (poll-responder stash))
  ::
  ++  poll-responder
    |=  stash=persistent
    ^-  shed:khan
    =/  m  (strand vase)
    ;<  res=poll-responder-yield  bind:m
      =/  m  (strand poll-responder-yield)
      ^-  form:m
      =/  wir=wire  /state-updates
      ;<  ~        bind:m
        (watch-our:sio wir name-term wir)
      ::
      ;<  now=@da  bind:m  get-time:sio
      =/  till=@da  (add now ~s15)
      ;<  ~  bind:m  (send-wait:sio till)
      |=  tin=strand-input:rand
      =*  this-strand  .
      ?+    in.tin  `[%skip ~]
          ~
        `[%wait ~]
      ::
          [~ %sign [%wait @ ~] %behn %wake *]
        ?.  =(till (slaw %da i.t.wire.u.in.tin))
          ~&  >>  [till (slaw %da i.t.wire.u.in.tin)]
          `[%skip ~]
        ~?  >>>  ?=(^ error.sign-arvo.u.in.tin)  u.error.sign-arvo.u.in.tin
        `[%done ~ stash]
      ::
          [~ %agent * %fact *]
        ?.  =(watch+wir wire.u.in.tin)
          ~&  >>  wire.u.in.tin
          `[%skip ~]
        =/  vax=vase  q.cage.sign.u.in.tin
        =+  !<(new=persistent vax)
        ?~  diff=(get-state-diff stash new)
          `[%cont this-strand(stash new)]
        `[%done diff new]
      ==
    ::
    (pure:m !>(res))
  ++  form
    |=  stamp=time
    ^-  manx
    stub
  ::
  ++  poke-spider
    |=  [=wire =cage]
    ^-  card
    [%pass wire %agent [our.bowl %spider] %poke cage]
  ::
  ++  watch-spider
    |=  [=wire =path]
    ^-  card
    [%pass wire %agent [our.bowl %spider] %watch path]
  ::
  ++  send-shed
    |=  [=path =shed:khan]
    ^-  card
    [%pass path %arvo %k %lard %base shed]
  ::
  ++  poke-self
    |=  [=wire act=action]
    ^-  card
    [%pass wire %agent [our.bowl name-term] %poke orchestra-action+!>(act)]
  ::
  ++  take-action
    |=  act=action
    ^-  (quip card _state)
    ?-    -.act
        %new
      ?:  (~(has by strands.state) id.act)
        ~&  >>  %orchestra-id-already-present
        `state
      =/  hash=@uv  (shax (jam %orchestra eny.bowl act))
      =,  act
      =.  strands.state  (~(put by strands.state) id [src params & 0 ~ hash])
      `state
    ::
        %del
      =.  products.state  (~(del by products.state) id.act)
      :_  state(strands (~(del by strands.state) id.act))
      ~[(emit-spider-stop id.act)]
    ::
        %upd
      ?~  rand=(~(get by strands.state) id.act)
        ~&  >>  %orchestra-id-not-present
        `state
      =.  params.u.rand  params.act
      =.  params-counter.u.rand  +(params-counter.u.rand)
      =.  strands.state  (~(put by strands.state) id.act u.rand)
      =.  strands.state  (strand-lens id.act (set-fires-at ~))
      `state
    ::
        %wipe
      `state(products ~)
    ::
        %run
      ?~  rand=(~(get by strands.state) id.act)
        ~&  >>  %orchestra-id-not-present
        `state
      ?:  is-running.u.rand
        ~&  >>  %orchestra-id-already-running
        `state
      =.  strands.state
        %+  strand-lens  id.act
        :(comp (set-running-flag &) (set-fires-at ~) inc-params-counter)
      ::
      :_  state
      ~[(emit-build id.act src.u.rand)]
    ::
        %run-defer
      ?~  rand=(~(get by strands.state) id.act)
        ~&  >>  %orchestra-id-not-present
        `state
      =.  strands.state
        (strand-lens id.act (comp inc-params-counter (set-fires-at `at.act)))
      ::
      :_  state  :_  ~
      =;  wir  [%pass wir %arvo %b %wait at.act]
      [ %timer
        (scot %ud suspend-counter.state)
        (scot %ud params-counter.u.rand)
        (scot %uv hash.u.rand)
        id.act
      ]
    ::
        %clear
      `state(products (~(del by products.state) id.act))
    ::
        %stop
      ?~  rand=(~(get by strands.state) id.act)
        ~&  >>  %orchestra-id-not-present
        `state
      =.  strands.state  (strand-lens id.act (set-running-flag |))
      :_  state
      ~[(emit-spider-stop id.act)]
    ::
    ==
  ::
  ++  emit-spider-stop
    |=  id=strand-id
    ^-  card
    (poke-spider /cancel %spider-stop !>([(make-tid id) |]))
  ::
  ++  emit-build
    |=  [id=strand-id src=strand-source]
    ^-  card
    (send-shed build-strand+id (build-src id src))
  ::
  ++  emit-us-run
    |=  id=strand-id
    (poke-self /run %run id)
  ::
  ++  emit-us-stop
    |=  id=strand-id
    (poke-self /stop %stop id)
  ::
  ++  emit-us-run-defer
    |=  [id=strand-id at=time]
    (poke-self /run %run-defer id at)
  ::
  ++  build-src
    |=  [id=strand-id src=strand-source]
    ^-  shed:khan
    =/  m  (strand vase)
    ;<  res=(each vase tang)  bind:m
      =/  m  (strand (each vase tang))
      ^-  form:m
      ?-    -.src
          %hoon
        =/  build=vase  !>(..zuse)
        =/  start-line=@ud
          =/  n=@ud  1
          =?  n  ?=(^ deps.src)  (add 2 n)
          =/  run-every  run-every:params:(~(got by strands.state) id)
          =?  n  ?=(^ run-every)  (add 2 n)
          n
        ::
        |-  ^-  form:m
        ?^  deps.src
          =*  dep  i.deps.src
          ;<  vax=(unit vase)  bind:m
            =/  bek=beak  [our.bowl -.q.dep da+now.bowl]
            (build-file:sio bek +.q.dep)
          ::
          ?~  vax
            %-  pure:m
            |+~[leaf+"dependency build failed: desk {<-.q.dep>}, path {<+.q.dep>}"]
          =.  p.u.vax  [%face p.dep p.u.vax]
          $(deps.src t.deps.src, build (slop u.vax build))
        %-  pure:m
        ^-  (each vase tang)
        =/  [=hair res=(unit [=hoon =nail])]
          %.  [[start-line 1] (trip txt.src)]
          %-  full
          %+  ifix  [gay gay]
          tall:(vang & [name-term %hoon-thread id])
        ::
        ?~  res  |+(report-parser-fail hair txt.src)
        =/  pro
          %-  ~(mule vi |)
          =>  [build=build hoon=hoon.u.res ..slap]
          |.  ~>  %memo./user
          (slap build hoon)
        ::
        ?:  ?=(%| -.pro)  pro(p ['source build failed' p.pro])
        =/  vax=vase  p.pro
        ?.  (~(nest ut -:!>(*shed:khan)) | -.vax)
          |+~['nest failed: not a shed']
        &+vax
      ::
          %js  (pure:m &+!>(`shed:khan`(thread-builder-js txt.src)))
      ==
    ::
    (pure:m !>(res))
  ::
  ++  send-fact-state
    ^-  card
    [%give %fact ~[/state-updates] %noun !>(persistent-state)]
  ::
  ++  bek  [our.bowl %base da+now.bowl]
  ++  make-tid
    |=  id=strand-id
    ^-  tid:spider
    =/  txt=tape  (trip (spat id))
    =.  txt  (turn txt |=(=char ?:(=('/' char) '-' char)))
    %:  rap  3
      'orchestra-'  (scot %ud version.state)
      '-'  (scot %ud suspend-counter.state)
      txt
    ==
  --
--