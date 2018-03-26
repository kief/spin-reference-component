require 'ec2_helper'

def deployment_id
  ENV['DEPLOYMENT_ID']
end

def role
  ENV['ROLE']
end

def component
  ENV['COMPONENT']
end

