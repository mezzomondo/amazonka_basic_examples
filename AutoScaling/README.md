# Examples of interfaces with AutoScaling infrastructure

This scripts are basic interface examples with AutoScaling, make sure to have [stack](https://docs.haskellstack.org/en/stable/README/) installed.

* Set or update office hours schedule for an existing autoscaling group:
```
$ stack set-update-schedule.hs --group_name <autoscaling group>
```