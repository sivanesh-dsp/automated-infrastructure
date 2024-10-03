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

4. To pull and run SonarQube
```
terraform apply -target=modue.docker -auto-approve
```

5. To configure and integrate Jenkins and SonarQube
```
terraform apply -target=module.ansible -auto-approve
```
