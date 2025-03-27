#Deploy Kubernetes Monitoring Stack
#!/bin/bash

# Create monitoring namespace
kubectl create namespace monitoring

# Deploy Prometheus
kubectl apply -f manifests/prometheus.yaml

# Deploy Alertmanager
kubectl apply -f manifests/alertmanager.yaml

# Deploy CloudWatch Exporter
kubectl apply -f manifests/cloudwatch-exporter.yaml

# Deploy ECS Alerting Rules
kubectl apply -f manifests/ecs-alerts.yaml

echo "✅ Kubernetes monitoring stack deployed successfully!"
