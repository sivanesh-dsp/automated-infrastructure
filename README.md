Here is the Sequence of terraform commands...

1. To initialize
```
terraform init
```

2. To create custom AMI
```
terraform apply -target=module.packer -auto-approve
```

3. To create instance
```
terraform apply -target=module.instance -auto-approve
```

4. To configure both jenkins and sonarqube
```
terraform apply -target=modue.docker -auto-approve
```
