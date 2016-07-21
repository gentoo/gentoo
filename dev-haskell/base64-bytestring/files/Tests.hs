{-# LANGUAGE OverloadedStrings #-}
{-# OPTIONS_GHC -fno-warn-orphans #-}

module Main (main) where

import Test.Framework (Test, defaultMain, testGroup)
import Test.Framework.Providers.QuickCheck2 (testProperty)
import Test.Framework.Providers.HUnit (testCase)

import Test.QuickCheck (Arbitrary(..))

import Control.Monad (liftM)
import qualified Data.ByteString.Base64 as Base64
import qualified Data.ByteString.Base64.URL as Base64URL
import Data.ByteString (ByteString)
import Data.ByteString.Char8 ()
import qualified Data.ByteString as B
import Test.HUnit hiding (Test)


main :: IO ()
main = defaultMain tests

tests :: [Test]
tests = [ 
    testGroup "Base64" [
        testProperty "decodeEncode" $
          genericDecodeEncode Base64.encode Base64.decode
      , testProperty "decodeEncode Lenient" $
          genericDecodeEncode Base64.encode
                              (liftM Right Base64.decodeLenient)
      , testGroup "base64-string tests" base64_string_tests 
    ]
  , testGroup "Base64URL" [
        testProperty "decodeEncode" $
          genericDecodeEncode Base64URL.encode Base64URL.decode
      , testProperty "decodeEncode Lenient" $
          genericDecodeEncode Base64URL.encode
                              (liftM Right Base64URL.decodeLenient)
      , testGroup "base64-string tests" base64url_string_tests 
    ]
  ]

instance Arbitrary ByteString where
  arbitrary = liftM B.pack arbitrary

-- | Decoding an encoded sintrg should produce the original string.
genericDecodeEncode :: (ByteString -> ByteString)
                    -> (ByteString -> Either String ByteString)
                    -> ByteString -> Bool
genericDecodeEncode enc dec x = case dec (enc x) of
                                  Left  _  -> False
                                  Right x' -> x == x'
  
--
-- Unit tests from base64-string
-- Copyright (c) Ian Lynagh, 2005, 2007.
--

base64_string_tests :: [Test]
base64_string_tests = 
  base64_string_test Base64.encode Base64.decode testData ++
  base64_string_test Base64.encode decodeURL testData
  where decodeURL :: ByteString -> Either String ByteString
        decodeURL = liftM Right Base64.decodeLenient
        testData :: [(ByteString, ByteString)]
        testData = [("",                "")
                   ,("\0",              "AA==")
                   ,("\255",            "/w==")
                   ,("E",               "RQ==")
                   ,("Ex",              "RXg=")
                   ,("Exa",             "RXhh")
                   ,("Exam",            "RXhhbQ==")
                   ,("Examp",           "RXhhbXA=")
                   ,("Exampl",          "RXhhbXBs")
                   ,("Example",         "RXhhbXBsZQ==")
                   ,("Ex\0am\254ple",   "RXgAYW3+cGxl")
                   ,("Ex\0am\255ple",   "RXgAYW3/cGxl")
                   ]

-- | Same as the base64_string_tests but using the alternative alphabet
base64url_string_tests :: [Test]
base64url_string_tests =
  base64_string_test Base64URL.encode Base64URL.decode testData ++
  base64_string_test Base64URL.encode decodeURL testData
  where decodeURL :: ByteString -> Either String ByteString
        decodeURL = liftM Right Base64URL.decodeLenient
        testData :: [(ByteString, ByteString)]
        testData = [("",                "")
                   ,("\0",              "AA==")
                   ,("\255",            "_w==")
                   ,("E",               "RQ==")
                   ,("Ex",              "RXg=")
                   ,("Exa",             "RXhh")
                   ,("Exam",            "RXhhbQ==")
                   ,("Examp",           "RXhhbXA=")
                   ,("Exampl",          "RXhhbXBs")
                   ,("Example",         "RXhhbXBsZQ==")
                   ,("Ex\0am\254ple",   "RXgAYW3-cGxl")
                   ,("Ex\0am\255ple",   "RXgAYW3_cGxl")
                   ]

-- | Generic test given encod enad decode funstions and a
-- list of (plain, encoded) pairs
base64_string_test :: (ByteString -> ByteString)
                   -> (ByteString -> Either String ByteString)
                   -> [(ByteString, ByteString)] -> [Test]
base64_string_test enc dec testData = concat
      [ [ testCase ("base64-string: Encode " ++ show plain)
                   (encoded_plain @?= encoded),
          testCase ("base64-string: Decode " ++ show plain)
                   (decoded_encoded @?= Right plain) ]
      | (plain, encoded) <- testData,
        let encoded_plain = enc plain
            decoded_encoded = dec encoded
      ]
