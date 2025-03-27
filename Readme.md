Powerpipe Key Findings:  for SQL and Custom Control Creation Guide 

Overview 

Powerpipe allows users to create custom controls and benchmarks tailored to their organization's security and compliance needs. This document provides a step-by-step guide to creating a new control and using sql steps by step with example using Powerpipe and Steampipe. 

Prerequisites 

Before proceeding, ensure you have the following installed and configured: 

• Powerpipe – Download and install Powerpipe for your platform. 
Link: https://powerpipe.io/downloads?install=linux 
 
command: sudo /bin/sh -c "$(curl -fsSL https://powerpipe.io/install/powerpipe.sh)" 

• Steampipe – Download and install Steampipe for your platform. 
Link: https://steampipe.io/downloads?install=linux 
 
command: sudo /bin/sh -c "$(curl -fsSL https://steampipe.io/install/steampipe.sh)" 

• AWS Plugin for Steampipe – Install and configure it for accessing AWS resources. 
Install:  

Download and install the latest AWS plugin: 

Command: steampipe plugin install aws 

 
In same way change for other cloud provider 

• Steampipe Database Service – Start it using the command: 
 
--------------------------------------------------------------------------------------------------------------------- 
 
creating Mods 
For guidance on writing controls in Powerpipe, refer to: Powerpipe Documentation 

 

Step 1: Create a Mod 

 

Powerpipe organizes resources into mods (modules containing controls and benchmarks). To create a new mod: 

1. Navigate to your working directory. 

2. Run the following command to create a new mod: 

   powerpipe mod create my_custom_mod 

3. This creates a directory structure where you can define custom controls. 

Step 2: Create a Custom Control 

We will now create a control to check for untagged S3 buckets. 

Steps: 

1. Inside your mod directory, create a new file named untagged.pp. 

2. Add the following code to define the control: 

 
control "s3_untagged" { 
  title = "S3 Untagged" 
 
  sql = <<EOT 
    select 
      arn as resource, 
      case 
        when tags is not null then 'ok' 
        else 'alarm' 
      end as status, 
      case 
        when tags is not null then name || ' has tags.' 
        else name || ' has no tags.' 
      end as reason, 
      region, 
      account_id 
    from 
      aws_s3_bucket 
    EOT 
} 
 

Explanation of the Control: 

• control "s3_untagged" → Defines a new control named s3_untagged. 

• SQL Query → Retrieves S3 bucket details and checks if they have tags. 

• Columns Returned: 

•   - resource (ARN) → Identifies the bucket. 

•   - status → Returns 'ok' if tags exist, 'alarm' otherwise. 

•   - reason → Explains the tagging status. 

•   - region & account_id → Provide additional AWS context. 

Step 3: Run the Control 

Once the control is created, execute it using Powerpipe: 

powerpipe control run s3_untagged 

 
This snippet defines a control named s3_untagged, including an SQL query to find untagged S3 buckets. Note that the query returns the required control columns (resource, status, and reason), as well as additional columns, or dimensions, to provide context that is specific to AWS (region, account_id). 
 
Controls provide an easy-to-use mechanism for auditing your environment with Powerpipe. Benchmarks allow you to group and organize your controls. Let's add another control to the untagged.pp, as well as a benchmark that has both of our controls as children: 
 
-----------------------------new control or mods creation step ends here-------------------- 
 
## .Steampipe & Powerpipe SQL Queries and Kubernetes Alerting Guide 

```
aws-monitoring-k8s/
│── manifests/                   # Kubernetes YAML files
│   ├── prometheus.yaml          # Prometheus configuration
│   ├── alertmanager.yaml        # Alertmanager configuration
│   ├── cloudwatch-exporter.yaml # AWS CloudWatch Exporter deployment
│   ├── ecs-alerts.yaml          # ECS service alerts in Prometheus
│── scripts/                      # Deployment scripts
│   ├── install_tools.sh         # Install Steampipe, Powerpipe, and plugins
│   ├── deploy_k8s.sh            # Deploy all Kubernetes components
│── queries/                      # Steampipe SQL queries
│   ├── ecs_service.sql          # Query ECS service details
│── requirements.txt              # Required dependencies
│── README.md                     # Setup & Usage instructions
│── .gitignore                     # Ignore unnecessary files
```

📌 Introduction 

Steampipe is an open-source tool that enables users to query cloud services using SQL. It provides a PostgreSQL interface to retrieve data from AWS, Kubernetes, and other cloud services. 

This guide covers: 

 ✅ Installing and configuring Powerpipe & Steampipe 

 ✅ Querying AWS services using SQL commands 

 ✅ Setting up alerts in Kubernetes for AWS services 

 ✅ Exporting and automating queries 

PS: To explore available SQL queries that Powerpipe currently uses, visit: Steampipe AWS Tables 

Navigate to the relevant table page in Steampipe for detailed query options. 

 

1️⃣ Prerequisites 

Before proceeding, ensure you have the following installed and configured: 

🔹 Install Powerpipe 

Powerpipe is required for executing SQL-based queries on cloud services. 

 Download & Install: 

sudo /bin/sh -c "$(curl -fsSL https://powerpipe.io/install/powerpipe.sh)" 
  

🔗 Download Powerpipe 

 

🔹 Install Steampipe 

Steampipe provides the SQL interface for querying AWS and other cloud services. 

 Download & Install: 

sudo /bin/sh -c "$(curl -fsSL https://steampipe.io/install/steampipe.sh)" 
  

🔗 Download Steampipe 

 

🔹 Install AWS Plugin for Steampipe 

Steampipe requires plugins to interact with cloud services like AWS. 

 Install the AWS Plugin: 

steampipe plugin install aws 
  

 

2️⃣ Starting Steampipe Query Engine 

To begin querying AWS services, start the Steampipe PostgreSQL engine using: 

steampipe query 
  

This command launches an interactive PostgreSQL shell where you can execute SQL queries against AWS services. 

 

3️⃣ Querying AWS ECS Service Data 

Once inside the Steampipe query shell, you can execute SQL commands. 

🔹 Example: Retrieve ECS Service Information 

SELECT  
  service_name,  
  arn,  
  cluster_arn,  
  task_definition,  
  status  
FROM  
  aws_ecs_service; 
  

📌 How it works: 
 
![image](https://github.com/user-attachments/assets/4d83793b-2cd2-481d-bf19-403a034cfc0b)
![image](https://github.com/user-attachments/assets/d3297ef7-8895-4d4d-baa6-6b833b595a74)

aws_ecs_service is a Steampipe AWS table that holds ECS service details. 

Running this query fetches ECS service names, their ARNs, cluster ARNs, and statuses. 

This is how SQL queries can be used within Steampipe to fetch AWS cloud data. Next, we explore Kubernetes alerting based on these queries. 
 
if some services not being used:  ![image](https://github.com/user-attachments/assets/32686d7e-e819-4dcd-8cb4-3776a6686ef2)


 

4️⃣ Setting Alerts in Kubernetes for AWS Services 

Kubernetes can be used to monitor AWS services and trigger alerts based on SQL queries executed via Steampipe. 

🔹 Tools Required for Alerting 

✅ Kubernetes Cluster (EKS, Minikube, or K3s) 

 ✅ Prometheus Operator (for monitoring) 

 ✅ AWS CloudWatch Exporter (to fetch AWS data into Prometheus) 

 ✅ Grafana (for visualization) 

 ✅ Alertmanager (to send alerts via Slack, Email, or AWS SNS) 

 

5️⃣ Installing Prometheus in Kubernetes 

Install Prometheus & Alertmanager using Helm: 

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts 
helm repo update 
helm install prometheus prometheus-community/kube-prometheus-stack --namespace monitoring --create-namespace 
  

This deploys: 

Prometheus (data collection) 

Alertmanager (notifications) 

Grafana (visualization) 

 

6️⃣ Configure AWS CloudWatch Exporter 

Prometheus does not directly integrate with AWS CloudWatch, so we use the CloudWatch Exporter. 

🔹 Deploy CloudWatch Exporter in Kubernetes 

1️⃣ Create a monitoring namespace: 

kubectl create namespace monitoring 
  

2️⃣ Deploy the CloudWatch Exporter using Helm: 

helm install cloudwatch-exporter prometheus-community/prometheus-cloudwatch-exporter --namespace monitoring 
  

🔹 Configure AWS IAM for CloudWatch Exporter 

Create an IAM Role for EKS nodes with these permissions: 

{ 
  "Version": "2012-10-17", 
  "Statement": [ 
    { 
      "Effect": "Allow", 
      "Action": [ 
        "cloudwatch:GetMetricStatistics", 
        "cloudwatch:ListMetrics", 
        "ec2:DescribeInstances" 
      ], 
      "Resource": "*" 
    } 
  ] 
} 
  

Attach this IAM Role to your EKS worker nodes. 

 

7️⃣ Configure Prometheus to Scrape AWS Metrics 

Edit Prometheus config (prometheus.yaml) to collect AWS CloudWatch metrics: 

scrape_configs: 
  - job_name: "aws-cloudwatch" 
    scrape_interval: 30s 
    static_configs: 
      - targets: ["cloudwatch-exporter.monitoring.svc.cluster.local:9106"] 
  

Apply the configuration: 

kubectl apply -f prometheus.yaml 
  

 

8️⃣ Creating Alerts in Prometheus for AWS ECS Services 

🔹 Example Alert: ECS Service Running Count 

To alert if an ECS service has zero running tasks, create this alert rule: 

groups: 
  - name: aws-ecs-alerts 
    rules: 
      - alert: ECSServiceDown 
        expr: aws_ecs_service_running_count == 0 
        for: 2m 
        labels: 
          severity: critical 
        annotations: 
          summary: "ECS Service Down Alert" 
          description: "The ECS service {{ $labels.service_name }} has zero running tasks." 
  

Apply the alert rule: 

kubectl apply -f ecs-alert.yaml 
  

 

9️⃣ Sending Alerts via Alertmanager 

To send alerts via Slack, Email, or AWS SNS, configure Alertmanager: 

🔹 Slack Notification Setup in Alertmanager 

Edit alertmanager.yaml: 

route: 
  receiver: "slack-notifications" 
 
receivers: 
  - name: "slack-notifications" 
    slack_configs: 
      - channel: "#alerts" 
        api_url: "https://hooks.slack.com/services/YOUR/SLACK/WEBHOOK" 
        text: "{{ .CommonAnnotations.summary }}" 
  

Apply the configuration: 

kubectl apply -f alertmanager.yaml 
  

 

🔟 Verifying and Testing Alerts 

✅ Check Prometheus Targets 

kubectl port-forward svc/prometheus-kube-prometheus-prometheus 9090 -n monitoring 
  

Visit http://localhost:9090 and check if aws-cloudwatch is listed under Targets. 

✅ Check Alertmanager Status 

kubectl port-forward svc/prometheus-kube-prometheus-alertmanager 9093 -n monitoring 
  

Visit http://localhost:9093 to check alerts. 

✅ Trigger a Test Alert 

Create a test alert: 

groups: 
  - name: test-alerts 
    rules: 
      - alert: TestEmailAlert 
        expr: vector(1) == 1 
        for: 1m 
        labels: 
          severity: critical 
        annotations: 
          summary: "Test Email Alert" 
          description: "This is a test alert to verify email notifications." 
  

Apply: 

kubectl apply -f ecs-alert.yaml 
  

Wait 1-2 minutes and check for alerts. 

 

🔹 Conclusion 

🚀 You have successfully set up AWS monitoring and alerting in Kubernetes! 

 This guide covered: 

 ✅ Installing Powerpipe & Steampipe for querying AWS 

 ✅ Running SQL queries using Steampipe 

 ✅ Setting up Kubernetes-based monitoring using Prometheus 

 ✅ Configuring alerts for AWS services (ECS, EC2, RDS, Lambda) 

 ✅ Sending notifications via Slack, Email, or AWS SNS 

Would you like additional custom queries, dashboards, or integrations for your AWS services? 🚀 

 
 
 
 
 
 
 
 
 
 
 
 
