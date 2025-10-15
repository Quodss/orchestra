/-  *orchestra, spider
/+  dbug, default-agent, verb, server, schooner
/+  sio=strandio
/+  thread-builder-js
=*  stub  ~|(%stub !!)
=*  name-term  %orchestra
=*  name-mold  $orchestra
=/  our-url    (cat 3 '/apps/' name-term)
|%
+$  versioned-state
  $%  state-0
  ==
::
+$  strand-state  [src=strand-source params=strand-params is-running=?]
+$  state-0
  $:  version=%0
      suspend-counter=@
      strands=(map strand-id strand-state)
      products=(map strand-id (each vase tang))
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
  |=  [strands=(map strand-id strand-state) id=strand-id =flag]
  ^+  strands
  (~(jab by strands) id |=(strand-state +<(is-running flag)))
--
::
%+  verb  &
%-  agent:dbug
=|  state=state-0
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
    ::
    [cards-stop this(suspend-counter.state +(suspend-counter.state))]
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
        =.  products.state  (~(put by products.state) id |+tang.p.p.sign-arvo)
        `this(strands.state (set-running-flag strands.state id |))
      =+  !<(res=(each vase tang) q.p.p.sign-arvo)
      ?:  ?=(%| -.res)
        =.  products.state  (~(put by products.state) id |+p.res)
        `this(strands.state (set-running-flag strands.state id |))
      =/  tid  (make-tid id)
      =/  args=inline-args:spider  [~ `tid bek:hc !<(shed:khan p.res)]
      =/  cards
        :~  (watch-spider:hc run-watch+id /thread-result/[tid])
            (poke-spider:hc run-poke+id spider-inline+!>(args))
        ==
      ::
      =/  params  params.u.strand
      =^  cards  this
        ?~  run-every.params  [cards this]
        =/  wait-for=@dr  u.run-every.params
        :_  this
        :_  cards
        =/  wir  [%timer (scot %ud suspend-counter.state) id]
        [%pass wir %arvo %b %wait (add now.bowl wait-for)]
      ::
      [cards this]
    ::
        [%timer @ta *]
      =/  counter  (slav %ud i.t.wire)
      =*  id  t.t.wire
      ?>  ?=([%behn %wake *] sign-arvo)
      ?.  =(counter suspend-counter.state)  `this
      ?~  strand=(~(get by strands.state) id)  `this
      =-  ?~  error.sign-arvo.+  -  ((slog u.error.sign-arvo):+ -)
      =/  cards=(list card)
        ?:  is-running.u.strand
          ?~  run-every.params.u.strand  ~
          =/  wait-for=@dr  u.run-every.params.u.strand
          :_  ~
          [%pass wire %arvo %b %wait (add now.bowl wait-for)]
        =/  =action  [%run id]
        :_  ~
        (poke-self /restart orchestra-action+!>(action))
      ::
      [cards this]
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
        =.  strands.state  (set-running-flag strands.state id |)
        ?+    p.cage.sign  (on-agent:def wire sign)
            %thread-fail
          =+  !<(res=(pair term tang) q.cage.sign)
          =.  products.state  (~(put by products.state) id |+q.res)
          `this
        ::
            %thread-done
          =.  products.state  (~(put by products.state) id &+q.cage.sign)
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
::  %black:  missing
::  %yellow: running
::  %gray:   not running, no product
::  %red:    not running, error
::  %green:  not running, returned product
::
++  status
  |=  id=strand-id
  ^-  ?(%green %gray %red %yellow %black)
  ?~  rand=(~(get by strands.state) id)   %black
  ?:  is-running.u.rand                   %yellow
  ?~  pro=(~(get by products.state) id)   %gray
  ?-    -.src.u.rand
      %hoon
    ?:  ?=(%| -.u.pro)  %red
    %green
  ::
      %js
    ?:  ?=(%| -.u.pro)  %red
    =/  js-res
      %-  mole  |.
      !<  [%0 out=(each cord (pair cord cord))]
      p.u.pro
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
    state(strands (~(put by strands.state) [id [src params &]]:act))
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
  ::
      %run
    ?~  rand=(~(get by strands.state) id.act)
      ~&  >>  %orchestra-id-not-present
      `state
    :-  ~[(emit-run id.act src.u.rand)]
    state(strands (set-running-flag strands.state id.act &))
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
      ?:  ?=(%| -.args)
        [(send [200 ~ manx+(form [[%parse (render-tang p.args)] ~ ~])]) state]
      =^  cards  state  (handle-request p.args)
      :_  state
      %+  weld  cards
      (send 302 ~ [%redirect our-url])
    ::
        [%apps name-mold %update ~]
      ?.  authenticated.inbound-request  `state
      ?~  body.request.inbound-request   [(send 302 ~ [%redirect our-url]) state]
      =/  args  (parse-request-update q.u.body.request.inbound-request)
      ?:  ?=(%| -.args)
        =/  m  [[%parse-update (render-tang p.args)] ~ ~]
        [(send [200 ~ manx+(form m)]) state]
      =^  [cards=(list card) updates=(map @tas tape)]  state
        (handle-update p.args)
      ::
      ?:  =(~ cards)  [(send [200 ~ manx+(form updates)]) state]
      :_  state
      %+  weld  cards
      (send 302 ~ [%redirect our-url])
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
      ?:  |(?=(~ rand) ?=(%hoon -.src.u.rand))
        %-  crip
        ?:  ?=(%| -.u.pro)
          %+  weld  "Error:\0a"
          (render-tang p.u.pro)
        %+  weld  "Success:\0a"
        ^-  tape
        (zing (join "\0a" (wash 0^80 (cain p.u.pro))))
      ::  (-.src.u.rand == %js)
      ::
      %-  crip
      ?:  ?=(%| -.u.pro)
        %+  weld  "Thread error:\0a"
        (render-tang p.u.pro)
      =/  js-res
        %-  mole  |.
        !<  [%0 out=(each cord (pair cord cord))]
        p.u.pro
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
++  parse-request-update
  |=  req=cord
  ^-  (each (unit [strand-id @t (unit @dr)]) tang)
  =/  fields=(map @t @t)
    %-  malt
    ~|  %request-parse-fail
    (rash req yquy:de-purl:html)
  ::
  =/  [name=@t action=@t time=@t]
    ~|  [%request-read-fail fields]
    :+  (~(got by fields) %choose-thread)
      (~(got by fields) %action)
    (~(got by fields) %schedule-time)
  ::
  ?:  =('' name)  &+~
  =/  id  (rash name stap)
  ?:  =('' time)  &+`[id action ~]
  ?~  time=(rush time dr-rule)  |+~['invalid @dr syntax']
  &+`[id action time]
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
  ==
::
++  parse-request
  |=  req=cord
  ^-  (each (trel strand-id (unit @dr) strand-source) tang)
  =/  fields=(map @t @t)
    %-  malt
    ~|  %request-parse-fail
    (rash req yquy:de-purl:html)
  ::
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
      ;pre#script-state(hidden "")
        ;+  ;/  ""
      ==
    ::
      ;form#control-form(action "{(trip our-url)}/update", method "POST")
        ;div#control-row
          ;button#delete(name "action", type "submit", value "delete"): Delete
          ;button#show-result(name "action", type "button", onclick "showResult()"): Show result
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
      ;form(method "POST")
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
        ;button(type "submit"): Send
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
    "{p.i.l}": `{q.i.l}
    `,
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
  """
  "{(make-tape i.ids)}": `{(trip (status i.ids))}`,
  {$(ids t.ids)}
  """
::
++  js-code
  ^-  tape
  """
  const sources = \{ {render-scripts} };
  const states = \{ {render-states} };

  const div_product = document.getElementById('show-product');
  const select      = document.getElementById('choose-thread');
  const textBox     = document.getElementById('script-box');
  const textState   = document.getElementById('script-state');
  const textScript  = document.getElementById('script-text');
  const select_lang = document.getElementById('language-choice');

  function updateTextBox() \{
    const scriptKey = select.value;
    if (scriptKey) \{
      textBox.textContent = sources[scriptKey];
      textState.textContent = states[scriptKey];
      textState.removeAttribute('hidden');
    }
    else \{
      textBox.textContent = 'Script will appear here...';
      textState.textContent = '';
      textState.setAttribute('hidden', '');
    }
  }
  function updatePlaceholder() \{
    const lang = select_lang.value;
    if ('js' == lang) \{
      textScript.placeholder = `@@  ~h1  //  schedule, optional @da
  const ub = require("urbit_thread");
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
    width: 80ch
    max-width: 80ch;
    min-width: 80ch;
    font-family: monospace;
    font-size: 1.5em;
    background: #f7f7f7;
    border: 1px solid #ccc;
    border-radius: 6px;
    padding: 10px;
    white-space: pre-wrap;
    word-wrap: break-word;
    overflow: visible;
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
    //  display: none;
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
    width: 80ch;
    margin-top: 10px;
    gap: 10px;
  }
  #upload-row {
    display: flex;
    align-items: center;
    justify-content: space-between;
    width: 80ch;
    margin-top: 10px;
    gap: 10px;
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
      ?~  pro=(mole |.((slap build hoon.u.res)))
        |+~['source build failed']
      ?.  (~(nest ut -:!>(*shed:khan)) | -.u.pro)
        |+~['nest failed: not a shed']
      &+u.pro
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
--
