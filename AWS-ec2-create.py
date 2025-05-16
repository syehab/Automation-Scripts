import os
import boto3
import datetime

# Set the environment variable to use the custom credentials file
os.environ['AWS_SHARED_CREDENTIALS_FILE'] = './creds.ini'

# Use default profile from that file
session = boto3.Session(profile_name='automation')

ec2_client = session.client('ec2')  # For key pair creation (client needed)
ec2_resource = session.resource('ec2')  # For EC2 instance creation

# Create a unique key pair name using timestamp to avoid collisions
key_name = 'my-key-' + datetime.datetime.now().strftime("%Y%m%d%H%M%S")

# Create a new key pair
key_pair = ec2_client.create_key_pair(KeyName=key_name)

# Save the private key to a .pem file with restricted permissions
private_key = key_pair['KeyMaterial']
pem_file = f"{key_name}.pem"
with open(pem_file, 'w') as file:
    file.write(private_key)
os.chmod(pem_file, 0o400)  # Restrict permissions (read-only for user)

print(f"Key pair '{key_name}' created and saved to {pem_file}")

# Launch EC2 instance with the new key pair
response = ec2_resource.create_instances(
    ImageId='ami-0af9569868786b23a',
    InstanceType='t2.micro',
    MinCount=1,
    MaxCount=1,
    KeyName=key_name,
    TagSpecifications=[
        {
            'ResourceType': 'instance',
            'Tags': [
                {'Key': 'Name', 'Value': 'AWS-Infra-Automation'}
            ]
        }
    ]
)

instance = response[0]
instance_id = instance.id

print(f"EC2 instance created: {instance_id}")

print("Waiting for instance to be running...")
instance.wait_until_running()
instance.load()  # Reload to get latest info

# Output connection info
public_ip = instance.public_ip_address
default_user = 'ec2-user'

print(f"Public IP: {public_ip}")
print(f"Default SSH user: {default_user}")
print(f"SSH Command: ssh -i {pem_file} {default_user}@{public_ip}")