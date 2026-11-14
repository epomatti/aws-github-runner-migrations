
```sh
cloud-init schema --config-file /path/to/your-cloud-config.yaml
```

```pwsh
multipass launch 26.04 --name cloud-aws --cloud-init .\cloud-init.yaml
```



multipass launch --name cloud-test --cloud-init cloud-init.yaml
multipass exec cloud-test -- sudo cloud-init status --wait
multipass exec cloud-test -- sudo cat /var/log/cloud-init-output.log

multipass exec cloud-test -- cloud-init query v1.distro_release
multipass exec cloud-test -- cloud-init status --long


multipass exec cloud-aws -- sudo head -n 5 /var/lib/cloud/instance/user-data.txt


# https://docs.cloud-init.io/en/latest/explanation/instancedata.html#v1