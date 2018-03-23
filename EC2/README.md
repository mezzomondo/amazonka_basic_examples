# Examples of interfaces with EC2 infrastructure

This scripts are basic interface examples with EC2, make sure to have [stack](https://docs.haskellstack.org/en/stable/README/) installed.

* Describe tags for the instance-id. The instance-id must be of the form i-03ae1031abaad7ac6.
```
$ stack describe-tags.hs --resource_type instance --resource_id <instance-id>
```
* Describe tags for the AMI-id. The AMI-id must be of the form ami-0a497f10cbf37d2d1.
```
$ stack describe-tags.hs --resource_type image --resource_id <AMI-id>
```
* Create the tag tagged-by:amazonka_basic_examples for the resource-id. The resource-id can be any of the supported id (i-03ae1031abaad7ac6 for instances, ami-0a497f10cbf37d2d1 fo AMIs etc.)
```
$ stack create-tags.hs --resource_id <resource-id>
```
* Delete the tag tagged-by:amazonka_basic_examples from the resource-id. The resource-id can be any of the supported id (i-03ae1031abaad7ac6 for instances, ami-0a497f10cbf37d2d1 fo AMIs etc.)
```
$ stack delete-tags.hs --resource_id <resource-id>
```
* Describes all the instances.
```
$ stack describe-instances.hs
```
* Describes a specific instance. The instance_ids must be of the form i-03ae1031abaad7ac6.
```
$ stack describe-instances.hs --instance_ids <instance-id>
```
* Describes multiple instances at once. The instance_idx must be of the form i-03ae1031abaad7ac6.
```
$ stack describe-instances.hs --instance_ids <instance-id1> --instance_ids <instance-id2> --instance_ids <instance-id3>
```
* Create instance, dry run is set so no action will take place.
```
$ stack create-instance.hs --ami_id <ami-id> --subnet_id <subnet-id>
```
* Create instance and wait until is available, dry run is NOT set so action WILL take place.
```
$ stack create-instance-await.hs --ami_id <ami-id> --subnet_id <subnet-id>
```