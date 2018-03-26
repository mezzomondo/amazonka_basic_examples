#!/usr/bin/env stack
-- stack --resolver lts-10.4 script

{-
Examples:

- CAUTION! COMPLICATIONS AHEAD! USE AT YOUR OWN RISK!
  Create a t2.nano instance from an ami in a subnet AND WAITS UNTIL IS AVAILABLE:
  Note that the rDryRun flag is NOT set so the action WILL BE performed:
$ stack create-instance-await.hs --ami_id <ami-id> --subnet_id <subnet-id>

-}

{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import Control.Lens
import Data.Text hiding (map)
import Network.AWS
import Network.AWS.EC2
import Options.Generic

data Options = Options {
      ami_id :: Text
    , vpc_id :: Text
} deriving (Generic, Show)

instance ParseRecord Options

getAmiId :: Options -> Text
getAmiId (Options a _) = a

getSubnetId :: Options -> Text
getSubnetId (Options _ v) = v

main :: IO ()
main = do
    options <- getRecord "amazonka_basic_examples - create-instance-await"
    let amiId = getAmiId options
    let subnetId = getSubnetId options
    env <- newEnv Discover
    inst <- runResourceT . runAWS env . within Frankfurt $
        send $ runInstances amiId 1 1
            & rInstanceType .~ Just T2_Nano
            & rSubnetId .~ Just subnetId
    print inst
    print "Now we wait until instance is running..."
    let newInstanceId = map (view insInstanceId) (inst ^. rInstances)
    accept <- runResourceT . runAWS env . within Frankfurt $
        await instanceRunning $ describeInstances & diiInstanceIds .~ newInstanceId
    print accept