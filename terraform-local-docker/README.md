# Automação Kubernetes Local (k3d)

Este diretório contém a automação em Terraform para criar um ambiente de desenvolvimento Kubernetes local rodando no Docker usando o **k3d**.

## Pré-requisitos

1. **Docker**: Instalado e rodando.
2. **Terraform**: Instalado (v1.5.0+).
3. **k3d**: Instalado (necessário para o provider).
4. **kubectl**: Para interagir com o cluster.

## Componentes Instalados

Por padrão, esta automação instala:
- **ArgoCD**: Ferramenta de GitOps.
- **Argo Rollouts**: Controller para estratégias avançadas de deployment (Canary, Blue/Green).
- **KEDA**: Event-driven Autoscaling.
- **External Secrets**: Integração de segredos com provedores externos.
- **Metrics Server**: Coleta de métricas de recursos (necessário para o HPA/KEDA).

## Como usar

1. Entre no diretório:
   ```bash
   cd terraform-local-docker
   ```

2. Inicialize o Terraform:
   ```bash
   terraform init
   ```

3. Aplique a configuração:
   ```bash
   terraform apply
   ```

4. Verifique a instalação:
   ```bash
   kubectl get pods -A
   ```

## Variáveis Disponíveis

Você pode desabilitar componentes específicos no arquivo `variables.tf` ou via linha de comando:
- `enable_argocd` (default: true)
- `enable_argo_rollouts` (default: true)
- `enable_keda` (default: true)
- `enable_external_secrets` (default: true)

Exemplo: `terraform apply -var="enable_keda=false"`
