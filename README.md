# Infrastructure Terraform - BOUBAKER-BESSON

> Infrastructure modulaire et scalable pour deux environnements (DEV & PROD) sur Google Cloud Platform

![Terraform](https://img.shields.io/badge/Terraform-v1.0+-623CE4?style=flat-square&logo=terraform)
![GCP](https://img.shields.io/badge/GCP-Google%20Cloud-4285F4?style=flat-square&logo=google-cloud)
![Ansible](https://img.shields.io/badge/Ansible-Automation-EE0000?style=flat-square&logo=ansible)

---

## 📁 Architecture du Projet

```
Terraform-BOUBAKER-BESSON/
├── 📂 modules/
│   └── infrastructure/              # Module réutilisable
│       ├── main.tf                  # Ressources: VPC, VMs, Storage, IPs
│       ├── variables.tf             # Variables du module
│       ├── locals.tf                # Variables locales
│       └── outputs.tf               # Sorties du module
│
├── 📂 envs/                         # Configurations par environnement
│   ├── dev/
│   │   └── terraform.tfvars         # Variables de développement
│   └── prod/
│       └── terraform.tfvars         # Variables de production
│
├── main.tf                          # Point d'entrée principal
├── variables.tf                     # Variables globales
├── outputs.tf                       # Sorties principales
├── provider.tf                      # Configuration du provider GCP
└── backend.tf                       # État distant (GCS)
```

---

## Ressources Créées

| Ressource | Description | Environnements |
|-----------|-------------|-----------------|
| **VPC** | Réseau privé virtuel | `VPC-BOUBAKER-BESSON-{env}` |
| **VMs** | 2 machines virtuelles (count) | `VM-BOUBAKER-BESSON-{env}-1/2` |
| **IPs Statiques** | Adresses IP publiques (for_each) | Gérées par boucle |
| **Storage** | Bucket de stockage | `storage-boubaker-besson-{env}` |
| **Firewall** | Règles réseau | Accès SSH configuré |

---

## Caractéristiques Principales

- ✅ **Modules réutilisables** - Code DRY pour dev/prod
- ✅ **IaC complète** - Infrastructure as Code avec Terraform
- ✅ **Gestion du state** - Backend GCS centralisé
- ✅ **Shielded VMs** - Configuration sécurisée GCP
- ✅ **Dynamique** - Count pour les VMs, for_each pour les IPs
- ✅ **Multi-env** - Dev et Prod avec séparation claire
- ✅ **Ansible ready** - Intégration avec playbooks de configuration

---

## Configuration Rapide

### Environnement DEV

```bash
# Initialiser Terraform avec le backend DEV
terraform init -backend-config="prefix=dev/terraform/state"

# Planifier les modifications
terraform plan -var-file="envs/dev/terraform.tfvars"

# Appliquer la configuration
terraform apply -var-file="envs/dev/terraform.tfvars"
```

### Environnement PROD

```bash
# Initialiser Terraform avec le backend PROD
terraform init -backend-config="prefix=prod/terraform/state"

# Planifier les modifications
terraform plan -var-file="envs/prod/terraform.tfvars"

# Appliquer la configuration
terraform apply -var-file="envs/prod/terraform.tfvars"
```

---

## Afficher les Outputs

Après un déploiement réussi, visualisez les informations :

```bash
terraform output
```

**Informations affichées :**
- Nom du VPC créé
- Noms et IPs des 2 VMs
- Nom du bucket storage
- Nombre de VMs déployées

---

## Destruction de l'Infrastructure

**Attention** - Cette action est irréversible

```bash
terraform destroy -var-file="envs/dev/terraform.tfvars"
```

---

## Configuration des Adresses IP

Les IPs statiques sont définies dans les fichiers de variables par environnement :

#### DEV - `envs/dev/terraform.tfvars`
```hcl
vm_ips = ["35.195.100.10", "35.195.100.11"]
```

#### PROD - `envs/prod/terraform.tfvars`
```hcl
vm_ips = ["35.195.200.10", "35.195.200.11"]
```

**Validation requise** : Assurez-vous que ces IPs sont disponibles dans votre projet GCP avant le déploiement.

---

# QUESTIONS - PARTIE 1 
## Concepts Terraform

### T1. À quoi sert le fichier terraform.tfstate ?

Fichier JSON contenant la cartographie actuelle de votre infrastructure.
Permet à Terraform de savoir quelles ressources il gère déjà et d'identifier les changements à apporter.
S'il est perdu ou corrompu, Terraform pensera tout recréer, causant des conflits.

---

### T2. Quelle est la différence entre terraform plan et terraform apply ?

Le Plan va génèrer un rapport des changement à venir
Le Apply Exécute les changements et met à jour le state 

---

### T3. Pourquoi utiliser des variables dans Terraform ?

- **Modularité** - Code réutilisable pour dev/prod
- **Flexibilité** - Modifier une valeur en un seul endroit
- **Sécurité** - Données sensibles injectées à l'exécution

---

### T4. Que se passe-t-il si une ressource créée par Terraform est supprimée manuellement ?

Terraform détecte le drift et propose de recréer la ressource pour restaurer la conformité.

---
# QUESTIONS - PARTIE 2
## Concepts Ansible

### A1. Qu’est-ce que l’idempotence en Ansible ?

Une opération peut être appliquée plusieurs fois sans changer le résultat au-delà de la première application.

---

### A2. À quoi sert un handler ?

Tâches spéciales qui s'exécutent **UNIQUEMENT si notifiées** par une tâche ayant provoqué un changement.

---

### A3. Quelle est la différence entre un inventory statique et dynamique ?

Inventaire Statique : Fichier texte qui se nomme hosts.ini avec des IPs et nom nom fqdn entrée manuellement

Inventaire Dynamique :Script/API qui récypère les serveurs en temps réel pointant souvant sur un CMBD

---

### A4. Quelle commande permet de tester un playbook sans appliquer de changements ?

```bash
ansible-playbook site.yml --check
```

---
# QUESTION - PARTIE 3
## Intégration Terraform + Ansible

### Expliquer comment récupérer l’adresse IP de la VM créée par Terraform pour l’utiliser dans Ansible

**3 étapes clés :**

**1️⃣ Définir un Output dans Terraform**
```hcl
# modules/infrastructure/outputs.tf
output "vm_ips" {
  value = google_compute_instance.vms[*].network_interface[0].access_config[0].nat_ip
}
```

**2️⃣ Extraire via la CLI**
```bash
IPS=$(terraform output -json vm_ips | jq -r '.[]')
```

**3️⃣ Passer à Ansible**
```bash
ansible-playbook -i "$IPS," site.yml
```

---

### Expliquer pourquoi Ansible doit être exécuté après Terraform

**4 raisons essentielles :**
**Existence des cibles** Ansible a besoin d'une IP et d'accès SSH. Terraform doit créer la VM en premier |
**Gestion des accès** Terraform injecte la clé SSH publique dans les metadata. Ansible en a besoin |
**Séparation des responsabilités** Terraform = infrastructure, Ansible = configuration logicielle |
**Données dynamiques** Les IPs générées par Terraform doivent être disponibles pour Ansible |

---
# QUESTIONS FINALES
### Pourquoi est-il déconseillé d'exécuter Ansible avant Terraform ?

Il est techniquement et logiquement déconseillé d'exécuter Ansible avant Terraform pour plusieurs raisons majeures :

**Absence de cible** Ansible a besoin d'un serveur existant (IP + accès SSH). Terraform crée la VM - sans infrastructure, Ansible n'a aucune destination. 
**Dépendance des accès** Terraform gère le réseau (VPC, Firewall) et injecte les clés SSH publiques. Ansible lancé avant sera bloqué par le pare-feu ou refusé faute de clé autorisée. 
**Données dynamiques** L'inventaire Ansible dépend des IPs générées par Terraform. On ne peut pas utiliser des données qui n'existent pas encore. 


**Règle d'or :** Infrastructure d'abord (Terraform), configuration ensuite (Ansible)

### Donner un avantage et un inconvénient de l'approche Terraform + Ansible

#### Avantage : Spécialisation des outils

**Terraform** Infrastructure (IaC), Gestion d'état, dépendances réseau, cycle de vie des ressources 
**Ansible** Configuration Idempotence, gestion logicielle, fichiers de configuration 

---

#### Inconvénient : Complexité de l'orchestration

**Le défi :** Deux outils = deux écosystèmes à maîtriser

**Syntaxes multiples** HCL (Terraform) + YAML (Ansible) à connaître 
**Transfert de données** Variables d'environnement, fichiers JSON, inventaires dynamiques 
**Pipeline CI/CD** Orchestration plus complexe, plus d'étapes à gérer 

---

## Pipeline Recommandé

```
1. Terraform init
   ↓
2. Terraform plan
   ↓
3. Terraform apply  ← Infrastructure créée
   ↓
4. terraform output  ← IPs extraites
   ↓
5. ansible-playbook  ← Configuration appliquée
```

---

## Liens Utiles

- [Documentation Terraform](https://www.terraform.io/docs)
- [Google Cloud Provider Terraform](https://registry.terraform.io/providers/hashicorp/google)
- [Documentation Ansible](https://docs.ansible.com/)
- [Ansible Best Practices](https://docs.ansible.com/ansible/latest/tips_tricks/index.html)

---

