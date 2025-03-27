Running the Setup After Cloning the Repository
After cloning the repository, follow these steps to set up the environment:

1️⃣ Clone the Repository
sh
.
git clone https://github.com/your-username/aws-monitoring-k8s.git
cd aws-monitoring-k8s
2️⃣ Install Dependencies
sh
.
chmod +x scripts/install_tools.sh
./scripts/install_tools.sh
3️⃣ Deploy Kubernetes Monitoring Stack
sh
.
chmod +x scripts/deploy_k8s.sh
./scripts/deploy_k8s.sh
4️⃣ Verify Installation
✅ Check if Prometheus is Running:

sh
.
kubectl get pods -n monitoring
✅ Forward Prometheus UI:

sh
.
kubectl port-forward svc/prometheus-kube-prometheus-prometheus 9090 -n monitoring
Access Prometheus UI at http://localhost:9090.

✅ Check if CloudWatch Exporter is Running:

sh
.
kubectl get pods -n monitoring | grep cloudwatch
5️⃣ Run SQL Queries in Steampipe
Start the Steampipe query shell:

sh
.
steampipe query
Run the ECS service query:

sql
.
SELECT * FROM aws_ecs_service;
7️⃣ Additional Enhancements
💡 Automate with GitHub Actions:

You can create a GitHub Actions pipeline to automatically deploy these Kubernetes configurations.

Example workflow:

Push to main branch → Deploy Kubernetes YAML files → Send notification

------------------------------------------

CI/CD
## **📌 Automating Kubernetes Deployment with GitHub Actions**  

This guide explains how to automate the deployment of Kubernetes monitoring stack using **GitHub Actions**. The workflow will:  
✅ Install dependencies  
✅ Authenticate with AWS & Kubernetes  
✅ Deploy all Kubernetes manifests  

---

## **1️⃣ GitHub Repository Structure (Updated)**  

Modify your repo structure to include a `.github/workflows` directory:  

```plaintext
aws-monitoring-k8s/
│── manifests/                   # Kubernetes YAML files
│   ├── prometheus.yaml
│   ├── alertmanager.yaml
│   ├── cloudwatch-exporter.yaml
│   ├── ecs-alerts.yaml
│── scripts/                      # Deployment scripts
│   ├── install_tools.sh
│   ├── deploy_k8s.sh
│── queries/                      # Steampipe SQL queries
│   ├── ecs_service.sql
│── .github/workflows/            # GitHub Actions workflows
│   ├── deploy.yaml               # Workflow to deploy Kubernetes manifests
│── requirements.txt
│── README.md
│── .gitignore
```

---

## **2️⃣ Create GitHub Actions Workflow File**  

Create a file: **`.github/workflows/deploy.yaml`**  

```yaml
name: Deploy to Kubernetes

on:
  push:
    branches:
      - main

jobs:
  deploy:
    name: Deploy to Kubernetes
    runs-on: ubuntu-latest

    steps:
    - name: Checkout repository
      uses: actions/checkout@v3

    - name: Install AWS CLI
      run: |
        sudo apt-get update
        sudo apt-get install -y awscli

    - name: Configure AWS Credentials
      uses: aws-actions/configure-aws-credentials@v2
      with:
        aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
        aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        aws-region: us-east-1

    - name: Install kubectl
      run: |
        curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
        chmod +x kubectl
        sudo mv kubectl /usr/local/bin/

    - name: Configure kubectl with EKS
      run: |
        aws eks update-kubeconfig --region us-east-1 --name YOUR_EKS_CLUSTER_NAME

    - name: Deploy Kubernetes Manifests
      run: |
        kubectl apply -f manifests/

    - name: Verify Deployment
      run: |
        kubectl get pods -n monitoring
```

---

## **3️⃣ Configuring GitHub Secrets**  

Go to **GitHub Repository → Settings → Secrets and Variables → Actions → New Repository Secret** and add:  
- `AWS_ACCESS_KEY_ID`: Your AWS Access Key  
- `AWS_SECRET_ACCESS_KEY`: Your AWS Secret Key  
- `YOUR_EKS_CLUSTER_NAME`: Name of your Amazon EKS cluster  

---

## **4️⃣ How It Works**  

1️⃣ **Push Changes to `main` Branch**  
Whenever you push changes to the `main` branch, GitHub Actions will:  
- Install AWS CLI & kubectl  
- Authenticate with AWS  
- Configure `kubectl` for EKS  
- Deploy Kubernetes YAML files  

2️⃣ **Check GitHub Actions Workflow**  
- Go to **GitHub → Actions**  
- Check the workflow status  
- If successful, Kubernetes deployment is complete 🚀  

---

## **5️⃣ Verify Deployment Manually**  

Run the following commands to verify deployment:  

✅ **Check running pods:**  
```sh
kubectl get pods -n monitoring
```
✅ **Check services:**  
```sh
kubectl get svc -n monitoring
```

---

## **6️⃣ Bonus: Add Slack Notifications to GitHub Actions**  

You can modify the workflow to send notifications to **Slack** when deployment is completed.  

### **🔹 Update `deploy.yaml` to Add Slack Notifications**  

```yaml
    - name: Send Slack Notification
      uses: rtCamp/action-slack-notify@v2
      env:
        SLACK_WEBHOOK: ${{ secrets.SLACK_WEBHOOK_URL }}
        SLACK_MESSAGE: "✅ Kubernetes deployment completed successfully!"
```

🔹 **Configure Slack Webhook:**  
- Go to [Slack API](https://api.slack.com/messaging/webhooks)  
- Generate a webhook and add it to **GitHub Secrets** as `SLACK_WEBHOOK_URL`  

---

## **7️⃣ Conclusion**  

✅ **GitHub Actions automates Kubernetes deployments**  
✅ **Secrets securely store AWS credentials**  
✅ **Push to `main` triggers automatic deployment**  
✅ **Slack notifications provide deployment status**  

----------------------------