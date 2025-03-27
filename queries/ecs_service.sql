SELECT 
  service_name, 
  arn, 
  cluster_arn, 
  task_definition, 
  status 
FROM 
  aws_ecs_service;
