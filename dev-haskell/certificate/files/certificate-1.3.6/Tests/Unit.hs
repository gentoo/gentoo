module Tests.Unit
	( runTests
	) where

import System.Directory
import Test.HUnit
import Control.Monad
import Control.Applicative ((<$>))
import Control.Exception
import qualified Data.ByteString as B
import qualified Data.ByteString.Lazy as L
import Data.Certificate.X509
import Data.List (isPrefixOf)

-- FIXME : make unit tests portable to run on osX and windows
import System.Certificate.X509
import Data.CertificateStore

checkCert (X509 c mraw rawCert sigalg sigbits) = do
	let errs =
		(checkSigAlg $ certSignatureAlg c) ++
		(checkPubKey $ certPubKey c) ++
		(checkExtensions $ certExtensions c) ++
		(checkBodyRaw rawCert mraw)
	when (errs /= []) $ do
		putStrLn ("error decoding")
		mapM_ (putStrLn . ("  " ++))  errs
	where
		checkExtensions ext = []

		checkSigAlg (SignatureALG_Unknown oid) = ["unknown signature algorithm " ++ show oid]
		checkSigAlg _                          = []

		checkPubKey (PubKeyUnknown oid _) = ["unknown public key alg " ++ show (certPubKey c)]
		checkPubKey _                     = []

		checkBodyRaw (Just x) (Just y) = if findsubstring y x then [] else ["cannot find body cert in original raw file"]
		checkBodyRaw _ _  = []

		findsubstring a b
			| L.null b        = False
			| a `L.isPrefixOf` b = True
			| otherwise          = findsubstring a (L.drop 1 b)

runTests :: IO ()
runTests = getSystemCertificateStore >>= mapM_ checkCert . listCertificates
