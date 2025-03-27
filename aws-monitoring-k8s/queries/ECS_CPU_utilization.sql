SELECT 
  service_name, 
  ROUND(AVG(average)::NUMERIC, 2) AS avg_cpu 
FROM 
  aws_cloudwatch_metric_statistic_data_point 
WHERE 
  namespace = 'AWS/ECS' 
  AND metric_name = 'CPUUtilization' 
GROUP BY 
  service_name 
HAVING 
  AVG(average) > 80;  -- Alert if avg CPU > 80%
