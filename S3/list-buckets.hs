-- stack --resolver lts-10.4 script

{-
Example:

- Lists all the buckets:
$ stack list-buckets.hs

-}

module Main where

import Control.Lens
import Data.Text
import Network.AWS
import Network.AWS.S3

main :: IO ()
main = do
    env <- newEnv Discover
    buckets <- runResourceT . runAWS env . within Frankfurt $
        send $ listBuckets
    print $ buckets ^. lbrsBuckets