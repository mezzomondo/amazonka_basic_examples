#!/usr/bin/env stack
-- stack --resolver lts-10.4 script

{-
Example:

- Describe tags for the instance-id:
$ stack describe-tags.hs --resource_type instance --resource_id <instance-id>

- Describe tags for the AMI-id:
$ stack describe-tags.hs --resource_type image --resource_id <AMI-id>
-}

{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import Control.Lens
import Data.Text
import Network.AWS
import Network.AWS.EC2
import Options.Generic

data Options = Options {
    resource_type :: Text
  , resource_id   :: Text
} deriving (Generic, Show)

instance ParseRecord Options

getType :: Options -> [Text]
getType (Options t _) = [t]

getId :: Options -> [Text]
getId (Options _ i) = [i]

main :: IO ()
main = do
    options <- getRecord "amazonka_basic_examples - describe-tags"
    env <- newEnv Discover
    tags <- runResourceT . runAWS env . within Frankfurt $
        send $ describeTags & dtFilters .~ [filter' "resource-type" & fValues .~ getType options
                                          , filter' "resource-id" & fValues .~ getId options]
    print $ tags ^. dtrsTags