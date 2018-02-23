# Examples of interfaces with S3 infrastructure

This scripts are basic interface examples with S3, make sure to have [stack](https://docs.haskellstack.org/en/stable/README/) installed.

* List all the buckets.
```
$ stack list-buckets.hs
``
* Put the script itself in an existing bucket.
```
$ stack put-object.hs --bucket <bucket>
```