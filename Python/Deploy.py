from typing import Dict, List
import boto3
import paramiko
import sys
from paramiko.rsakey import RSAKey
from scp import SCPClient


def get_bastion_host_ip(ec2, get_public_ip: bool):
    running_instances = ec2.instances.filter(Filters=[
        {'Name': 'tag:service_role', 'Values': ['bastion']},
        {'Name': 'instance-state-name', 'Values': ['running']},
    ])
    for instance in running_instances:
        if get_public_ip is True:
            return instance.public_ip_address
        else:
            return instance.private_ip_address


def get_ansible_server_ip(ec2):
    running_instances = ec2.instances.filter(Filters=[
        {'Name': 'tag:service', 'Values': ['ansible']},
        {'Name': 'tag:instance_type', 'Values': ['server']},
        {'Name': 'instance-state-name', 'Values': ['running']}
    ])
    for instance in running_instances:
        return instance.private_ip_address


def get_consul_servers_amount(ec2):
    count = 0
    running_instances = ec2.instances.filter(Filters=[
        {'Name': 'tag:service_role', 'Values': ['service_discovery']},
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

    except:
        print(
            f"Error Connecting To: {0}".format(target_host_ip))
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

    except:
        print(
            f"Error Connecting To: {0} Through Bastion Host".format(target_host_ip))
        exit()


def close_ssh_session(host_ssh_client, session_name):
    host_ssh_client.close()
    print("Closed SSH Session To: {0}".format(session_name))


def ssh_run_commands(target_ssh_client: paramiko.client.SSHClient, commands: list):
    for command in commands:
        stdin, stdout, stderr = target_ssh_client.exec_command(command)
        for line in stdout.read().split(b'\n'):
            print(str(line))


def progress(filename, size, sent):
    sys.stdout.write("Copying: %s - Progress: %.2f%%   \n" %
                     (filename, float(sent)/float(size)*100))


def scp_file_copy(ssh_session: paramiko.client.SSHClient, file: str, remote_path):
    with SCPClient(ssh_session.get_transport(), progress=progress) as scp:
        scp.put(file, remote_path=remote_path, recursive=True)


if __name__ == '__main__':
    private_key_file_path = f"C:\\Downloads\\OpsSchool\\Private-Keys\\Kandula_Private_Key.pem"
    ssh_user_name = "ubuntu"
    consul_dc_name = "kandula-dc"
    ansible_folder_path = f"..\\Ansible"
    ansible_folder_name = "Ansible"
    ec2 = boto3.resource('ec2')

    bastion_host_public_ip = get_bastion_host_ip(ec2, True)
    bastion_host_private_ip = get_bastion_host_ip(ec2, False)
    ansible_server_ip = get_ansible_server_ip(ec2)
    consul_servers_amount = get_consul_servers_amount(ec2)

    bastion_ssh_client = ssh_client_connection(
        bastion_host_public_ip, ssh_user_name, private_key_file_path)

    ansible_ssh_client = ssh_client_connection_throgh_bastion_host(
        bastion_ssh_client, bastion_host_private_ip, ansible_server_ip, ssh_user_name, private_key_file_path)

    scp_file_copy(ansible_ssh_client,
                  private_key_file_path, '/home/ubuntu/.ssh/id_rsa')

    scp_file_copy(ansible_ssh_client, {ansible_folder_path}, '~/')

    allow_clean_ssh = [
        "chmod 600 /home/ubuntu/.ssh/id_rsa",
        "sudo sed -i 's/#   StrictHostKeyChecking ask/    StrictHostKeyChecking no/g' /etc/ssh/ssh_config"
    ]

    install_ansible_commands = [
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

    run_ansible_playbook_commands = [
        f'ansible-playbook {ansible_folder_name}/main.yml -i {ansible_folder_name}/aws_ec2.yml -e "consul_servers_amount={consul_servers_amount} consul_dc_name={consul_dc_name}"'
    ]

    ssh_run_commands(ansible_ssh_client, allow_clean_ssh)
    ssh_run_commands(ansible_ssh_client, install_ansible_commands)
    ssh_run_commands(ansible_ssh_client, install_ansible_modules)
    ssh_run_commands(ansible_ssh_client, run_ansible_playbook_commands)

    close_ssh_session(ansible_ssh_client, "Ansible Server")
    close_ssh_session(bastion_ssh_client, "Bastion Host")

    print("bastion_host_public_ip: {}".format(bastion_host_public_ip))
    print("ansible_server_ip: {}".format(ansible_server_ip))
    print("Done")
