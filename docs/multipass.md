
```sh
cloud-init schema --config-file /path/to/your-cloud-config.yaml
```

```pwsh
multipass launch 26.04 --name cloud-aws --cloud-init .\cloud-init.yaml
```



multipass launch --name cloud-test --cloud-init cloud-init.yaml
multipass exec cloud-test -- sudo cloud-init status --wait
multipass exec cloud-test -- sudo cat /var/log/cloud-init-output.log