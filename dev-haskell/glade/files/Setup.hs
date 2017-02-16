-- Adjustments specific to this package,
-- all Gtk2Hs-specific boilerplate is kept in
-- gtk2hs-buildtools:Gtk2HsSetup
--
import Gtk2HsSetup ( gtk2hsUserHooks )
import Distribution.Simple ( defaultMainWithHooks )

main = defaultMainWithHooks gtk2hsUserHooks
