require 'ec2_helper'

def deployment_id
  ENV['DEPLOYMENT_ID']
end


def role
  ROLE['ROLE']
end

