/-  *orchestra, spider
/+  dbug, default-agent, verb, server, schooner
/+  sio=strandio
/+  thread-builder-js
=*  stub  ~|(%stub !!)
=*  name-term  %orchestra
=*  name-mold  $orchestra
=/  our-url    (cat 3 '/apps/' name-term)
=/  seconds-mask  (mix (not 7 1 0) (not 6 1 0))
=/  polling-timeout=@dr  ~s20
|%
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
+$  poll-payload
  $%  [%diff d=state-diff]
      [%message m=message]
  ==
::
+$  poll-responder-yield  [load=(unit poll-payload) new=persistent]
::
+$  request-to-validate
  $%  [%action a=action-to-validate]
      [%read r=read]  ::  XX use http scry?
  ==
::
+$  request
  $%  [%action a=action]
      [%read r=read]  ::  XX use http scry?
  ==
::
+$  request-error  (each request tang)
+$  read
  $%  [%product id=strand-id]
  ==
::
+$  action-to-validate
  $%  $>(?(%del %wipe %run %clear %stop) action)
      [%new id-txt=cord lang=cord txt=cord]
      [%upd id=strand-id txt=cord]
  ==
--
::  lib core
|%
++  defer-shed
  |=  =shed:khan
  ^-  shed:khan
  =/  m  (strand:rand vase)
  ;<  ~  bind:m  (sleep:sio `@`2)
  shed
::
++  send-wait-prefix
  |=  [until=@da pre=wire]
  =/  m  (strand:rand ,~)
  ^-  form:m
  %-  send-raw-card:sio
  [%pass (snoc pre (scot %da until)) %arvo %b %wait until]
::
++  send-rest-prefix
  |=  [until=@da pre=wire]
  =/  m  (strand:rand ,~)
  ^-  form:m
  %-  send-raw-card:sio
  [%pass (snoc pre (scot %da until)) %arvo %b %rest until]
::
++  take-wake-prefix
  |=  [until=@da pre=wire]
  =/  m  (strand:rand ,~)
  ^-  form:m
  |=  tin=strand-input:strand:rand
  ?+    in.tin  `[%skip ~]
      ~  `[%wait ~]
  ::
      [~ %sign * %behn %wake *]
    =/  wir=wire  (snoc pre (scot %da until))
    ?.  =(wire.u.in.tin wir)
      `[%skip ~]
    ?~  error.sign-arvo.u.in.tin
      `[%done ~]
    `[%fail %timer-error u.error.sign-arvo.u.in.tin]
  ==
::
++  finally-do
  |*  a=mold
  =/  m1  (strand:rand a)
  =/  m2  (strand:rand *)
  |=  [z=form:m2 r=form:m1]
  ;<  out=a  bind:m1  r
  ;<  *      bind:m1  z
  (pure:m1 out)
::
++  rand-map
  |*  [a=mold b=mold]
  =/  m1  (strand:rand a)
  =/  m2  (strand:rand b)
  |=  [gat=$-(a b) r=form:m1]
  ^-  form:m2
  ;<  p=a  bind:m2  r
  (pure:m2 (gat p))
::
++  apply-rule
  |*  m=mold
  |=  [bus=$-(nail (like m)) txt=cord fail=cord]
  ^-  (each m tang)
  =/  [=hair res=(unit [out=m =nail])]  (bus [1 1] (trip txt))
  ?~  res  |+[fail (report-parser-fail hair txt)]
  &+out.u.res
::
++  biff-each
  |*  m1=mold
  |*  [a=(each m1 tang) b=$-(m1 (each * tang))]
  ?:  ?=(%| -.a)  a
  (b p.a)
::
++  validate-request
  |=  r=request-to-validate
  ^-  request-error
  ?-    -.r
      %read  &+r
  ::
      %action
    ?-    -.a.r
        ?(%del %wipe %run %clear %stop)  &+r
    ::
        %new
      ;<  id=strand-id  biff-each
        =/  e  'syntax error in thread name:'
        ((apply-rule strand-id) stap id-txt.a.r e)
      ::
      ;<  src-param=[strand-source strand-params]  biff-each
        =/  e  'syntax error in thread name:'
        =/  rule  (source-params-rule lang.a.r)
        ((apply-rule (pair strand-source strand-params)) rule txt.a.r e)
      ::
      &+[%action %new id src-param]
    ::
        %upd
      ;<  params=strand-params  biff-each
        =/  e  'syntax error in script parameters:'
        =/  rule  (full (punt dr-rule))
        ((apply-rule strand-params) rule txt.a.r e)
      ::
      &+[%action %upd id.a.r params]
    ==
  ==
::
++  apply-tail
  |*  g=gate
  |*  sam=^
  [-.sam (g +.sam)]
::
++  await-earliest
  |*  a=mold
  =/  m  (strand:rand ,a)
  |=  l=(list form:m)
  ^-  form:m
  |=  tin=strand-input:rand
  ?~  in.tin  `[%wait ~]
  =/  o=output:m  `[%skip ~]
  |-  ^-  output:m
  ?~  l  o
  =/  o1  (i.l tin)
  ?.  ?=(%skip -.next.o1)
    [(weld cards.o cards.o1) next.o1]
  $(l t.l, cards.o (weld cards.o cards.o1))
::
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
++  render-vase
  |=  =vase
  ^-  tape
  %-  zing
  %+  join  "\0a"
  (wash 0^80 (cain vase))
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
  ?:  =(old new)  ~
  =/  gone  (~(dif by old) new)
  =/  plus  (~(dif by new) old)
  =/  edit  ~(key by (~(int by old) new))
  =/  out=strand-diff
    %-  ~(rep in edit)
    |=  [k=strand-id acc=strand-diff]
    =/  old  (~(got by old) k)
    =/  new  (~(got by new) k)
    =/  d=strand-state-diff  (get-strand-state-diff old new)
    ?:  =(~ d)  acc
    (~(put by acc) k %edit d)
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
  ?:  =(old new)  ~
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
  ?:  =(old new)  ~
  =/  sub  (~(dif by old) new)
  =/  out=product-diff  (~(run by sub) _[%del ~])
  %-  ~(rep by new)
  |=  [[k=strand-id v=(pair (each vase tang) time)] acc=_out]
  ^+  acc
  =/  old=(unit (pair (each vase tang) time))  (~(get by old) k)
  ?:  &(?=(^ old) =(u.old v))  acc
  (~(put by acc) k %new v)
::
++  enjs
  =,  enjs:format
  |%
  ++  message
    |=  m=^message
    ^-  json
    %-  frond
    :-  -.m
    ?-  -.m
      %error  (pairs why+s+why.m what+s+(crip (render-tang what.m)) ~)
    ==
  ::
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
    (product v)
  ::
  ++  product
    |=  p=(pair (each vase tang) @da)
    ^-  json
    %-  pairs
    :~  when+(urtime-sec q.p)
        how+[%b -.p.p]
    ==
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
        lang+s+-.src.s
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
::
++  dejs
  =,  dejs:format
  |%
  ++  request-to-validate
    ^-  $-(json ^request-to-validate)
    %-  of
    :~  action+action-to-validate
        read+read
    ==
  ::
  ++  read
    ^-  $-(json ^read)
    %-  of
    :~  product+strand-id
    ==
  ::
  ++  action-to-validate
    ^-  $-(json ^action-to-validate)
    %-  of
    :~  new+(ot id+so lang+so txt+so ~)
        upd+(ot id+strand-id params+so ~)
        del+strand-id
        wipe+ul
        run+strand-id
        :: run-defer
        clear+strand-id
        stop+strand-id
    ==
  ::
  ++  strand-id  pa
  --
::
++  source-params-rule
  |=  lang=cord
  %+  cook  |=([strand-source strand-params] +<)
  %+  cook  |*(sam=* [+.sam -.sam])
  ;~  plug
    strand-params-rule
  ::
    %+  cook  |=(strand-source +<)
    ?+    lang  ~|(%weird-lang !!)
        %hoon
      %+  stag  %hoon
      ;~  plug
        deps-rule
        (cook crip (star next))
      ==
    ::
        %js
      %+  stag  %js
      (cook crip (star next))
    ==
  ==
::
++  strand-params-rule
  %+  cook  |=(strand-params +<)
  ;~  pose
    (stag ~ (ifix [gay gay] ;~(pfix (jest '@@') gap dr-rule)))
    (easy ~)
  ==
::
++  dr-rule
  ;~  pfix
    sig
  ::
    %-  sear
    :_  crub:so
    |=  d=dime
    ^-  (unit @dr)
    ?.  ?=(%dr p.d)  ~
    `q.d
  ==
::
++  deps-rule
  %+  cook  |=((list (pair term path)) +<)
  ;~  pose
    %+  ifix  [gay gay]
    %+  cook  |=((list (list (pair term path))) (zing +<))
    %+  most  gap
    %+  cook  |=((list (pair term path)) +<)
    ;~  pfix
      (jest '##')
      gap
      (most (jest ', ') ;~((glue tis) sym stap))
    ==
  ::
    (easy ~)
  ==
::
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
    =^  running=(list strand-id)  strands.state
      |-  ^-  (quip strand-id _strands.state)
      ?~  strands.state  [~ ~]
      =/  n=(list strand-id)
        ?.  is-running.q.n.strands.state  ~
        ~[p.n.strands.state]
      ::
      =^  l  l.strands.state  $(strands.state l.strands.state)
      =^  r  r.strands.state  $(strands.state r.strands.state)
      [(zing n l r ~) strands.state(is-running.q.n |)]
    ::
    =/  cards-stop=(list card)  (turn running emit-spider-stop:hc)
    ::  invalidate old timers and routines
    ::
    =.  suspend-counter.state  +(suspend-counter.state)
    ::  run all threads that were in the middle of running
    ::
    =/  cards-run-1=(list card)
      (turn running (curr emit-us-run-defer:hc (add now.bowl ~s1)))
    ::
    ::  run all threads that were waiting for a timer
    ::
    =/  cards-run-2=(list card)
      %-  ~(rep by strands.state)
      |=  [[k=strand-id v=strand-state] acc=(list card)]
      ^+  acc
      ?~  fires-at.v  acc
      ?:  (lte u.fires-at.v now.bowl)  [(emit-us-run-timer:hc k) acc]
      [(emit-us-run-defer:hc k u.fires-at.v) acc]
    ::
    :_  this
    =/  wir  /cleanup/(scot %ud suspend-counter.state)
    :-  [%pass wir %arvo %b %wait (add now.bowl ~h1)]
    (zing cards-stop cards-run-1 cards-run-2 ~)
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
            (~(put by products.state) id |+['build failed' p.res] now.bowl)
          ::
          =.  strands.state
            (strand-lens:hc id (comp (set-running-flag |) (set-fires-at ~)))
          ::
          `this
        =/  tid  (make-tid:hc id)
        =+  !<(=shed:khan p.res)
        =/  args=inline-args:spider  [~ `tid bek:hc (defer-shed shed)]
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
            (poke-self:hc /restart %run-timer id)
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
        =^  response=(unit json)  this
          =,  enjs:format
          ?:  ?=(%| -.p.sign-arvo)
            ~&  %polling-responder-failure
            =.  polling.state
              (~(put by polling.state) stamp |+persistent-state)
            ::
            :_  this
            `(frond %full (state:enjs persistent-state))
          =+  !<(yil=poll-responder-yield q.p.p.sign-arvo)
          =.  polling.state  (~(put by polling.state) stamp |+new.yil)
          :_  this
          ^-  (unit json)
          ?~  load.yil  ~
          ?-    -.u.load.yil
              %diff
            :: `(diff:enjs u.diff)
            ::  XX just send the whole state for now, it's not that big
            ::
            `(frond:enjs:format %full (state:enjs persistent-state))
          ::
              %message
            `(frond %message (message:enjs m.u.load.yil))
          ==
        ::
        :_  this
        ?~  response  (response:schooner eyre-id.wire 204 ~ none+~)
        (response:schooner eyre-id.wire 200 ~ json+u.response)
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
        :_  this
        ^-  (list card)
        =-  ?^  polling.state  -  [[%give %kick ~[/state-updates] ~] -]
        :_  ~
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
          ?~  rand=(~(get by strands.state) id)
            `this
          =.  strands.state  (strand-lens:hc id (set-running-flag |))
          ?+    p.cage.sign  (on-agent:def wire sign)
              %thread-fail
            =+  !<(res=(pair term tang) q.cage.sign)
            =/  tag=tang  ['thread stopped or crashed' q.res]
            =.  products.state  (~(put by products.state) id |+tag now.bowl)
            `this
          ::
              %thread-done
            =.  products.state
              %+  ~(put by products.state)  id
              :_  now.bowl
              ?:  ?=(%hoon -.src.u.rand)  &+q.cage.sign
              ::  %js
              ::
              =/  js-res
                %-  mole  |.
                !<  [%0 out=(each cord (pair cord cord))]
                q.cage.sign
              ::
              ?~  js-res  &+q.cage.sign
              ?:  ?=(%& -.out.u.js-res)  &+q.cage.sign
              |+~[p.p.out.u.js-res q.p.out.u.js-res]
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
        =/  stamp=time  (slav %ui time.site)
        =^  jon=(unit json)  state
          ?~  stash=(~(get by polling.state) stamp)
            =.  polling.state
              (~(put by polling.state) stamp |+persistent-state)
            ::
            :_  state
            `(frond:enjs:format %full (state:enjs persistent-state))
          ?~  diff=(get-state-diff s.u.stash persistent-state)  [~ state]
          :: `(diff:enjs u.diff)
          ::  XX just send the whole state for now, it's not that big
          ::
          =.  polling.state
            (~(put by polling.state) stamp |+persistent-state)
          ::
          :_  state
          `(frond:enjs:format %full (state:enjs persistent-state))
        ::
        :_  state
        ?^  jon  (send [200 ~ json+u.jon])
        (dispatch-poll-responder eyre-id persistent-state stamp)
      ::
          [%apps name-mold %api ~]
        ?.  authenticated.inbound-request  `state
        ?~  body.request.inbound-request   `state
        =/  jin=json  (need (de:json:html q.u.body.request.inbound-request))
        =/  rev=request-to-validate  (request-to-validate:dejs jin)
        =/  rer=request-error  (validate-request rev)
        ?:  ?=(%| -.rer)
          =/  jon=json
            %+  frond:enjs:format  %error
            s+(crip ['Argument error:\0a' (render-tang p.rer)])
          ::
          [(send [200 ~ json+jon]) state]
        =/  req=request  p.rer
        ?-    -.req
            %action
          =^  cards=(list card)  state  (take-action a.req)
          [(weld cards (send [200 ~ json+~])) state]
        ::
            %read
          =/  jon=json  (handle-read-http r.req)
          [(send [200 ~ json+jon]) state]
        ==
      ==
    ==
  ::
  ++  handle-read-http
    |=  r=read
    ^-  json
    ?-    -.r
        %product
      ?~  pro=(~(get by products.state) id.r)  ~  ::  null
      =/  rand  (~(get by strands.state) id.r)
      =-  [%o ['result' s+-] ~ ~]                 ::  {result: string}
      ^-  cord
      %-  crip
      %+  weld  "{(scow %da (dis q.u.pro seconds-mask))}\0a"
      ^-  tape
      ?:  |(?=(~ rand) ?=(%hoon -.src.u.rand))
        ?:  ?=(%| -.p.u.pro)
          %+  weld  "Error:\0a"
          (render-tang p.p.u.pro)
        %+  weld  "Success:\0a"
        (render-vase p.p.u.pro)
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
    %+  (rand-map poll-responder-yield vase)
      |=(poll-responder-yield !>(+<))
    =/  m  (strand poll-responder-yield)
    ^-  form:m
    =/  wir=wire  /state-updates
    ;<  ~        bind:m  (watch-our:sio wir name-term wir)
    ;<  now=@da  bind:m  get-time:sio
    =/  till=@da  (add now polling-timeout)
    =/  time-wir=wire  /poll-timeout
    ;<  ~  bind:m  (send-wait-prefix till time-wir)
    %+  (finally-do poll-responder-yield)  (leave-our:sio wir name-term)
    |-  ^-  form:m
    %-  (await-earliest poll-responder-yield)
    :~
      ;<  ~  bind:m  (take-wake-prefix till time-wir)
      (pure:m ~ stash)
    ::
      ;<  =cage  bind:m  (take-fact:sio wir)
      ?+    p.cage  ~|(%weird-mark !!)
          %noun
        =+  !<(new=persistent [-:!>(*persistent) +.q.q.cage])
        ?~  diff=(get-state-diff stash new)
          $(stash new)
        ;<  ~  bind:m  (send-rest-prefix till time-wir)
        (pure:m `[%diff u.diff] new)
      ::
          %message
        =+  !<(msg=message q.cage)
        (pure:m `[%message msg] stash)
      ==
    ==
  ::
  ++  form
    |=  stamp=time
    ^-  manx
    ;html
      ;head
        ;meta(charset "UTF-8");
        ;meta(name "viewport", content "width=device-width, initial-scale=1.0");
        ;title: Orchestra
        ;style: {style}
      ==
    ::
      ;body
        ;select#choose-thread(name "choose-thread", onchange "updateView()", form "control-form")
          ;option(value ""): --Select--
        ==
      ::
        ;pre#script-box
          ;+  ;/  "Script will appear here..."
        ==
      ::
        ;form#control-form
          ;div#control-row
            ;span#status-led.status-led(data-status "", title "", data-tooltip "No status")
              ;span.light;
            ==
          ::
            ;button#delete(type "button", onclick "deleteScript()"): Delete
            ;button#show-result(type "button", onclick "showResult()"): Load result
            ;div#update-params
              ;input#schedule-field
                =name         "schedule-time"
                =type         "text"
                =placeholder  "~d1"
                =maxlength    "7"
                ;
              ==
            ::
              ;button#update-schedule(name "action", type "button", onclick "updateParams()"): Update
            ==
          ::
            ;button#update-schedule(name "action", type "button", onclick "clearProduct()"): Clear product
            ;button#update-schedule(name "action", type "button", onclick "run()"): Run
            ;button#update-schedule(name "action", type "button", onclick "stop()"): Stop
            ;button#update-schedule(name "action", type "button", onclick "edit()"): Edit
          ==
        ==
      ::
        ;div#message-control(hidden "");
        ;div#error-control(hidden "");
        ;br;  ;br;
        ;h1: Add a new script
        ;form#upload-form
          ;div#upload-row
            ;textarea#script-name
              =name  "script-name"
              =cols  "30"
              =rows  "1"
              =placeholder  "/thread/name"
              ;
            ==
          ::
            ;select#language-choice(name "language-choice", onchange "updateLangPlaceholder()")
              ;option(value "hoon"): Hoon
              ;option(value "js"): JavaScript
            ==
          ::
            ;input#overwrite-checkbox(type "checkbox");
            ;label(for "overwrite-checkbox"): overwrite
          ==
        ::
          ;textarea#script-text
            =name  "script-text"
            =cols  "80"
            =rows  "20"
            =placeholder  """
                          @@  ~h1                   ::  schedule, optional @da
                          ##  name=/desk/path/hoon  ::  comma-separated imports, optional
                          ::
                          ...
                          """
            ;
          ==
        ::
          ;div#error-submit(hidden "");
          ;br;
          ;button(type "button", name "action", onclick "sendScript()"): Send
        ==
      ::
        ;script: {(js-code stamp)}
        ;br;  ;br;
        ;p
          ;a(href "https://github.com/dozreg-toplud/threads-js/blob/master/desk/docs.md", target "_blank"): urbit_thread documentation for scripts in JavaScript
        ==
      ==
    ==
  ::
  ++  js-code
    |=  stamp=time
    ^-  tape
    %+  weld
      """
      const PollUrl = '{(trip our-url)}/poll/{(scow %ui stamp)}';\0a
      const APIUrl = '{(trip our-url)}/api';\0a
      """
    =>  ..trip
    ^~  %-  trip
    '''
    //  state mirror
    //
    //  Scripts: script_id: string => {src: string,
    //                                 running: bool,
    //                                 params: {run_every: string},
    //                                 lang: string,
    //                                 fires: null | string,
    //                                 has_product: null
    //                                              | {success: bool,
    //                                                 when: string
    //                                                }
    //                                }
    //
    let Scripts = {};
    const Tips = {
      red: 'Script failed last run',
      green: 'Script returned sucessfully',
      yellow: 'Script still runnning',
      gray: 'Script not runnning',
      black: 'Script not found',
    };
    const div_message_control  = document.getElementById('message-control');
    const div_error_control    = document.getElementById('error-control');
    const div_error_submit     = document.getElementById('error-submit');
    const select_script        = document.getElementById('choose-thread');
    const pre_display_source   = document.getElementById('script-box');
    const textarea_edit_source = document.getElementById('script-text');
    const select_language      = document.getElementById('language-choice');
    const span_LED             = document.getElementById('status-led');
    const form_control         = document.getElementById('control-form');
    const form_upload          = document.getElementById('upload-form');
    const input_schedule       = document.getElementById('schedule-field');
    const textarea_script_name = document.getElementById('script-name');
    const input_overwrite_box  = document.getElementById('overwrite-checkbox');
    
    function updateView() {
      const current_key = select_script.value;
      let color = 'white';
      let is_blinking = false;
      let tooltip = 'No status';
      let textbox_content = 'Script will appear here...';
      if ( current_key && Scripts[current_key] ) {
        let script = Scripts[current_key];
        textbox_content = script.src;
        color = ( script.running )              ? 'yellow'
              : ( script.has_product === null ) ? 'gray'
              : ( script.has_product.success )  ? 'green'
              : 'red';
        is_blinking = (script.fires !== null) && (color !== 'yellow');
        tooltip = Tips[color] + (( is_blinking ) ? ", awaiting timer" : "");
        if ( script.params.run_every ) {
          textbox_content = `@@  ${script.params.run_every}\n` + textbox_content;
        }
      }
      else {
        textbox_content = 'Script will appear here...';
      }
      if (pre_display_source.textContent !== textbox_content) {
        pre_display_source.textContent = textbox_content;
      }
      span_LED.setAttribute('data-status', color);
      span_LED.setAttribute('data-tooltip', tooltip);
      span_LED.classList.toggle('blinking', is_blinking);
    }

    function updateLangPlaceholder() {
      const lang = select_language.value;
      if ('js' == lang) {
        textarea_edit_source.placeholder = `@@  ~h1  //  schedule, optional @da
    const urbit = require("urbit_thread");
    module.exports = () => {
      console.log("Hello");
      return "done";
    }`;
      }
      else {
        textarea_edit_source.placeholder = `@@  ~h1                   ::  schedule, optional @da
    ##  name=/desk/path/hoon  ::  comma-separated imports, optional
    ::
    ...
    `;
      }
    }
    function updateErrorControl(s) {
      if ( !s ) {
        div_error_control.setAttribute('hidden', '');
        div_error_control.textContent = '';
      } else {
        div_error_control.textContent = s;
        div_error_control.removeAttribute('hidden');
      }
    }

    function updateMessageControl(s) {
      if ( !s ) {
        div_message_control.setAttribute('hidden', '');
        div_message_control.textContent = '';
      } else {
        div_message_control.textContent = s;
        div_message_control.removeAttribute('hidden');
      }
    }

    function updateErrorSubmit(s) {
      if ( !s ) {
        div_error_submit.setAttribute('hidden', '');
        div_error_submit.textContent = '';
      } else {
        div_error_submit.textContent = s;
        div_error_submit.removeAttribute('hidden');
      }
    }

    async function showResult() {
      const current_key = select_script.value || '';
      if ( !current_key ) {
        div_message_control.setAttribute('hidden', '');
        div_message_control.textContent = '';
        return;
      }
      try {
        const response = await fetch(APIUrl, {
          method: 'POST',
          body: JSON.stringify({
            read: {product: current_key}
          })
        });
        if ( !response.ok ) {
          console.error('HTTP error: ', response.status);
        }
        else {
          const data = await response.json();
          if ( null === data ) {
            updateMessageControl();
          }
          else {
            updateMessageControl(data.result);
          }
        }
      } catch (e) {
        console.error('Network error:', e);
      }
    }

    async function delete_key(key) {
      try {
        const response = await fetch(APIUrl, {
          method: 'POST',
          body: JSON.stringify({
            action: {del: key}
          })
        });
        if ( !response.ok ) {
          console.error('HTTP error: ', response.status);
        }
        else {
          updateErrorControl();
          updateView();
        }
      } catch (e) {
        console.error('Network error:', e);
      }
    }

    async function deleteScript() {
      const current_key = select_script.value || '';
      if ( !current_key ) return;
      delete_key(current_key);
    }

    async function updateParams() {
      const current_key = select_script.value || '';
      if ( !current_key ) return;
      const new_params = input_schedule.value;
      try {
        const response = await fetch(APIUrl, {
          method: 'POST',
          body: JSON.stringify({
            action: {upd: {id: current_key, params: new_params}}
          })
        });
        if ( !response.ok ) {
          console.error('HTTP error: ', response.status);
        }
        else {
          const data = await response.json();
          if ( null === data ) {
            updateErrorControl();
          }
          else {
            updateErrorControl(data.error);
          }
        }
      } catch (e) {
        console.error('Network error:', e);
      }
    }

    async function clearProduct() {
      const current_key = select_script.value || '';
      if ( !current_key ) return;
      try {
        const response = await fetch(APIUrl, {
          method: 'POST',
          body: JSON.stringify({
            action: {clear: current_key}
          })
        });
        if ( !response.ok ) {
          console.error('HTTP error: ', response.status);
        }
        else {
          updateErrorControl();
        }
      } catch (e) {
        console.error('Network error:', e);
      }
    }

    async function run() {
      const current_key = select_script.value || '';
      if ( !current_key ) return;
      try {
        const response = await fetch(APIUrl, {
          method: 'POST',
          body: JSON.stringify({
            action: {run: current_key}
          })
        });
        if ( !response.ok ) {
          console.error('HTTP error: ', response.status);
        }
        else {
          updateErrorControl();
        }
      } catch (e) {
        console.error('Network error:', e);
      }
    }

    async function stop() {
      const current_key = select_script.value || '';
      if ( !current_key ) return;
      try {
        const response = await fetch(APIUrl, {
          method: 'POST',
          body: JSON.stringify({
            action: {stop: current_key}
          })
        });
        if ( !response.ok ) {
          console.error('HTTP error: ', response.status);
        }
        else {
          updateErrorControl();
        }
      } catch (e) {
        console.error('Network error:', e);
      }
    }

    async function sendScript() {
      const new_key = textarea_script_name.value;
      const new_source = textarea_edit_source.value;
      const overwrite = input_overwrite_box.checked;
      const lang = select_language.value;
      if ( Scripts[new_key] ) {
        if ( !overwrite ) {
          updateErrorSubmit(`The script ${new_key} already exists`);
          return;
        }
        await delete_key(new_key);
      }
      try {
        const response = await fetch(APIUrl, {
          method: 'POST',
          body: JSON.stringify({
            action: {new: {id: new_key, lang: lang, txt: new_source}}
          })
        });
        if ( !response.ok ) {
          console.error('HTTP error: ', response.status);
        }
        else {
          const data = await response.json();
          if ( null === data ) {
            updateErrorSubmit();
            textarea_edit_source.value = '';
            textarea_script_name.value = '';
          }
          else {
            updateErrorSubmit(data.error);
          }
        }
      } catch (e) {
        console.error('Network error:', e);
      }
    }

    function updateChoiceView() {
      const keys = Object.keys(Scripts).sort();
      const prev = select_script.value;
      select_script.replaceChildren(
        new Option('--Select--', '', true, true),
        ...keys.map(v => new Option(v, v))
      );
      if (keys.includes(prev)) {
        select_script.value = prev;
      }
      select_script.options[0].disabled = true;
      updateView();
    }

    function edit() {
      const current_key = select_script.value || '';
      if ( !current_key ) return;
      textarea_script_name.value = current_key;
      textarea_edit_source.value = pre_display_source.textContent;
      input_overwrite_box.checked = true;
      select_language.value = Scripts[current_key].lang;
    }
    
    async function longPoll() {
      while ( true ) {
        const controller = new AbortController();
        const timeoutId = setTimeout(() => controller.abort(), 30_000);
        try {
          const res = await fetch(PollUrl, {
            cache: 'no-store',
            signal: controller.signal,
          });

          if (res.status === 204) continue;
          const payload = await res.json();
          if ( payload === null ) continue;
          if ( payload.full ) {
            Scripts = {};
            const strands = payload.full.strands;
            const products = payload.full.products;
            for (const [key, value] of Object.entries(strands)) {
              Scripts[key] = {src: value.source,
                running: value.running,
                params: value.params,
                fires: value.fires,
                lang: value.lang,
                has_product: null};
            }
            for (const [key, value] of Object.entries(products)) {
              if ( Scripts[key] !== undefined ) {
                Scripts[key].has_product = {success: value.how, when: value.when};
              }
            }
            updateChoiceView();
          }
          else if ( payload.message?.error ) {
            console.error(payload.message.error.why);
            console.error(payload.message.error.what);
          }
        } catch (e) {
          await new Promise(r => setTimeout(r, 2000));
        } finally {
          clearTimeout(timeoutId);
        }
      }
    }
    longPoll();
    '''
  ::
  ++  style
    =>  ..trip
    ^~  %-  trip
    '''
    [hidden] { display: none !important; }
    body {
      font-family: monospace;
      background: #fafafa;
      display: flex;
      flex-direction: column;
      align-items: center;
      margin: 20px;
      margin: 0;
      margin-top: 40px;
    }
    select {
      padding: 8px 12px;
      font-size: 1em;
      margin-bottom: 20px;
      border-radius: 6px;
      border: 1px solid #ccc;
      background-color: white;
    }
    pre {
      width: 80ch;
      max-width: 80ch;
      min-width: 80ch;
      font-family: monospace;
      font-size: 1.5em;
      background: #f7f7f7;
      border: 1px solid #ccc;
      border-radius: 6px;
      padding: 10px;
      white-space: pre;
      overflow-x: auto;
      overflow-y: auto;
      margin: 0;      
    }
    h2 {
      margin-bottom: 10px;
      text-align: center;
    }
    #script-text {
      font-family: monospace;
      font-size: 1.5em;
      width: 80ch;
      height: 20em;
      resize: none;
      overflow: auto;
      border: 1px solid #ccc;
      border-radius: 6px;
      background: #f7f7f7;
      padding: 10px;
      display: block;
      margin: 10px auto;
      white-space: pre;
      overflow-x: auto;
      overflow-y: auto;
    }
    #script-name {
      width: 30ch;
      height: 2.25em;
      font-family: monospace;
      font-size: 1.5em;
      resize: none;
      overflow: hidden;
      padding: 5px 8px;
      border: 1px solid #ccc;
      border-radius: 6px;
      background: #f7f7f7;
      display: block;
      margin: 10px auto;
    }
    button {
      font-size: 0.9em;
      padding: 10px 20px;
      border-radius: 6px;
      border: 1px solid #888;
      background-color: #f0f0f0;
      cursor: pointer;
    }
    button:hover {
      background: #e0e0e0;
    }
    #error-submit,
    #error-control {
      margin-top: 5px;
      width: 80ch;
      background-color: #ffe6e6;
      color: #900;
      border: 1px solid #f5b5b5;
      border-radius: 4px;
      padding: 6px 10px;
      font-size: 1.5em;
      font-family: monospace;
      white-space: pre-wrap;
    }
    #message-control {
      //  display: none;
      margin-top: 5px;
      width: 80ch;
      background-color: #f0f0f0;
      border: 1px solid #888;
      border-radius: 4px;
      padding: 6px 10px;
      font-size: 1.5em;
      font-family: monospace;
      white-space: pre-wrap;
    }
    #control-row {
      display: flex;
      align-items: center;
      justify-content: space-between;
      width: 120ch;
      margin-top: 10px;
      gap: 10px;
    }
    #upload-row {
      display: flex;
      align-items: baseline;
      justify-content: flex-start;
      gap: 10px;
      width: 80ch;
      margin-top: 10px;
    }
    #script-name {
      height: auto;
      padding-top: 4px;
      padding-bottom: 4px;
    }
    #language-choice {
      font-size: 1.0em;
      padding: 6px 10px;
      border-radius: 6px;
      border: 1px solid #ccc;
      background-color: #f7f7f7;
    }
    #control-row button {
      font-size: 0.9em;
      padding: 6px 14px;
      border: 1px solid #aaa;
      border-radius: 6px;
      background-color: #f0f0f0;
      cursor: pointer;
    }

    #control-row button:hover {
      background-color: #e0e0e0;
    }

    #update-params {
      display: flex;
      align-items: center;
      gap: 6px;
    }

    #schedule-field {
      width: 7ch;
      font-family: monospace;
      font-size: 0.9em;
      padding: 4px 6px;
      border: 1px solid #ccc;
      border-radius: 4px;
    }
    .status-led {
      --led-size: 12px;
      width: var(--led-size);
      height: var(--led-size);
      border-radius: 50%;
      display: inline-block;
      border: 1px solid #666;
      box-shadow:
        0 0 0 2px rgba(0,0,0,0.05) inset,
        0 0 6px rgba(0,0,0,0.2);
      position: relative;
    }
    .status-led .light {
      width: 100%;
      height: 100%;
      border-radius: 50%;
      display: block;
    }
    .status-led::after {
      content: attr(data-tooltip);
      position: absolute;
      left: 50%;
      top: -40px;
      transform: translateX(-50%);
      padding: 4px 8px;
      background: #222;
      color: #fff;
      font-size: 0.8em;
      border-radius: 6px;
      white-space: nowrap;
      opacity: 0;
      pointer-events: none;
      transition: opacity 120ms ease;
    }
    .status-led:hover::after { opacity: 1; }
    .status-led[data-status="green"]  .light { background: #23c552; box-shadow: 0 0 8px #23c552; }
    .status-led[data-status="red"]    .light { background: #e03131; box-shadow: 0 0 8px #e03131; }
    .status-led[data-status="yellow"] .light { background: #f2c94c; box-shadow: 0 0 8px #f2c94c; }
    .status-led[data-status="gray"]   .light { background: #9e9e9e; box-shadow: 0 0 8px #9e9e9e; }
    .status-led[data-status="black"]  .light { background: #000000; box-shadow: 0 0 8px #000000; }

    @keyframes blink {
      0%, 100% { opacity: 1; }
      50% { opacity: 0.5; }
    }

    .status-led.blinking .light {
      animation: blink 3s infinite;
    }
    '''
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
    [%pass path %arvo %k %lard %orchestra shed]
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
      =.  strands.state  (~(put by strands.state) id [src params | 0 ~ hash])
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
      =.  fires-at.u.rand  ~
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
        %run-timer
      ?~  rand=(~(get by strands.state) id.act)
        ~&  >>  %orchestra-id-not-present
        `state
      ?:  is-running.u.rand
        ~&  >>  %orchestra-id-already-running
        `state
      =.  strands.state
        %+  strand-lens  id.act
        :(comp (set-running-flag &) (set-fires-at ~))
      ::
      :_  state
      ~[(emit-build id.act src.u.rand)]
    ::
        %run-defer
      ?~  rand=(~(get by strands.state) id.act)
        ~&  >>  %orchestra-id-not-present
        `state
      =.  params-counter.u.rand  +(params-counter.u.rand)
      =.  fires-at.u.rand  `at.act
      =.  strands.state  (~(put by strands.state) id.act u.rand)
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
      =.  run-every.params.u.rand  ~
      =.  fires-at.u.rand  ~
      =.  is-running.u.rand  |
      =.  params-counter.u.rand  +(params-counter.u.rand)
      =.  strands.state  (~(put by strands.state) id.act u.rand)
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
    =/  wir=wire
      [ %build-strand
        (scot %ud suspend-counter.state)
        id
      ]
    ::
    (send-shed wir (build-src id src))
  ::
  ++  emit-us-run
    |=  id=strand-id
    (poke-self /run %run id)
  ::
  ++  emit-us-run-timer
    |=  id=strand-id
    (poke-self /run %run-timer id)
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
          %-  need
          %-  ~(mole vi |)
          =>  [start-line=start-line txt=txt.src id=id ..strand-diff]
          |.  ~>  %memo./user
          %.  [[start-line 1] (trip txt)]
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
    [%give %fact ~[/state-updates] %noun !>([%persistent persistent-state])]
  ::
  ++  send-fact-message
    |=  msg=message
    ^-  card
    [%give %fact ~[/state-updates] %message !>(msg)]
  ::
  ++  bek  [our.bowl name-term da+now.bowl]
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