import Distribution.Simple
import System.Process (rawSystem)
import System.Exit (ExitCode(..))
import System.FilePath ((</>))
main = defaultMainWithHooks $ simpleUserHooks { runTests = \args _ _ _ -> do
    ExitSuccess <- rawSystem "runhaskell" ("-package-conf=dist/package.conf.inplace" : "Test/Runner.hs" : args)
    return ()
                                              }
