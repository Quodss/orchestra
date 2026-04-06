|%
+$  strand-id  path
+$  strand-source
  $%  [%hoon deps=(list (pair term path)) txt=cord]
      [%js txt=cord]
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
+$  strand-params
  $:  run-every=(unit @dr)
  ==  
::
+$  action
  $%  [%new id=strand-id src=strand-source params=strand-params]
      [%del id=strand-id]
      [%upd id=strand-id params=strand-params]
      [%wipe ~]
      [%run id=strand-id]
      [%run-timer id=strand-id]
      [%run-defer id=strand-id at=time]
      [%clear id=strand-id]
      [%stop id=strand-id]
  ==
::
+$  versioned-persistent-state
  $%  state-0
      state-1
  ==
::
+$  state-0
  $+  state-0
  $:  version=%0
      suspend-counter=@
      strands=(map strand-id strand-state)
      products=(map strand-id (pair (each vase:h136 tang) time))
  ==
::
+$  state-1
  $+  state-1
  $:  version=%1
      suspend-counter=@
      strands=(map strand-id strand-state)
      products=(map strand-id (pair (each vase tang) time))
  ==
::
+$  persistent  state-0
::
+$  message
  $%  [%error why=@t what=tang]
  ==
--
