antennahouse-cookbook
=====================

Publishing to Opscode Community
-------------------------------

First, bump the version number in metadata.rb.

Then, run a knife script to generate the `metadata.json` file from `metadata.rb`.

```
knife cookbook metadata .
```

Then, push to github and create a release after this version number.

Then, dowload the tar and upload to Opscode Community.
