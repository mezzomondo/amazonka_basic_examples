#!/usr/bin/env stack
-- stack --resolver lts-10.4 script

{-
Examples:

- Describes all the instances:
$ stack describe-instances.hs

- Describes a specific instance:
$ stack describe-instances.hs --instance_ids <instance-id>

- Describes multiple instances at once:
$ stack describe-instances.hs --instance_ids <instance-id1> --instance_ids <instance-id2> --instance_ids <instance-id3>
-}

{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import Control.Lens
import Data.Text
import Network.AWS
import Network.AWS.EC2
import Options.Generic

newtype Options = Options { instance_ids :: [Text]} deriving (Generic, Show)

instance ParseRecord Options

getIds :: Options -> [Text]
getIds (Options i) = i

main :: IO ()
main = do
    options <- getRecord "amazonka_basic_examples - describe-instances"
    let iIds = getIds options
    env <- newEnv Discover
    inst <- runResourceT . runAWS env . within Frankfurt $
        send $ describeInstances & diiInstanceIds .~ iIds
    print inst