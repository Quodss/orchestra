|%
+$  strand-id  path
+$  strand-source
  $%  [%hoon deps=(list (pair term path)) txt=cord]
      [%js txt=cord]
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
      [%run-defer id=strand-id at=time]
      [%clear id=strand-id]
      [%stop id=strand-id]
  ==
--
