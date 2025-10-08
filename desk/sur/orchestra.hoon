|%
+$  strand-id  path
+$  strand-source  [deps=(list (pair term path)) txt=cord]
++  range
  |$  [m]
  (pair m m)
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
  ==
--
