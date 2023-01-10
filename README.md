# Automation_Project
This project automates the process of archiving Apache2 access and error logs and uploading them to an S3 bucket. The script also includes a bookkeeping feature that keeps track of the logs that have been archived in an inventory file.


Prerequisites


AWS CLI needs to be installed and configured on the system with access to the specified S3 bucket

The script must be run with root privileges

Script Usage


Clone the repository to your local machine.

Replace the placeholder values for 'myname' and 's3_bucket' with your actual name and S3 bucket name in the script.

Place the script in the '/root/Automation_Project/' directory.

Make the script executable using chmod +x /root/Automation_Project/automation.sh command.

Run the script with either sudo ./root/Automation_Project/automation.sh or sudo su; ./root/Automation_Project/automation.sh

Schedule the script to run automatically using cronjob by running crontab -e command and add 0 2 * * * /root/Automation_Project/automation.sh to run the script every day at 2:00 AM.

Script Functionality


The script performs the following tasks:


Performs an update of the package details and package list.

Installs the apache2 package if it is not already installed.

Ensures that the apache2 service is running and enabled.

Creates a tar archive of Apache2 access and error logs and uploads it to the specified S3 bucket.

Creates a new entry in the inventory.html file in /var/www/html/ with the following information:

Log type

Time created

Type of archive

Size of the archive
