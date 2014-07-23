antennahouse-cookbook
=====================

Publishing to Opscode Community
-------------------------------

First, bump the version number in metadata.rb.

Then, run a knife script to generate the `metadata.json` file from `metadata.rb`.

```
knife cookbook metadata .
```

Then, after [doing terrible things to setup knife](http://fabiorehm.com/blog/2013/10/01/sharing-chef-cookbooks/), you can run this from the cookbook repo:

```
knife cookbook site share antennahouse "Package Management"
```

You can find the `.pem` file by logging into your `getchef.com` account.
