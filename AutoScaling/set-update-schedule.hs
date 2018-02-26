#!/usr/bin/env stack
-- stack --resolver lts-10.4 script

{-
Example:

- Set or update office hours schedule for an existing autoscaling group:
$ stack set-update-schedule.hs --group_name <autoscaling group>

-}

{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import Control.Lens
import Data.Text
import Network.AWS
import Network.AWS.AutoScaling
import Options.Generic

newtype Options = Options {group_name :: Text} deriving (Generic, Show)

instance ParseRecord Options

getGroup :: Options -> Text
getGroup (Options g) = g

main :: IO ()
main = do
    options <- getRecord "amazonka_basic_examples - set-update-schedule"
    env <- newEnv Discover
    let group = getGroup options
    dayStart <- runResourceT . runAWS env . within Frankfurt $
        send $ putScheduledUpdateGroupAction group "office-hours-start"
            & psugaRecurrence .~ Just "50 8 * * MON-FRI"
            & psugaMinSize .~ Just 3
            & psugaMaxSize .~ Just 6
            & psugaDesiredCapacity .~ Just 3
    print dayStart
    dayEnd <- runResourceT . runAWS env . within Frankfurt $
        send $ putScheduledUpdateGroupAction group "office-hours-end"
            & psugaRecurrence .~ Just "10 18 * * MON-FRI"
            & psugaMinSize .~ Just 1
            & psugaMaxSize .~ Just 2
            & psugaDesiredCapacity .~ Just 1
    print dayEnd