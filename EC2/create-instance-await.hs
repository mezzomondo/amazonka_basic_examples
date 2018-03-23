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

import Control.Monad
import Control.Lens
import Data.Text hiding (map)
import Network.AWS
import Network.AWS.EC2
import Network.AWS.Waiter
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
    res <- runResourceT . runAWS env . within Frankfurt $ do
        inst <- trying _Error $ send $ runInstances amiId 1 1
            & rInstanceType .~ Just T2_Nano
            & rSubnetId .~ Just subnetId
        case inst of
            Right r -> do
                let newInstanceId = map (view insInstanceId) (r ^. rInstances)
                accept <- await instanceRunning { _waitAttempts = 1 } $ describeInstances & diiInstanceIds .~ newInstanceId
                return $ Right r
            Left err -> return $ Left $ show err
    print res