import os
import sys
import time
from typing import Dict
from urllib import response
from markupsafe import string
import requests
import re
import boto3
import paramiko
import json
from scp import SCPClient


def print_alb_dns_names():
    elbList = boto3.client('elbv2')
    bals = elbList.describe_load_balancers()

    print("\nLoadBalancers:")

    for elb in bals['LoadBalancers']:
        print(elb['DNSName'])

    pass

def print_jenkins_nodes_ip(boto3_ec2):
    running_instances = boto3_ec2.instances.filter(Filters=[
        {'Name': 'tag:service', 'Values': ['jenkins']},
        {'Name': 'tag:instance_type', 'Values': ['node']},
        {'Name': 'instance-state-name', 'Values': ['running']}
    ])

    count = 1
    for instance in running_instances:
        print("jenkins_node{0}_ip: {1}".format(
            count, instance.private_ip_address))
        count += 1
    pass

def get_bastion_host_ip(boto3_ec2, get_public_ip: bool):
    running_instances = boto3_ec2.instances.filter(Filters=[
        {'Name': 'tag:service_role', 'Values': ['bastion']},
        {'Name': 'instance-state-name', 'Values': ['running']},
    ])
    for instance in running_instances:
        if get_public_ip is True:
            return instance.public_ip_address
        else:
            return instance.private_ip_address

def get_jenkins_server_ip(boto3_ec2):
    running_instances = boto3_ec2.instances.filter(Filters=[
        {'Name': 'tag:service', 'Values': ['jenkins']},
        {'Name': 'tag:instance_type', 'Values': ['server']},
        {'Name': 'instance-state-name', 'Values': ['running']}
    ])
    for instance in running_instances:
        return instance.private_ip_address

def get_ansible_server_ip(boto3_ec2):
    running_instances = boto3_ec2.instances.filter(Filters=[
        {'Name': 'tag:service', 'Values': ['ansible']},
        {'Name': 'tag:instance_type', 'Values': ['server']},
        {'Name': 'instance-state-name', 'Values': ['running']}
    ])
    for instance in running_instances:
        return instance.private_ip_address

def get_consul_servers_amount(boto3_ec2):
    count = 0
    running_instances = boto3_ec2.instances.filter(Filters=[
        {'Name': 'tag:service_role', 'Values': ['service_discovery']},
        {'Name': 'tag:instance_type', 'Values': ['server']},
        {'Name': 'instance-state-name', 'Values': ['running']}
    ])
    for instance in running_instances:
        count = count + 1
    return count

def ssh_client_connection(target_host_ip, ssh_user_name, private_key_file_path):
    try:
        host_ssh_client = paramiko.SSHClient()
        host_ssh_client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        host_ssh_client.connect(
            target_host_ip, username=ssh_user_name, key_filename=private_key_file_path)

        return host_ssh_client

    except Exception:
        print(f"Error Connecting To: {0}".format(target_host_ip))
        exit()

def ssh_client_connection_throgh_bastion_host(bastion_host_ssh_client, bastion_host_private_ip, target_host_ip, ssh_user_name, private_key_file_path):
    try:
        bastion_host_transport = bastion_host_ssh_client.get_transport()
        src_addr = (bastion_host_private_ip, 22)
        dest_addr = (target_host_ip, 22)
        bastion_host_channel = bastion_host_transport.open_channel(
            "direct-tcpip", dest_addr, src_addr)

        target_host_ssh_client = paramiko.SSHClient()
        target_host_ssh_client.set_missing_host_key_policy(
            paramiko.AutoAddPolicy())
        target_host_ssh_client.connect(target_host_ip, username=ssh_user_name,
                                       key_filename=private_key_file_path, sock=bastion_host_channel)

        return target_host_ssh_client

    except Exception:
        print(f"Error Connecting To: {0} Through Bastion Host".format(target_host_ip))
        exit()

def close_ssh_session(host_ssh_client, session_name):
    host_ssh_client.close()
    print("Closed SSH Session To: {0}".format(session_name))

def ssh_run_commands(target_ssh_client: paramiko.client.SSHClient, commands: list):
    for command in commands:
        print("\n\n", "="*25, command, "="*25, "\n")
        stdin, stdout, stderr = target_ssh_client.exec_command(command)
        while True:
            line = stdout.readline()
            if not line:
                break
            print(line, end="")

def progress(filename, size, sent):
    sys.stdout.write("Copying: %s - Progress: %.2f%%   \n" %
                     (filename, float(sent)/float(size)*100))

def scp_file_copy(ssh_session: paramiko.client.SSHClient, file: str, remote_path):
    with SCPClient(ssh_session.get_transport(), progress=progress) as scp:
        scp.put(file, remote_path=remote_path, recursive=True)

def ansible_install_configure_deploy(ansible_ssh_client: paramiko.client.SSHClient, vars_dict):
    ansible_folder = "/home/ubuntu/kandula/Ansible"
    consul_dc_name = "kandula-dc"
    consul_servers_count = vars_dict['consul_servers_count']
    k8s_cluster_name = vars_dict['k8s_cluster_name']
    aws_default_region = vars_dict['aws_default_region']

    scp_file_copy(ansible_ssh_client,
                  private_key_file_path, '/home/ubuntu/.ssh/id_rsa')

    configure_ssh = [
        "chmod 600 /home/ubuntu/.ssh/id_rsa",
        "sudo sed -i 's/#   StrictHostKeyChecking ask/    StrictHostKeyChecking no/g' /etc/ssh/ssh_config"
    ]

    install_ansible = [
        "sudo apt update", "sudo apt install software-properties-common",
        "sudo add-apt-repository --yes --update ppa:ansible/ansible",
        "sudo apt install ansible -y",
        "sudo apt install python-boto3 -y"
    ]

    install_ansible_modules = [
        "ansible-galaxy collection install community.general",
        "ansible-galaxy collection install amazon.aws",
        "ansible-galaxy collection install community.docker"
    ]

    clone_ansible_repo = [
        "git clone -b final-project https://github.com/OfirGan/kandula.git /home/ubuntu/kandula"
    ]

    run_ansible_playbook = [
        f'ansible-playbook {ansible_folder}/main.yml -i {ansible_folder}/aws_ec2.yml -e "consul_servers_count={consul_servers_count} consul_dc_name={consul_dc_name} eks_cluster_name={k8s_cluster_name} aws_default_region={aws_default_region}"'
    ]


    ssh_run_commands(ansible_ssh_client, 
        configure_ssh + 
        install_ansible + 
        install_ansible_modules + 
        clone_ansible_repo + 
        run_ansible_playbook
    )

    pass

def ansible_deploy_through_bastion_host(boto3_ec2, ec2_user_name, private_key_file_path):
    bastion_host_public_ip = get_bastion_host_ip(boto3_ec2, True)
    bastion_host_private_ip = get_bastion_host_ip(boto3_ec2, False)
    ansible_server_ip = get_ansible_server_ip(boto3_ec2)

    bastion_ssh_client = ssh_client_connection(
        bastion_host_public_ip, ec2_user_name, private_key_file_path)

    ansible_ssh_client = ssh_client_connection_throgh_bastion_host(
        bastion_ssh_client, bastion_host_private_ip, ansible_server_ip, ec2_user_name, private_key_file_path)

    ssh_run_commands(bastion_ssh_client, ["sudo sed -i 's/#   StrictHostKeyChecking ask/    StrictHostKeyChecking no/g' /etc/ssh/ssh_config"])

    ansible_install_configure_deploy(ansible_ssh_client, vars_dict)

    close_ssh_session(ansible_ssh_client, "Ansible Server")
    close_ssh_session(bastion_ssh_client, "Bastion Host")
    pass

def create_dict_from_tfvars_file(tfvars_file_path):
    os.chdir(sys.path[0])

    tfvars_dict = {}

    with open(tfvars_file_path, "r") as tfvars_file:
        for line in tfvars_file.readlines():
            line_no_spaces = line.strip('\n').replace(" ", "")
            if not line.startswith("#"):
                # Add String value
                for key, value in re.findall(r'(\S+)="(\S+)"', line_no_spaces):
                    tfvars_dict[key] = value.strip('"')

                # Add Int Value
                for key, value in re.findall(r'(\S+)=([0-9]+)', line_no_spaces):
                    tfvars_dict[key] = int(value)

                # Add List \ Boolean Value
                for key, value in re.findall(r'(\S+)=(\[.*?\]|true|false)', line_no_spaces):
                    tfvars_dict[key] = value

    return tfvars_dict

def deploy_terraform(tfvars_file_path):
    os.chdir(sys.path[0])
    os.chdir("Terraform")
    os.system("terraform init")
    os.system(f"terraform plan -var-file {tfvars_file_path} -out plan.tfstate -compact-warnings")
    os.system("terraform apply plan.tfstate")
    os.chdir("..")

def destroy_terraform(tfvars_file_path):
    os.chdir(sys.path[0])
    os.chdir("Terraform")
    os.system(f"terraform destroy -var-file {tfvars_file_path} -compact-warnings")
    os.chdir("..")

def create_tfe_api_session(tfe_token : string):
    session = requests.Session()
    session.headers.update(
        {
            "Authorization": f"Bearer {tfe_token}",
            "Content-Type": "application/vnd.api+json",
        }
    )
    return session

def get_workspaces_names_list(session : requests.Session, organization_name : string):
    response = session.get(
        f"https://app.terraform.io/api/v2/organizations/{organization_name}/workspaces"
    ).json()
    
    if 'errors' in response:
        print(f"Can't Get Data from TFC Organization - {organization_name}")
        exit()
    else:
        workspaces_names_list = []
        for workspace in response['data']:
            workspaces_names_list.append(workspace['attributes']['name'])

        return workspaces_names_list

def get_workspace_vars_dict(session : requests.Session, organization_name : string , workspace_name : string):
    response = session.get(
        f"https://app.terraform.io/api/v2/vars?filter%5Borganization%5D%5Bname%5D={organization_name}&filter%5Bworkspace%5D%5Bname%5D={workspace_name}" 
    ).json()
    vars_dict = {}
    for var in response['data']:
        dict_key = var['attributes']['key']
        dict_value = var['attributes']['value']
        vars_dict[dict_key] = dict_value
    return vars_dict

def get_all_workspaces_vars_dict(session : requests.Session, organization_name : string ):
    workspaces_names_list = get_workspaces_names_list(session, organization_name)

    vars_dict_all = {}
    for workspace_name in workspaces_names_list:
        workspace_vars_dict = get_workspace_vars_dict(session, organization_name, workspace_name)
        vars_dict_all.update(workspace_vars_dict)

    return vars_dict_all

def get_workspace_id(session : requests.Session, organization_name : string, workspace_name):
    response = session.get(
        f"https://app.terraform.io/api/v2/organizations/{organization_name}/workspaces?search%5Bname%5D={workspace_name}"
    ).json()

    workspace_id = response["data"][0]["id"]
    return workspace_id

def run_workspace(session : requests.Session, workspace_id : string, is_destroy : bool):
    payload = json.dumps(
        {
            "data": {
                "attributes": {"is-destroy": is_destroy},
                "type": "runs",
                "relationships": {
                    "workspace": {"data": {"type": "workspaces", "id": workspace_id}}
                },
            }
        }
    )

    response = session.post("https://app.terraform.io/api/v2/runs", payload).json()

    run_id = response["data"]["id"]    
    return run_id

def wait_run_to_be_in_status_x(session : requests.Session, run_id : string, run_end_status : string):
    response = session.get(f"https://app.terraform.io/api/v2/runs/{run_id}").json()
    run_status = response["data"]["attributes"]["status"]

    while(run_status != run_end_status):
        time.sleep(2)
        
        response = session.get(f"https://app.terraform.io/api/v2/runs/{run_id}").json()
        run_status = response["data"]["attributes"]["status"]

        if(run_status == "errored"):
            print("Run Errored")
            exit()
    pass

def apply_run(session : requests.Session, run_id : string):
    response = session.post(f"https://app.terraform.io/api/v2/runs/{run_id}/actions/apply").json()
    pass

def run_and_apply_workspace(session : requests.Session, organization_name : string, workspace_name : string, is_destroy : bool):
    destroy_or_deploy_txt = 'Destroy' if is_destroy else 'Deploy'
    workspace_id = get_workspace_id(session, organization_name, workspace_name)
    run_id =  run_workspace(session, workspace_id, is_destroy)
    wait_run_to_be_in_status_x(session, run_id, "planned")
    print(f"Workspace {workspace_name} - {destroy_or_deploy_txt} Planned")
    apply_run(session, run_id)
    wait_run_to_be_in_status_x(session, run_id, "applied")
    print(f"Workspace {workspace_name} - {destroy_or_deploy_txt} Applied")
    pass

def run_and_apply_workspaces(session : requests.Session, organization_name : string, workspaces_list : list, is_destroy : bool):
    for workspace in workspaces_list:
        run_and_apply_workspace(session, organization_name, workspace, is_destroy)
    pass

def deploy_or_destroy_promt():
    print("Press: \n(1) To Deploy \n(2) To Destroy")
    input_str = str(input())

    while input_str != "1" and input_str != "2":
        print("Press: \n(1) To Deploy \n(2) To Destroy")
        input_str = str(input())
    
    is_deploy = input_str == "1"
    return is_deploy

if __name__ == '__main__':
    tfvars_file_path = sys.path[0] + "//terraform.tfvars"
    vars_dict = create_dict_from_tfvars_file(tfvars_file_path)
    
    session = create_tfe_api_session(vars_dict["tfe_token"]) 

    is_destroy_plan = not deploy_or_destroy_promt()

    if is_destroy_plan:
        print("Destroying Everything !!!")
        vars_dict = vars_dict | get_all_workspaces_vars_dict(session, vars_dict['tfe_organization_name'])
        workspaces_to_destroy_list = [
            # vars_dict["tfe_kubernetes_workspace_name"],
            vars_dict["tfe_servers_workspace_name"], 
            vars_dict["tfe_vpc_workspace_name"]
        ]
        run_and_apply_workspaces(session, vars_dict['tfe_organization_name'], workspaces_to_destroy_list, True)
        destroy_terraform(tfvars_file_path)
    
    else:
        print("Deploying Everything :)")
        deploy_terraform(tfvars_file_path)
        vars_dict = vars_dict | get_all_workspaces_vars_dict(session, vars_dict['tfe_organization_name'])
        workspaces_to_apply_list = [
            vars_dict["tfe_vpc_workspace_name"]
            ,vars_dict["tfe_servers_workspace_name"]
            # ,vars_dict["tfe_kubernetes_workspace_name"]
        ]
        run_and_apply_workspaces(session, vars_dict['tfe_organization_name'], workspaces_to_apply_list, False)
        exit()
        boto3_ec2 = boto3.resource('ec2')
        ec2_user_name = "ubuntu"
        private_key_file_path = vars_dict['private_key_file_path']

        ansible_deploy_through_bastion_host(boto3_ec2, ec2_user_name, private_key_file_path)

        print("\nServers:")
        print(f"bastion_host_public_ip: {get_bastion_host_ip(boto3_ec2,True)}")
        print(f"ansible_server_ip: {get_ansible_server_ip(boto3_ec2)}")
        print(f"jenkins_server_ip: {get_jenkins_server_ip(boto3_ec2)}")
        print_jenkins_nodes_ip(boto3_ec2)
        print_alb_dns_names()

    print("The End")
    exit()