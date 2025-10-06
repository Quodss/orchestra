/-  *orchestra, spider
/+  dbug, default-agent, verb, server, schooner
/+  sio=strandio
=*  stub  ~|(%stub !!)
=*  name-term     %orchestra
=*  name-mold     $orchestra
=/  url-redirect  (cat 3 './apps/' name-term)
|%
+$  versioned-state
  $%  state-0
  ==
::
+$  state-0
  $:  %0
      strands=(map strand-id [src=strand-source params=strand-params])
      products=(map strand-id vase)
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
++  make-tid
  |=  id=strand-id
  ^-  tid:spider
  =/  txt=tape  (trip (spat id))
  =.  txt  (turn txt |=(=char ?:(=('/' char) '-' char)))
  (rap 3 'orchestra' txt)
--
::
%+  verb  &
%-  agent:dbug
=|  state-0
=*  state  -
=*  strand  strand:spider
^-  agent:gall
=<
  |_  =bowl:gall
  +*  this     .
      def  ~(. (default-agent this %|) bowl)
      hc   ~(. +> bowl)
  ::
  ++  on-init
    :_  this  :_  ~
    [%pass /eyre/connect %arvo %e %connect `/apps/[name-term] name-term]
  ::
  ++  on-save   !>(state)
  ++  on-load
    |=  old=vase
    ^-  [(list card) _this]
    ::  stop all old threads on load
    ::
    =/  state  !<(state-0 old)
    =/  cards-stop
      %-  ~(rep by strands.state)
      |=  [[k=strand-id *] acc=(list card)]
      ^+  acc
      [(emit-stop:hc k) acc]
    ::
    [cards-stop this(state state(strands ~))]
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
      [%x %strands ~]   [~ ~ [%noun !>(strands.state)]]
      [%x %products ~]  [~ ~ [%noun !>(products.state)]]
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
      ?:  ?=(%| -.p.sign-arvo)
        ~&  mote.p.p.sign-arvo
        %-  (slog tang.p.p.sign-arvo)
        `this(strands.state (~(del by strands.state) id))
      ?.  (~(has by strands.state) id)  `this
      =+  !<(res=(each vase tang) q.p.p.sign-arvo)
      ?:  ?=(%| -.res)
        %-  (slog p.res)
        `this(strands.state (~(del by strands.state) id))
      :_  this
      =/  tid  (make-tid id)
      =/  args=inline-args:spider  [~ `tid bek:hc !<(shed:khan p.res)]
      :~  (watch-spider:hc run-watch+id /thread-result/[tid])
          (poke-spider:hc run-poke+id spider-inline+!>(args))
      ==
    ==
  ::
  ++  on-agent
    |=  [=wire =sign]
    ^-  (quip card _this)
    ?+    wire  (on-agent:def wire sign)
        [%run-watch *]
      ?+    -.sign  (on-agent:def wire sign)
          %fact
        =*  id  t.wire
        ?.  (~(has by strands.state) id)  `this
        ?+    p.cage.sign  (on-agent:def wire sign)
            %thread-fail
          =+  !<(res=(pair term tang) q.cage.sign)
          ~&  p.res
          %-  (slog q.res)
          `this
        ::
            %thread-done
          =.  strands.state   (~(del by strands.state) id)
          =.  products.state  (~(put by products.state) id q.cage.sign)
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
|_  =bowl:gall
+*  this  .
    def   ~(. (default-agent this %|) bowl)
::
++  bek  [our.bowl %base da+now.bowl]
++  take-action
  |=  act=action
  ^-  (quip card _state)
  ?-    -.act
      %new
    ?:  (~(has by strands.state) id.act)
      ~&  >>  %orchestra-id-already-present
      `state
    :-  ~[(emit-run id.act src.act)]
    state(strands (~(put by strands.state) +.act))
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
    `state(strands (~(put by strands.state) id.act u.rand(params params.act)))
  ::
      %wipe
    `state(products ~)
  ==
::
++  handle-http
  |=  [eyre-id=@ta =inbound-request:eyre]
  ^-  (quip card _state)
  ~&  %handle-http
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
        ?([%apps name-mold ~] [%apps name-mold %$ ~])
      ?.  authenticated.inbound-request
        :_  state
        %-  send
        [302 ~ [%login-redirect url-redirect]]
      =/  args=(unit *)
        ?~  body.request.inbound-request  ~
        `(parse-request q.u.body.request.inbound-request)
      :_  state
      (send [200 ~ manx+(form args)])
    ==
  ==
::
++  parse-request
  |=  req=cord
  ^-  *
  stub
::
++  form
  |=  args=*
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
      ;select#choose-thread(onchange "updateTextBox()")
        ;option(value ""): --Select--
      ::
        ;*
        %+  turn  ~(tap by strands.state)
        |=  [k=strand-id v=*]
        ;option: {(make-tape k)}
      ==
      ::
      ;textarea#script-box
        =readonly     "readonly"
        =placeholder  "Script will appear here..."
        ;+  ;/  ""
      ==
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
    "{p.i.l}": `{q.i.l}
    `,
    {$(l t.l)}
    """
  ::
  %+  turn  ~(tap by strands.state)
  |=  [k=strand-id v=[src=strand-source params=strand-params]]
  ::  key and displayed text
  ::
  ^-  [tape tape]
  :-  (make-tape k)
  %+  weld  ":#  {(render-deps deps.src.v)}\0a::\0a"
  (trip txt.src.v)
::
++  render-deps
  |=  deps=(list (pair term path))
  ^-  tape
  ?~  deps  ""
  |-  ^-  tape
  ?~  t.deps  "{(trip p.i.deps)}={(trip (spat q.i.deps))}"
  "{(trip p.i.deps)}={(trip (spat q.i.deps))}, {$(deps t.deps)}"
::
++  js-code
  ^-  tape
  """
  const sources = \{ {render-scripts} };
  function updateTextBox() \{
    const select = document.getElementById('choose-thread');
    const textBox = document.getElementById('script-box');
    const scriptKey = select.value;

    textBox.value = scriptKey ? sources[scriptKey] : '';
  }
  """
::
++  style
  ^~  %-  trip
  '''
  body {
    font-family: monospace;
    background: #fafafa;
    height: 100vh;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    margin: 0;
  }
  select {
    padding: 8px 12px;
    font-size: 1em;
    margin-bottom: 20px;
    border-radius: 6px;
    border: 1px solid #ccc;
    background-color: white;
  }
  textarea {
    width: 80ch;
    height: 25em;
    font-family: monospace;
    font-size: 1.5em;
    white-space: pre;
    background: #f7f7f7;
    border: 1px solid #ccc;
    border-radius: 6px;
    padding: 10px;
    resize: vertical;
  }
  h2 {
    margin-bottom: 10px;
    text-align: center;
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
    =/  build=vase  !>(..zuse)
    |-  ^-  form:m
    ?^  deps.src
      =*  dep  i.deps.src
      ;<  vax=(unit vase)  bind:m
        =/  bek=beak  [our.bowl -.q.dep da+now.bowl]
        ~&  bek
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
    ?~  res
      :-  %|
      =*  lyn  p.hair
      =*  col  q.hair
      :~  leaf+"syntax error at [{<lyn>} {<col>}] in source"
        ::
          =/  =wain  (to-wain:format txt.src)
          ?:  (gth lyn (lent wain))
            '<<end of file>>'
          (snag (dec lyn) wain)
        ::
          leaf+(runt [(dec col) '-'] "^")
      ==
    ?~  pro=(mole |.((slap build hoon.u.res)))
      |+~['source build failed']
    ?.  (~(nest ut -:!>(*shed:khan)) | -.u.pro)
      |+~['nest failed: not a shed']
    &+u.pro
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
--
