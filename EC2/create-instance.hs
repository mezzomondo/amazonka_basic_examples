#!/usr/bin/env stack
-- stack --resolver lts-10.4 script

{-
Examples:

- Create a t2.nano instance from an ami in a subnet.
  Note that the rDryRun flag is set so no action will be performed:
$ stack create-instance.hs --ami_id <ami-id> --subnet_id <subnet-id>

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
    options <- getRecord "amazonka_basic_examples - create-instance"
    let amiId = getAmiId options
    let subnetId = getSubnetId options
    env <- newEnv Discover
    inst <- runResourceT . runAWS env . within Frankfurt $
        send $ runInstances amiId 1 1
            & rInstanceType .~ Just T2_Nano
            & rSubnetId .~ Just subnetId
    --        & rDryRun .~ Just True
    let newInstanceId = map (view insInstanceId) (inst ^. rInstances)
    nonso <- runResourceT . runAWS env . within Frankfurt $
        await instanceRunning $ describeInstances & diiInstanceIds .~ newInstanceId
    print nonso