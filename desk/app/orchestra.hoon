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
+$  versioned-state
  $%  state-0
  ==
::
+$  strand-state
  $:  src=strand-source
      params=strand-params
      is-running=?
      params-counter=@
      awaits-timer=?
      hash=@uv
  ==
::
+$  state-0
  $:  version=%0
      suspend-counter=@
      strands=(map strand-id strand-state)
      products=(map strand-id (pair (each vase tang) time))
  ==
+$  card  card:agent:gall
+$  sign  sign:agent:gall
--
::
|%
++  make-tape
  |=  id=strand-id
  ^-  tape
  (trip (spat id))
::
++  set-running-flag
  |=  =flag
  ^-  $-(strand-state strand-state)
  |=  strand-state
  ^-  strand-state
  +<(is-running flag)
::
++  inc-params-counter  |=(strand-state +<(params-counter +(params-counter)))
++  set-await-flag
  |=  =flag
  ^-  $-(strand-state strand-state)
  |=  strand-state
  ^-  strand-state
  +<(awaits-timer flag)
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
=|  state=state-0
=*  strand  strand:spider
^-  agent:gall
=<
  |_  =bowl:gall
  +*  this     .
      def  ~(. (default-agent this %|) bowl)
      hc   ~(. helper-core bowl)
  ::
  ++  on-init
    :_  this  :_  ~
    [%pass /eyre/connect %arvo %e %connect `/apps/[name-term] name-term]
  ::
  ++  on-save   !>(state)
  ++  on-load
    |=  old=vase
    ^-  [(list card) _this]
    =/  ver-state  !<(versioned-state old)
    =.  state  ver-state
    ::  stop all old threads on load
    ::
    =^  cards-stop  strands.state
      |-  ^-  (quip card _strands.state)
      ?~  strands.state  [~ ~]
      =/  n-cards=(list card)
        ?.  is-running.q.n.strands.state  ~
        ~[(emit-stop:hc p.n.strands.state)]
      ::
      =^  l-cards  l.strands.state  $(strands.state l.strands.state)
      =^  r-cards  r.strands.state  $(strands.state r.strands.state)
      [(zing n-cards l-cards r-cards ~) strands.state(is-running.q.n |)]
    ::  invalidate old timers
    ::
    =.  suspend-counter.state  +(suspend-counter.state)
    ::  run all threads that were waiting for a timer
    ::
    =^  cards-run  strands.state
      |-  ^-  (quip card _strands.state)
      ?~  strands.state  [~ ~]
      =/  n-cards=(list card)
        ?.  awaits-timer.q.n.strands.state  ~
        ~[(emit-run:hc [p src.q]:n.strands.state)]
      ::
      =^  l-cards  l.strands.state  $(strands.state l.strands.state)
      =^  r-cards  r.strands.state  $(strands.state r.strands.state)
      :-  (zing n-cards l-cards r-cards ~)
      %=  strands.state
        awaits-timer.q.n  |
        is-running.q.n    awaits-timer.q.n.strands.state
      ==
    ::
    [(weld cards-stop cards-run) this]
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
    [cards this]
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
      ==
    [cards this]
  ::
  ++  on-arvo
    |=  [=wire =sign-arvo]
    ^-  (quip card _this)
    ?+    wire  (on-arvo:def wire sign-arvo)
        [%eyre %connect ~]  `this
    ::
        [%build-strand *]
      =*  id  t.wire
      ?>  ?=([%khan %arow *] sign-arvo)
      ?~  strand=(~(get by strands.state) id)  `this
      ?:  ?=(%| -.p.sign-arvo)
        =.  products.state
          (~(put by products.state) id |+tang.p.p.sign-arvo now.bowl)
        ::
        =.  strands.state
          (strand-lens:hc id (comp (set-running-flag |) (set-await-flag |)))
        ::
        `this
      =+  !<(res=(each vase tang) q.p.p.sign-arvo)
      ?:  ?=(%| -.res)
        =.  products.state  (~(put by products.state) id |+p.res now.bowl)
        =.  strands.state
          (strand-lens:hc id (comp (set-running-flag |) (set-await-flag |)))
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
          =.  strands.state  (strand-lens:hc id (set-await-flag |))
          [cards this]
        =/  wait-for=@dr  u.run-every.params
        =.  strands.state  (strand-lens:hc id (set-await-flag &))
        :_  this
        :_  cards
        =/  wir
          [ %timer
            (scot %ud suspend-counter.state)
            (scot %ud params-counter.u.strand)
            (scot %uv hash.u.strand)
            id
          ]
        ::
        [%pass wir %arvo %b %wait (add now.bowl wait-for)]
      ::
      [cards this]
    ::
        [%timer @ta @ta @ta *]
      =/  suspend-counter  (slav %ud i.t.wire)
      =/  params-counter   (slav %ud i.t.t.wire)
      =/  hash             (slav %uv i.t.t.t.wire)
      =*  id  t.t.t.t.wire
      ?>  ?=([%behn %wake *] sign-arvo)
      ?.  =(suspend-counter suspend-counter.state)
        `this
      ?~  strand=(~(get by strands.state) id)
        `this
      ?.  =(params-counter params-counter.u.strand)
        `this
      ?.  =(hash hash.u.strand)
        `this
      =+  ?~(error.sign-arvo ~ ((slog u.error.sign-arvo) ~))  =>  +
      =^  cards=(list card)  this
        ?:  is-running.u.strand
          ?~  run-every.params.u.strand
            =.  strands.state  (strand-lens:hc id (set-await-flag |))
            `this
          =.  strands.state  (strand-lens:hc id (set-await-flag &))
          :_  this
          =/  wait-for=@dr  u.run-every.params.u.strand
          :_  ~
          [%pass wire %arvo %b %wait (add now.bowl wait-for)]
        :_  this
        =/  =action  [%run id]
        :_  ~
        (poke-self:hc /restart orchestra-action+!>(action))
      ::
      [cards this]
    ==
  ::
  ++  on-agent
    |=  [=wire =sign]
    ^-  (quip card _this)
    ?+    wire  (on-agent:def wire sign)
        [%run-watch @ta *]
      ?+    -.sign  (on-agent:def wire sign)
          %fact
        =/  suspend-counter  (slav %ud i.t.wire)
        =*  id  t.t.wire
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
  ++  on-fail   on-fail:def
  ++  on-leave  on-leave:def
  --
::  helper core
::
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
  ::  %black:   missing
  ::  %yellow:  running
  ::  %gray:    not running, no product
  ::  %red:     not running, error
  ::  %green:   not running, returned product
  ::
  ++  status
    |=  id=strand-id
    ^-  [color=?(%green %gray %red %yellow %black) blinking=?]
    ?~  rand=(~(get by strands.state) id)   black+|
    (status-state id u.rand)
  ::
  ++  status-state
    |=  [id=strand-id rand=strand-state]
    ^-  [color=?(%green %gray %red %yellow %black) blinking=?]
    ?:  is-running.rand                    yellow+|
    :_  awaits-timer.rand
    ?~  pro=(~(get by products.state) id)  %gray
    ?-    -.src.rand
        %hoon
      ?:  ?=(%| -.p.u.pro)  %red
      %green
    ::
        %js
      ?:  ?=(%| -.p.u.pro)  %red
      =/  js-res
        %-  mole  |.
        !<  [%0 out=(each cord (pair cord cord))]
        p.p.u.pro
      ::
      ?~  js-res  %red
      ?:  ?=(%| -.out.u.js-res)  %red
      %green
    ==
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
  ::
  ++  take-action
    |=  act=action
    ^-  (quip card _state)
    ?-    -.act
        %new
      ?:  (~(has by strands.state) id.act)
        ~&  >>  %orchestra-id-already-present
        `state
      :-  ~[(emit-run id.act src.act)]
      =/  hash=@uv  (shax (jam %orchestra eny.bowl act))
      =,  act
      =.  strands.state  (~(put by strands.state) id [src params & 0 | hash])
      [~[(emit-run id.act src.act)] state]
    ::
        %del
      =.  products.state  (~(del by products.state) id.act)
      ?.  (~(has by strands.state) id.act)  `state
      [~[(emit-stop id.act)] state(strands (~(del by strands.state) id.act))]
    ::
        %upd
      ?~  rand=(~(get by strands.state) id.act)
        ~&  >>  %orchestra-id-not-present
        `state
      =.  params.u.rand  params.act
      =.  params-counter.u.rand  +(params-counter.u.rand)
      =.  strands.state  (~(put by strands.state) id.act u.rand)
      =.  strands.state  (strand-lens id.act (set-await-flag |))
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
      :-  ~[(emit-run id.act src.u.rand)]
      =.  strands.state
        (strand-lens id.act (comp (set-running-flag &) (set-await-flag |)))
      ::
      state
    ::
        %clear
      `state(products (~(del by products.state) id.act))
    ==
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
  ++  handle-http
    |=  [eyre-id=@ta =inbound-request:eyre]
    ^-  (quip card _state)
    =/  ,request-line:server
      (parse-request-line:server url.request.inbound-request)
    ::
    =+  send=(cury response:schooner eyre-id)
    ?+    method.request.inbound-request  [(send [405 ~ [%stock ~]]) state]
    ::
        ?(%'GET' %'POST')
      ?+      site
            :_  state
            (send [404 ~ [%plain "404 - Not Found"]])
      ::
          ?([%apps name-mold ~] [%apps name-mold %$ ~] [%'~' name-mold ~])
        ?.  authenticated.inbound-request
          :_  state
          %-  send
          [302 ~ [%login-redirect our-url]]
        ?~  body.request.inbound-request
          [(send [200 ~ manx+(form ~)]) state]
        =/  args  (parse-request q.u.body.request.inbound-request)
        ?-    -.args
            %send
          ?:  ?=(%| -.p.args)
            =/  rendered  (render-tang p.p.args)
            [(send [200 ~ manx+(form [[%parse rendered] ~ ~])]) state]
          =^  cards  state  (handle-request p.p.args)
          :_  state
          %+  weld  cards
          (send 302 ~ [%redirect our-url])
        ::
            %update
          ?:  ?=(%| -.p.args)
            =/  m  [[%parse-update (render-tang p.p.args)] ~ ~]
            [(send [200 ~ manx+(form m)]) state]
          =^  [cards=(list card) updates=(map @tas tape)]  state
            (handle-update p.p.args)
          ::
          ?:  =(~ cards)  [(send [200 ~ manx+(form updates)]) state]
          :_  state
          %+  weld  cards
          (send 302 ~ [%redirect our-url])
        ==
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
      ::
          [%apps name-mold %states ~]
        ?.  authenticated.inbound-request  `state
        =;  jon=json  [(send [200 ~ json+jon]) state]
        :-  %o
        %-  ~(rep by strands.state)
        |=  [[k=strand-id v=strand-state] acc=(map @t json)]
        ^+  acc
        =/  etat  (status-state k v)
        =-  (~(put by acc) (spat k) -)
        %-  pairs:enjs:format
        :~  color+s+color.etat
            blinking+b+blinking.etat
        ==
      ==
    ==
  ::
  ++  less-cr-rule
    %-  star
    ;~  pose
      (cold '\0a' (jest '\0d\0a'))
      next
    ==
  ::
  ++  parse-request-product
    |=  req=cord
    ^-  (unit strand-id)
    ?:  =('' req)  ~
    `(rash req stap)
  ::
  ++  handle-update
    |=  arg=(unit [id=strand-id web-action=@t time=(unit @dr)])
    ^-  [[(list card) (map @tas tape)] _state]
    ?~  arg  [[~ ~] state]
    =*  id  id.u.arg
    =/  web-action  web-action.u.arg
    =*  time  time.u.arg
    ?+    web-action  !!
        %update-schedule
      ::  no page updates, one card
      ::
      :_  state  :_  ~  :_  ~
      =/  =action  [%upd id time]
      (poke-self /update orchestra-action+!>(action))
    ::
        %delete
      :_  state  :_  ~  :_  ~
      =/  =action  [%del id]
      (poke-self /update orchestra-action+!>(action))
    ::
        %clear-product
      :_  state  :_  ~  :_  ~
      =/  =action  [%clear id]
      (poke-self /update orchestra-action+!>(action))
    ::
        %run
      ?~  rand=(~(get by strands.state) id)  [[~ ~] state]
      ?:  is-running.u.rand  [[~ ~] state]
      ::  invalidate old timers
      ::
      =.  strands.state  (strand-lens id inc-params-counter)
      :_  state  :_  ~  :_  ~
      =/  =action  [%run id]
      (poke-self /update orchestra-action+!>(action))
    ==
  ::
  ++  parse-request
    |=  req=cord
    ^-  $%  [%update p=(each (unit [strand-id @t (unit @dr)]) tang)]
            [%send p=(each (trel strand-id (unit @dr) strand-source) tang)]
        ==
    =/  fields=(map @t @t)
      %-  malt
      ~|  %request-parse-fail
      (rash req yquy:de-purl:html)
    ::
    =/  action=@t  (~(got by fields) %action)
    ?:  ?=(%send-script action)
      :-  %send
      ^-  (each (trel strand-id (unit @dr) strand-source) tang)
      =/  [name=@t txt=@t lang=@t]
        ~|  %request-read-fail
        :+  (~(got by fields) %script-name)
          (~(got by fields) %script-text)
        (~(got by fields) %language-choice)
      ::
      ?~  id=(rush name stap)  |+~['invalid name, expected path']
      ?~  u.id  |+~['empty path not permitted']
      ::  replace \r\n with \n
      ::
      =/  text=tape  (rash txt less-cr-rule)
      ?+    lang  ~|  %unrecognized-language  !!
          %hoon
        =|  every=(unit @dr)
        =|  deps=(list (pair term path))
        =/  flags=[hax=? pat=?]  [| |]
        |-  ^-  (each (trel strand-id (unit @dr) strand-source) tang)
        ?:  |(?=(~ text) ?=([* ~] text))
          &+[u.id every %hoon deps (crip text)]
        ?.  |(=(['#' '#'] [&1 &2]:text) =(['@' '@'] [&1 &2]:text))
          &+[u.id every %hoon deps (crip text)]
        ?:  =('@' -.text)
          ?:  pat.flags  |+~['duplicate schedule directive']
          =/  [=hair res=(unit [out=@dr =nail])]  (time-rule [1 1] text)
          ?~  res
            |+(report-parser-fail hair (crip text))
          $(every `out.u.res, pat.flags &, text q.nail.u.res)
        ?:  hax.flags  |+~['duplicate import directive']
        =/  [=hair res=(unit [out=(list (pair term path)) =nail])]
          (deps-rule [1 1] text)
        ::
        ?~  res
          |+(report-parser-fail hair (crip text))
        $(deps out.u.res, hax.flags &, text q.nail.u.res)
      ::
          %js
        =|  every=(unit @dr)
        |-  ^-  (each (trel strand-id (unit @dr) strand-source) tang)
        ?:  |(?=(~ text) ?=([* ~] text))
          &+[u.id every %js (crip text)]
        ?.  =(['@' '@'] [&1 &2]:text)
          &+[u.id every %js (crip text)]
        =/  [=hair res=(unit [out=@dr =nail])]  (time-rule [1 1] text)
        ?~  res
          |+(report-parser-fail hair (crip text))
        $(every `out.u.res, text q.nail.u.res)
      ==
    ?.  ?=(?(%update-schedule %delete %clear-product %run) action)
      ~|  %unsupported-action
      !!
    :-  %update
    ^-  (each (unit [strand-id @t (unit @dr)]) tang)
    =/  [name=@t time=@t]
      ~|  [%request-read-fail fields]
      :-  (~(got by fields) %choose-thread)
      (~(got by fields) %schedule-time)
    ::
    ?:  =('' name)  &+~
    =/  id  (rash name stap)
    ?:  =('' time)  &+`[id action ~]
    ?~  time=(rush time dr-rule)  |+~['invalid @dr syntax']
    &+`[id action time]
  ::
  ++  dr-rule
    ;~  pfix
      sig
      %+  sear
        |=  d=dime
        ^-  (unit @dr)
        ?.  ?=(%dr p.d)  ~
        `q.d
      crub:so
    ==
  ::
  ++  time-rule
    ;~  pfix
      (jest '@@')
      gap
      ;~(sfix dr-rule gap)
    ==
  ::
  ++  deps-rule
    ;~  pfix
      (jest '##')
      gap
      ;~(sfix (more (jest ', ') ;~((glue tis) sym stap)) gap)
    ==
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
  ++  handle-request
    |=  [id=strand-id run-every=(unit @dr) src=strand-source]
    ^-  (quip card _state)
    :_  state
    :_  ~
    =/  =action  [%new id src run-every]
    (poke-self /web-new-thread orchestra-action+!>(action))
  ::
  ++  form
    |=  updates=(map @tas tape)
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
        ;select#choose-thread(name "choose-thread", onchange "updateTextBox()", form "control-form")
          ;option(value ""): --Select--
        ::
          ;*
          %+  turn  ~(tap by strands.state)
          |=  [k=strand-id v=*]
          =/  t  (make-tape k)
          ;option(value t): {t}
        ==
      ::
        ;pre#script-box
          ;+  ;/  "Script will appear here..."
        ==
      ::
        ;form#control-form(action "{(trip our-url)}", method "POST")
          ;div#control-row
            ;span#status-led.status-led(data-status "", title "", data-tooltip "No status")
              ;span.light;
            ==
            ;button#delete(name "action", type "submit", value "delete"): Delete
            ;button#show-result(name "action", type "button", onclick "showResult()"): Load result
            ;div#update-params
              ;input#schedule-field
                =name         "schedule-time"
                =type         "text"
                =placeholder  "~d1"
                =maxlength    "7"
                ;
              ==
            ::
              ;button#update-schedule(name "action", type "submit", value "update-schedule"): Update
            ==
            ;button#update-schedule(name "action", type "submit", value "clear-product"): Clear product
            ;button#update-schedule(name "action", type "submit", value "run"): Run
          ==
        ==
      ::
      ;+  ?~  parser-fail=(~(get by updates) %parse-update)
            ;p;
          ;div#error-message: {u.parser-fail}
      ::
      ;div#show-product(hidden "");
      ::
        ;br;  ;br;
        ;h1: Add a new thread
        ;form#upload-form(method "POST")
          ;div#upload-row
            ;textarea#script-name
              =name  "script-name"
              =cols  "30"
              =rows  "1"
              =placeholder  "/thread/name"
              ;
            ==
          ::
            ;select#language-choice(name "language-choice", onchange "updatePlaceholder()")
              ;option(value "hoon"): Hoon
              ;option(value "js"): JavaScript
            ==
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
          ;+  ?~  parse-script=(~(get by updates) %parse)
                ;p;
              ;div#error-message: {u.parse-script}
        ::
          ;br;
          ;button(type "submit", name "action", value "send-script"): Send
        ==
      ::
        ;script: {js-code}
      ==
    ==
  ::
  ++  render-scripts
    ^-  tape
    =;  l=(list (pair tape tape))
      |-  ^-  tape
      ?~  l  ""
      """
      "{p.i.l}": {(trip (en:json:html s+(crip q.i.l)))},
      {$(l t.l)}
      """
    ::
    %+  turn  ~(tap by strands.state)
    |=  [k=strand-id v=[src=strand-source params=strand-params *]]
    ::  key and displayed text
    ::
    ^-  [tape tape]
    :-  (make-tape k)
    =-  ?~  run-every.params.v  -
        (weld "@@  {<u.run-every.params.v>}\0a" -)
    ?-    -.src.v
        %hoon
      """
      ##  {(render-deps deps.src.v)}
      ::
      {(trip txt.src.v)}
      """
    ::
        %js
      (trip txt.src.v)
    ==
  ::
  ++  render-deps
    |=  deps=(list (pair term path))
    ^-  tape
    ?~  deps  ""
    |-  ^-  tape
    ?~  t.deps  "{(trip p.i.deps)}={(trip (spat q.i.deps))}"
    "{(trip p.i.deps)}={(trip (spat q.i.deps))}, {$(deps t.deps)}"
  ::
  ++  render-states
    ^-  tape
    =/  ids  ~(tap in ~(key by strands.state))
    |-  ^-  tape
    ?~  ids  ""
    =/  etat  (status i.ids)
    """
    "{(make-tape i.ids)}": \{color: `{(trip color.etat)}`,
                             blinking: {?:(blinking.etat "true" "false")}
                            },
    {$(ids t.ids)}
    """
  ::
  ++  js-code
    ^-  tape
    """
    const sources = \{ {render-scripts} };
    let states = \{ {render-states} };

    const tips = \{
      red: 'Script failed last run',
      green: 'Script returned sucessfully',
      yellow: 'Script still runnning',
      gray: 'Script not runnning',
      black: 'Script not found',
    };

    const div_product = document.getElementById('show-product');
    const select      = document.getElementById('choose-thread');
    const textBox     = document.getElementById('script-box');
    const textScript  = document.getElementById('script-text');
    const select_lang = document.getElementById('language-choice');
    const ledEl       = document.getElementById('status-led');
    const formControl = document.getElementById('control-form');
    const formUpload  = document.getElementById('upload-form');

    function updateTextBox() \{
      const scriptKey = select.value;
      let color = 'white';
      let is_blinking = false;
      let tooltip = 'No status';
      let textbox_content = 'Script will appear here...';
      if (scriptKey && sources[scriptKey] && states[scriptKey]) \{
        textbox_content = sources[scriptKey];
        const state = states[scriptKey];
        color = state.color;
        is_blinking = state.blinking;
        tooltip = tips[state.color] + (( is_blinking ) ? ", awaiting timer" : "");
      }
      if (textBox.textContent !== textbox_content) \{
        textBox.textContent = textbox_content;
      }
      ledEl.setAttribute('data-status', color);
      ledEl.setAttribute('data-tooltip', tooltip);
      if ( is_blinking ) \{
        ledEl.classList.add('blinking');
      }
      else \{
        ledEl.classList.remove('blinking');
      }
    }
    function updatePlaceholder() \{
      const lang = select_lang.value;
      if ('js' == lang) \{
        textScript.placeholder = `@@  ~h1  //  schedule, optional @da
    const urbit = require("urbit_thread");
    module.exports = () => \{
      console.log("Hello");
      return "done";
    }`;
      }
      else \{
        textScript.placeholder = `@@  ~h1                   ::  schedule, optional @da
    ##  name=/desk/path/hoon  ::  comma-separated imports, optional
    ::
    ...
    `;
      }
    }
    async function showResult() \{
      const select = document.getElementById('choose-thread');
      const key = select.value || '';
      if (!key) \{
        div_product.setAttribute('hidden', '');
        div_product.textContent = '';
        return;
      }
      try \{
        const response = await fetch('{(trip our-url)}/product', \{method: 'POST', body: key});

        if (!response.ok) \{
          console.error('HTTP error:', response.status);
        }
        else \{
          const data = await response.json();
          if (null === data) \{
            div_product.setAttribute('hidden', '');
            div_product.textContent = '';
            return;
          }
          else \{
            div_product.textContent = data.u;
            div_product.removeAttribute('hidden');
          }
        }
      } catch (error) \{
        console.error('Network error:', error);
      }
    }
    async function updateStates() \{
      try \{
        const response = await fetch('{(trip our-url)}/states');
        if (!response.ok) \{
          console.error('HTTP error:', response.status);
        }
        else \{
          const data = await response.json();
          states = data;
          updateTextBox();
        }
      } catch (error) \{
        console.error('Network error:', error);
      }
    }
    function SaveLastItem() \{
      localStorage.setItem('lastChoice', select.value);
    }
    //
    const savedValue = localStorage.getItem('lastChoice');
    if (savedValue && sources[savedValue]) \{
      select.value = savedValue;
      updateTextBox();
    }
    setInterval(updateStates, 3000);
    formControl.addEventListener('submit', SaveLastItem);
    formUpload.addEventListener('submit', SaveLastItem);
    """
  ::
  ++  style
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
    #error-message {
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
    #show-product {
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
  ++  emit-stop
    |=  id=strand-id
    ^-  card
    (poke-spider /cancel %spider-stop !>([(make-tid id) |]))
  ::
  ++  emit-run
    |=  [id=strand-id src=strand-source]
    ^-  card
    (send-shed build-strand+id (build-src src))
  ::
  ++  build-src
    |=  src=strand-source
    ^-  shed:khan
    =/  m  (strand vase)
    ;<  res=(each vase tang)  bind:m
      =/  m  (strand (each vase tang))
      ^-  form:m
      ?-    -.src
          %hoon
        =/  build=vase  !>(..zuse)
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
        =/  [=hair res=(unit [=hoon =nail])]  (vest [1 1] (trip txt.src))
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
    |=  [=wire =cage]
    ^-  card
    [%pass wire %agent [our.bowl name-term] %poke cage]
  --  ::  |helper-core
--
