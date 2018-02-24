#!/usr/bin/env stack
-- stack --resolver lts-10.4 script

{-
Example:

- Put this script itself in an existing bucket prepending 'amazonka_basic_examles/':
$ stack put-object.hs --bucket <bucket>

-}

{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import Control.Lens
import Data.Text
import Network.AWS
import Network.AWS.S3
import Options.Generic
import System.IO

newtype Options = Options {bucket :: Text} deriving (Generic, Show)

instance ParseRecord Options

myGetBucket :: Options -> BucketName
myGetBucket (Options b) = BucketName b

main :: IO ()
main = do
    options <- getRecord "amazonka_basic_examples - put-object"
    env <- newEnv Discover
    let file = "put-object.hs"
    inBytes <- readFile file
    lenb <- withFile file ReadMode hFileSize 
    req <- runResourceT . runAWS env . within Frankfurt $
        send $ putObject (myGetBucket options) "amazonka_basic_examples/put-object.hs" (toBody inBytes)
    print req