Topic: Shell Scripting

Interviewer: Imagine you are tasked with creating a shell script for a system monitoring tool. The objective is to continuously monitor all processes on a Unix/Linux system. If any process exceeds 60% CPU usage, the script should log information about those processes into a file, and simultaneously send an email notification to a specified email address.

ANS:
#!/bin/bash

# File to store information about processes exceeding 60% CPU usage
output_file="process_monitor.log"
# Email address to receive notifications
email_address="your_email@example.com"

while true; do
 # Get the list of processes sorted by CPU usage in descending order
 processes=$(ps aux --sort=-%cpu | awk '{if ($3 > 60) print}')

 # Check if there are any processes exceeding 60% CPU usage
 if [ -n "$processes" ]; then
 # Get the current date and time
 current_datetime=$(date +"%Y-%m-%d %H:%M:%S")

 # Write information about the processes to the output file
 echo "Processes exceeding 60% CPU usage at $current_datetime:" >> "$output_file"
 echo "$processes" >> "$output_file"
 echo "----------------------------------------" >> "$output_file"

 # Send an email notification
 echo -e "Subject: High CPU Usage Alert\n\nProcesses exceeding 60% CPU usage:\n\n$processes" | mail -s "High CPU Usage Alert" "$email_address"
 fi

 # Sleep for 1 minute before checking again
 sleep 60
done



Your Senior Admin ask you that you have 300 domains you need to collect respective ips after pinging the server. This is how you can to do this:

#importing socket library 
import socket

# Function to resolve the IP address of a domain
def resolve_domain(domain):
  try:
    ip_address = socket.gethostbyname(domain)
    return ip_address
  except socket.gaierror:
    return None # Return None if the resolution fails

# Read domain names from input file 

input_file_path = '/root/input_domains.txt'
with open(input_file_path, 'r') as input_file:
  domains = input_file.read().splitlines()

# Resolve each domain and save the results to an output file

output_file_path = 'output_ips.txt'
with open(output_file_path, 'w') as output_file:
  for domain in domains:
    ip_address = resolve_domain(domain)
    if ip_address is not None:
      output_file.write(f"{domain}: {ip_address}\n")
    else:
      output_file.write(f"{domain}: Unable to resolve\n")


print(f"Results saved to {output_file_path}")

==================================================================================================================


Interviewer: Write a shell script to continuously monitor the server ports. If any new listening ports are detected, send an email notification.

Ans:
#!/bin/bash

# Define the email settings
TO="your_email@example.com"
SUBJECT="New Listening Port Detected"
FROM="your_server@example.com"

# Log file to keep track of existing ports
LOG_FILE="/path/to/port_monitor.log"

# Function to send an email
send_email() {
 local message="$1"
 echo "$message" | mail -s "$SUBJECT" -r "$FROM" "$TO"
}

# Check if the log file exists; if not, create it
if [ ! -e "$LOG_FILE" ]; then
 touch "$LOG_FILE"
fi

# Get the list of currently listening ports
netstat -tuln | awk '$1 == "tcp" {print $4}' | cut -d: -f2 | sort -u > "$LOG_FILE"

# Check for new ports
while true; do
 netstat -tuln | awk '$1 == "tcp" {print $4}' | cut -d: -f2 | sort -u > /tmp/current_ports.txt
 new_ports=$(comm -23 /tmp/current_ports.txt "$LOG_FILE")
 
 if [ -n "$new_ports" ]; then
 message="New listening ports detected: $new_ports"
 send_email "$message"
 fi

 # Update the log file with the current ports
 mv /tmp/current_ports.txt "$LOG_FILE"
 
 # Sleep for a while before checking again (e.g., every 5 minutes)
 sleep 300
done



==================================================================================


Interviewer:
Write a shell script to meet the following requirements:
First, prompt for the folder path. If the folder exists, indicate that the folder exists. If the folder doesn't exist, create the folder and download and install a packages in the newly created folder."

Ans: 
#!/bin/bash

# Prompt the user for a folder path
read -p "Enter the folder path: " folder_path

# Check if the folder already exists
if [ -d "$folder_path" ]; then
 echo "Folder already exists."
else
 # If the folder doesn't exist, create it
 mkdir -p "$folder_path"
 
 # Move into the new folder
 cd "$folder_path"
 
 # Download and install a package (e.g., 'example_package' for demonstration)
 wget https://lnkd.in/gSJmRzFR
 tar -xzf example_package.tar.gz
 
 # You can add installation steps here if necessary
 
 echo "Folder created and package downloaded."
fi


==============================================================================================

Interviewer: Write a shell Script to create AWS IAM user, you need to prompt the username and pwd while executing the script.

Ans:

#!/bin/bash

# Prompt for AWS access key and secret key
read -p "Enter your AWS Access Key ID: " aws_access_key
read -p "Enter your AWS Secret Access Key: " aws_secret_key

# Set AWS credentials
aws configure set aws_access_key_id "$aws_access_key"
aws configure set aws_secret_access_key "$aws_secret_key"

# Prompt for IAM user details
read -p "Enter IAM username: " iam_username
read -p "Enter IAM user password: " iam_password

# Create IAM user
aws iam create-user --user-name "$iam_username"

# Create IAM login profile with a password
aws iam create-login-profile --user-name "$iam_username" --password "$iam_password" --password-reset-required

# Output success message
echo "IAM user $iam_username created successfully with a password."

Explanation:

First we need to set the required ACCESS & Secret key with proper policy to create IAM users, Then we can create a IAM user.


====================================================================================

Interviewer: 
In linux, I have an apache error log file. Whenever I am getting word "error" in error.log file. I should receive an email. How to achieve this?

Sol:
 Step 1: 
Look for the ErrorLog directive and set it to the desired log file path. For example:

/var/log/apache2/error.log
 
 Step 2:
 Configure email notifications using mailx

 Step 3: Script 

 #!/bin/bash
if grep -q "error" /var/log/apache2/error.log; then
 echo "Apache error detected in error log." | sendmail user1@gmail.com
fi

 Step 4: Set Up Cron Job:
 crontab -e

Then, add an entry to run your script at the desired interval. For example, to check every minute, you can add:
* * * * * /usr/local/bin/monitor.sh

Now, your script will monitor the Apache error log for the specified keyword (e.g., "error") and send you an email notification whenever it detects an error entry in the log.


=================================================================================================

Interviewer: 
In linux, I have an apache error log file. Whenever I am getting word "error" in error.log file. I should receive an email. How to achieve this?

Sol:
 Step 1: 
Look for the ErrorLog directive and set it to the desired log file path. For example:

/var/log/apache2/error.log
 
 Step 2:
 Configure email notifications using mailx

 Step 3: Script 

 #!/bin/bash
if grep -q "error" /var/log/apache2/error.log; then
 echo "Apache error detected in error log." | sendmail user1@gmail.com
fi

 Step 4: Set Up Cron Job:
 crontab -e

Then, add an entry to run your script at the desired interval. For example, to check every minute, you can add:
* * * * * /usr/local/bin/monitor.sh

Now, your script will monitor the Apache error log for the specified keyword (e.g., "error") and send you an email notification whenever it detects an error entry in the log.


==========================================================================================================

Interviewer: Write a shell script to monitor a process for example tomcat for every one minute. If the process stopped its has to start otherwise it should exit.

ANS:
#!/bin/bash

PROCESS_NAME="tomcat"

while true; do
 # Check if the process is running
 if pgrep -x "$PROCESS_NAME" >/dev/null; then
 echo "$PROCESS_NAME is running."
 else
 echo "$PROCESS_NAME is not running. Starting it..."
 
 /path/to/tomcat/bin/startup.sh
 fi
 sleep 60
done

Add on question: Additionally it's has to send mail in linux

#!/bin/bash

EMAIL_TO="your.email@example.com"
EMAIL_SUBJECT="Tomcat Monitor Notification"

PROCESS_NAME="tomcat"

while true; do
 # Check if the process is running
 if pgrep -x "$PROCESS_NAME" >/dev/null; then
 echo "$PROCESS_NAME is running."
 else
 echo "$PROCESS_NAME is not running. Starting it..."
 
 
 /path/to/tomcat/bin/startup.sh

 echo "Tomcat was restarted on $(date)" | mail -s "$EMAIL_SUBJECT" "$EMAIL_TO"
 fi
 sleep 60

To sent an email from linux, we can follow below steps:
https://lnkd.in/gxWnCh8C

=======================================================================================

Interviewer: write a shell script, you need to prompt file path from the user, if the file exists then it should go to next prompt. in next prompt it should ask for word. if the file is not exist I should exit, same for word as well

Ans:
#!/bin/bash

read -p "Enter a filename: " filename

if [[ -f $filename ]] ; then
 echo "The file $filename exists."
 read -p "Enter the word you want to find: " word
 grep "$word" "$filename"
else
 echo "The file $filename does not exist."
fi

==============================================================================================

Interviewer: write a shell script, you need to prompt file path from the user, if the file exists then it should go to next prompt. in next prompt it should ask for word. if the file is not exist I should exit, same for word as well

Ans:
#!/bin/bash

read -p "Enter a filename: " filename

if [[ -f $filename ]] ; then
 echo "The file $filename exists."
 read -p "Enter the word you want to find: " word
 grep "$word" "$filename"
else
 echo "The file $filename does not exist."
fi


=================================================================================================

Interviewer: Write a shell script that's prompt the username and password from users. The username and password should contain only alphanumeric characters. If not, it should display an error message and exit


Ans:

#!/bin/bash

# prompt the user for a username
read -p "Enter a username: " USERNAME

# prompt the user for a password
read -sp "Enter a password: " PASSWORD
echo ""

# check if the username contains only alphanumeric characters
if ! [[ "$USERNAME" =~ ^[[:alnum:]]+$ ]]; then
 echo "Username must contain only alphanumeric characters."
 exit 1
fi

# check if the password contains only alphanumeric characters
if ! [[ "$PASSWORD" =~ ^[[:alnum:]]+$ ]]; then
 echo "Password must contain only alphanumeric characters."
 exit 1
fi


=============================================================================================

Interviewer: Write a shell script that's prompt the username and password from users. The username and password should contain only alphanumeric characters. If not, it should display an error message and exit


Ans:

#!/bin/bash

# prompt the user for a username
read -p "Enter a username: " USERNAME

# prompt the user for a password
read -sp "Enter a password: " PASSWORD
echo ""

# check if the username contains only alphanumeric characters
if ! [[ "$USERNAME" =~ ^[[:alnum:]]+$ ]]; then
 echo "Username must contain only alphanumeric characters."
 exit 1
fi

# check if the password contains only alphanumeric characters
if ! [[ "$PASSWORD" =~ ^[[:alnum:]]+$ ]]; then
 echo "Password must contain only alphanumeric characters."
 exit 1
fi


============================================================================================

Topic : Shell Scripting

Interviewer: Write a shell script to create a random password of a specified length of 16.

Ans : 

#!/bin/bash
PASSWORD_LENGTH=16
PASSWORD=$(openssl rand -base64 48 | tr -d /=+ | cut -c1-$PASSWORD_LENGTH)
echo "Random Password: $PASSWORD"

===========================================================================================

Interviewer: Write a shell script to monitor docker containers. if the containers exits, it has to run automatically 

Ans: 
 #!/bin/bash

CONTAINER_NAME="your-container-name"

while true; do
 if ! docker inspect -f '{{.State.Running}}' "$CONTAINER_NAME" > /dev/null; then
 echo "Container $CONTAINER_NAME is not running. Restarting..."
 docker restart "$CONTAINER_NAME"
 fi
 sleep 10
done

============================================================================================

interviewer: write a shell script to count the string "r" in the word "terraform".


Ans: 

#!/bin/bash

input="terraform"
char="r"
count=$(echo "$input" | grep -o "$char" | wc -l)

echo "The letter '$char' appears $count times in '$input'."

================================================================================================

Write a shell command to change all values ( from dev to qa ) in a file.

command: sed -i 's/dev/qa/g' file.txt

================================================================================================

