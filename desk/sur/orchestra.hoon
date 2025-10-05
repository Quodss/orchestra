|%
+$  strand-id  path
+$  strand-source  [deps=(list (pair term path)) txt=cord]
+$  strand-params  [restart=?]
+$  action
  $%  [%new id=strand-id src=strand-source params=strand-params]
      [%del id=strand-id]
      [%upd id=strand-id params=strand-params]
  ==
--
