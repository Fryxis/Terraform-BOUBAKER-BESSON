# Infrastructure Terraform - BOUBAKER-BESSON

Infrastructure modulaire pour deux environnements (dev/prod).

## Structure

```
Terraform-BOUBAKER-BESSON/
├── modules/
│   └── infrastructure/     # Module principal
│       ├── main.tf        # VPC, 2 VMs (count), IPs (for_each), Storage
│       ├── variables.tf   
│       ├── locals.tf
│       └── outputs.tf     
├── envs/
│   ├── dev/               # Configuration DEV
│   │   └── terraform.tfvars
│   └── prod/              # Configuration PROD
│       └── terraform.tfvars
├── main.tf                # Appel du module
├── variables.tf           
├── outputs.tf
├── provider.tf            
└── backend.tf             # Backend racine (prefix passé à l'init)
```

## Ressources créées

- **VPC** : `VPC-BOUBAKER-BESSON-{env}`
- **VM 1** : `VM-BOUBAKER-BESSON-{env}-1` avec IP statique (count)
- **VM 2** : `VM-BOUBAKER-BESSON-{env}-2` avec IP statique (count)
- **Storage** : `storage-boubaker-besson-{env}`
- **IPs statiques** : Depuis la liste (for_each)
- **Firewall** : Règles SSH

## Caractéristiques

✅ **VMs** : Créées avec `count` (2 VMs fixes)  
✅ **IPs** : Gérées avec `for_each` (flexibles)  
✅ **Shielded VM** : Configuration GCP sécurisée  
✅ **Module** : Réutilisable pour dev/prod  
✅ **Backend** : Bucket GCS partagé, states séparés par environnement

## Déploiement

### DEV
```bash
terraform init -backend-config="prefix=dev/terraform/state"
terraform apply -var-file="envs/dev/terraform.tfvars"
```

### PROD
```bash
terraform init -backend-config="prefix=prod/terraform/state"
terraform apply -var-file="envs/prod/terraform.tfvars"
```

## Outputs

Après déploiement :
```bash
terraform output
```

Affiche :
- Nom du VPC
- Noms et IPs des 2 VMs
- Nom du bucket storage
- Nombre de VMs (vm_count)

## Destruction

```bash
terraform destroy -var-file="envs/dev/terraform.tfvars"
```

## Configuration des IPs

Les IPs des VMs sont définies dans les fichiers tfvars :

**DEV :**
```hcl
vm_ips = ["35.195.100.10", "35.195.100.11"]
```

**PROD :**
```hcl
vm_ips = ["35.195.200.10", "35.195.200.11"]
```

⚠️ Assurez-vous que ces IPs sont disponibles dans votre projet GCP.
