#!/usr/bin/env stack
-- stack --resolver lts-10.4 script

{-
Example:

- Delete the tag tagged-by:amazonka_basic_examples from the resource-id:
$ stack delete-tags.hs --resource_id <resource-id>

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
    options <- getRecord "amazonka_basic_examples - delete-tags"
    env <- newEnv Discover
    res <- runResourceT . runAWS env . within Frankfurt $
        send $ deleteTags & dtsResources .~ [getId options] & dtsTags .~ [tag "tagged-by" "amazonka_basic_examples"]
    print res