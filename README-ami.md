## Windows - Amazon Import AMIs

VirtualBox Hypervisor is used to build a local vm and then imported as an AMI using
the amazon import service https://docs.aws.amazon.com/vm-import/latest/userguide/vmimport-image-import.html.

## Requirements

* Set your aws credentials on the default location `~/.aws/credentials`. https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html
* Packer 1.2.3+. https://www.packer.io/downloads.html
* S3 Bucket with the necessary permissions. Set the `AWS_S3_BUCKET` environment variable.
* If you use SAML authentication make sure you set `profile` in the amazon-import post-processor.
* `vm-guest-tools` provisioner is removed.
