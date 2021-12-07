1) What are the different components of ansible? Explain Ansible architecture.

2) The Ansible Automation engine consists of the following components:

Inventories: These are a list of nodes containing their respective IP addresses, servers, databases, etc. which needs to be managed.

APIs: Just like any other API, the Ansible APIs are used for commuting various Cloud services, public or private services.

Modules: The modules are used to manage system resources, packages, libraries, files, etc. Ansible modules can be used to automate a wide range of tasks. Ansible provides around 450 modules that automate nearly every part of your environment.

Plugins: If you want to execute Ansible tasks as a job, Ansible Plugins can be used. They simplify the execution of a task by building a job like an environment that basically contains pieces of code corresponding to some specific functionality. There are 100s of Plugins provided by Ansible. An example is the Action plugin, which acts as front ends to modules and can execute tasks on the controller before calling the modules themselves.

Networking: Ansible can also be used to automate different networks and services. It can do this by creating a playbook or an Ansible role that easily spans different network hardware.

Hosts: The Ansible Hosts/ Node systems are machines (Linux, Windows, etc) that are getting automated.

Playbooks: Playbooks are simple code files which describe the tasks that need to be executed. The Playbooks are written in YAML format. They can be used to automate tasks, declare configurations, etc.

CMDB: It is a database that acts as a storehouse for various IT installations. It holds data about various IT assets (also known as configuration items (CI)) and describes the relationships between such assets.

Cloud: It is a network of remote servers hosted on the Internet to store, manage, and process data, rather than a local server.

3) Explain a few of the basic terminologies or concepts in Ansible.

Few of the basic terms that are commonly used while operating on Ansible are:

Controller Machine: The Controller machine is responsible for provisioning the servers that are being managed. It is the machine where Ansible is installed.

Inventory: An inventory is an initialization file that has details about the different servers you are managing.

Playbook: It is a code file written in the YAML format. A playbook basically contains the tasks that need to be executed or automated.

Task: Each task represents a single procedure that needs to be executed, e.g. Install a library.

Module: A module is a set of tasks that can be executed. Ansible has 100s of built-in modules, but you can also create custom ones.

Role: An Ansible role is a pre-defined way for organizing playbooks and other files in order to facilitate sharing and reusing portions of provisioning.

Play: A task executed from start to finish or the execution of a playbook is called a play.

Facts: Facts are global variables that store details about the system, like network interfaces or operating system.

Handlers: Are used to trigger the status of a service, such as restarting or stopping a service.

4) What is Ansible Galaxy? 
Galaxy is a website that lets Ansible users share their roles and modules. The Ansible Galaxy command line tool comes packed with Ansible, and it can be used to install roles from Galaxy or directly from a Source Control Management system such as Git. It can also be used to build new roles, remove existing ones and perform tasks on the Galaxy website.

You can use the below command to download roles from the Galaxy website:

$ansible-galaxy install username.role_name

5) Ansible Role:
An Ansible role is a pre-defined way for organizing playbooks and other files in order to facilitate sharing and reusing portions of provisioning.

site.yml
webservers.yml
fooservers.yml
roles/
    common/
        tasks/
        handlers/
        library/
        files/
        templates/
        vars/
        defaults/
        meta/
    webservers/
        tasks/
        defaults/
        meta/

By default Ansible will look in each directory within a role for a main.yml file for relevant content (also main.yaml and main):

tasks/main.yml - the main list of tasks that the role executes.

handlers/main.yml - handlers, which may be used within or outside this role.

library/my_module.py - modules, which may be used within this role (see Embedding modules and plugins in roles for more information).

defaults/main.yml - default variables for the role (see Using Variables for more information). These variables have the lowest priority of any variables available, and can be easily overridden by any other variable, including inventory variables.

vars/main.yml - other variables for the role (see Using Variables for more information).

files/main.yml - files that the role deploys.

templates/main.yml - templates that the role deploys.

meta/main.yml - metadata for the role, including role dependencies.


6) Modules in Ansible:

- copy: The copy module is often used in writing playbooks when we want to copy a file from a remote server to destination nodes.

For example, suppose we want to copy a file from a remote server to all destination machines.

ansible test-servers -m copy -a 'src=/home/knoldus/Personal/blogs/blog3.txt dest=/tmp' -u ec2-user

- name: Copy a new "ntp.conf file into place, backing up the original if it differs from the copied version
  copy:
    src: /mine/ntp.conf
    dest: /etc/ntp.conf
    owner: root
    group: root
    mode: '0644'
    backup: yes

- ping : Ping is used when we want to check whether the connection with our hosts defined in the inventory file is established or not.

ansible test-servers -m ping -u ec2-user

- yum: We use the Yum module to install a service.

ansible test-servers -m yum -a 'name=httpd state=present' -become -u ec2-user

- shell: When we want to run UNIX commands then we use shell module

ansible test-servers -m shell -a 'ls -la' -u ec2-user

- file: The file module manages the file and its properties.
Ex:
 name: Change file ownership, group and permissions
  file:
    path: /etc/foo.conf
    owner: foo
    group: foo
    mode: '0644'


- Jinja template: 

Why we need Jinja2 templating in Ansible?
When we manage a fleet of hundreds or thousands of servers of different OS configurations managing configurations on them becomes a tedious task as few parameters always differs from system to system and cluster to cluster.

Copying static files will not suffice in such situation. We need a solution which can dynamically takes the values as per the environment it is running on. And that's Jinja2.

We use following tags in a Jinja2 template file:

{{ }} : Used for embedding variables which prints their actual value during code execution.
{% %} : Used for control statements such as loops and if-else statements.
{# #} : To specify the comments.
Template files ends with .j2 extension.

