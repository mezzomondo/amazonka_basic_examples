#!/usr/bin/env stack
-- stack --resolver lts-10.4 script

{-
Example:

- Create the tag tagged-by:amazonka_basic_examples for the resource-id:
$ stack create-tags.hs --resource_id <resource-id>

-}

{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import Control.Lens
import Data.Text
import Network.AWS
import Network.AWS.EC2
import Options.Generic

newtype Options = Options {resource_id :: Text} deriving (Generic, Show)

instance ParseRecord Options

getId :: Options -> Text
getId (Options i) = i

main :: IO ()
main = do
    options <- getRecord "amazonka_basic_examples - create-tags"
    env <- newEnv Discover
    res <- runResourceT . runAWS env . within Frankfurt $
        send $ createTags & cResources .~ [getId options] & cTags .~ [tag "tagged-by" "amazonka_basic_examples"]
    print res