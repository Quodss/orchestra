/-  sur=orchestra
/+  sio=strandio
::
|%
++  cmp-events
  |=  [a=(pair strand-id:sur @da) b=(pair strand-id:sur @da)]
  ^-  ?
  (lth q.a q.b)
::
++  cron
  |%
  +$  range  (list $@(@ud (pair @ud @ud)))
  +$  schedule
    $:
      ::  any value, or list of values and/or ranges
      ::  there must be at least one valid value
      ::
      min=range
      hor=range
      ::  allowed: 1-31 (in sync with +yore)
      ::  special value, any value, or list of values and/or ranges
      ::
      $=  day
      $@  ?(%last)
      [~ p=range]
    ::  allowed values: 1-12 (in sync with +yore)
    ::
      mon=range
    ::  allowed-values: 0-6
    ::  day of week, number in month
    ::  e.g. any Thursday: [3 0]
    ::  2nd Monday of the month: [0 2]
    ::
      wek=(list [val=@ud num=@])
    ==
  ::
  ::    validation
  ::
  ++  valid-dow
    |=  [val=@ud num=@]
    ^-  ?
    (lth val 7)
  ::
  ++  valid-range
    |=  [r=range min=@ud max=@ud]
    ^-  ?
    %+  levy  r
    |=  a=$@(@ud (pair @ud @ud))
    ^-  ?
    ?@  a  &((lte min a) (lte a max))
    ?&  (lte p.a q.a)
        (lte min p.a)
        (lte q.a max)
    ==
  ::
  ++  valid-schedule
    |=  s=schedule
    ^-  ?
    ?&
      (valid-range min.s 0 59)
      (valid-range hor.s 0 23)
      |(?=(@ day.s) (valid-range p.day.s 1 31))
      (valid-range mon.s 1 12)
      (levy wek.s valid-dow)
    ==
  ::
  ::    core-logic
  ::
  ++  val-check
    |=  a=@ud
    |=  b=$@(@ud (pair @ud @ud))
    ^-  ?
    ?@  b  =(a b)
    &((lte p.b a) (lte a q.b))
  ::
  ++  range-check
    |=  [a=@ud =range]
    ^-  ?
    ?:  =(~ range)  &
    (lien range (val-check a))
  ::
  ++  dow
    |=  now=@da
    ^-  @ud
    (mod (add 5 (div now ~d1)) 7)
  ::
  ++  valid-day
    |=  [now=@da s=schedule]
    ^-  ?
    =/  date  (yore now)
    =/  day-of-week=@ud  (dow now)
    =/  num-of-dow=@ud  +((div d.t.date 7))
    ?&
      (range-check m.date mon.s)
    ::
      ?^  day.s  (range-check d.t.date p.day.s)
      ?-    day.s
          %last
        =(d.t.date (snag (dec m.date) ?:((yelp y.date) moy:yo moh:yo)))
      ==
    ::
      ?:  =(~ wek.s)  &
      |-  ^-  ?
      ?~  wek.s  |
      ?.  =(val.i.wek.s day-of-week)  $(wek.s t.wek.s)
      ?:  =(0 num.i.wek.s)  &
      ?:  =(num-of-dow num.i.wek.s)  &
      $(wek.s t.wek.s)
    ==
  ::
  ++  valid-hour
    |=  [now=@da s=schedule]
    ^-  ?
    =/  =date  (yore now)
    (range-check h.t.date hor.s)
  ::
  ++  valid-minute
    |=  [now=@da s=schedule]
    ^-  ?
    =/  =date  (yore now)
    (range-check m.t.date min.s)
  ::
  ++  cron
    |=  s=schedule
    ?>  (valid-schedule s)
    |=  now=@da
    ^-  @da
    ::  round up to minutes
    ::
    =/  zen=@da  (mul ~m1 (div (add now (sub ~m1 1)) ~m1))
    ::  while invalid day:  add ~d1, round down to ~d1
    ::  while invalid hour: add ~h1, round down to ~h1
    ::  while invalid min:  add ~m1, round down to ~m1
    ::
    |-  ^-  @da
    ?.  (valid-day zen s)     $(zen (mul ~d1 +((div zen ~d1))))
    ?.  (valid-hour zen s)    $(zen (mul ~h1 +((div zen ~h1))))
    ?.  (valid-minute zen s)  $(zen (mul ~m1 +((div zen ~m1))))
    zen
  --
::
++  poke-us
  |=  act=action:sur
  =/  m  (strand:sio ,~)
  ^-  form:m
  (poke-our:sio %orchestra orchestra-action+!>(act))
::
++  scheduler
  |=  schedules=(list (pair strand-id:sur $-(@da @da)))
  =/  m  (strand:sio vase)
  ^-  form:m
  ?:  =(~ schedules)
    %-  pure:m
    !>('nothing to schedule, add schedules and rerun')
  ;<  events=(list (pair strand-id:sur @da))  bind:m
    =/  m  (strand:sio (list (pair strand-id:sur @da)))
    ^-  form:m
    ;<  now=@da  bind:m  get-time:sio
    =/  events=(list (pair strand-id:sur @da))
      (turn schedules |=([p=strand-id:sur g=$-(@da @da)] [p (g now)]))
    ::
    =.  events  (sort events cmp-events)
    ?>  (gth q.i.-.events now)
    (pure:m events)
  ::
  |-  ^-  form:m  ::  never return
  =*  forever-loop  $
  ;<  *  bind:m
    ~&  [%scheduler-wait-till q.i.-.events]
    (wait:sio q.i.-.events)
  ::
  ;<  now=@da  bind:m  get-time:sio
  ;<  *  bind:m
    =/  m  (strand:sio ,~)
    |-  ^-  form:m
    ?~  events  (pure:m ~)
    ?:  (gth q.i.events now)  (pure:m ~)
    ;<  *  bind:m  (poke-us [%run p.i.events])
    $(events t.events)
  ::
  =/  events-new=(list (pair strand-id:sur @da))
    (turn schedules |=([p=strand-id:sur g=$-(@da @da)] [p (g now)]))
  =.  events-new  (sort events-new cmp-events)
  ?>  (gth q.i.-.events-new now)
  forever-loop(events events-new)
--