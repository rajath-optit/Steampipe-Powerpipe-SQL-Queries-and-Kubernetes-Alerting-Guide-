SELECT 
  instance_id, 
  instance_state, 
  jsonb_pretty(tags) AS tags 
FROM 
  aws_ec2_instance 
WHERE 
  NOT EXISTS (
    SELECT 1 FROM jsonb_object_keys(tags) AS keys 
    WHERE keys IN ('Environment', 'Owner')
  );
