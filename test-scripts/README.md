All the separate test scripts for the containers are included in separate files.
The configuration test scripts are to check the packages installed and the processes running in it.
The common tests are for the packages and processes common to all and has been included in the script in such a wau that it runs for every container.

Keep all the test scripts and the shell script together and then run the shell script. 

If you want to run individual test scripts, the command is :

sudo inspec exec [filename].rb

If you want to run individual test scripts in a particular container, the commands are :

sudo inspec exec [filename].rb -t docker://[container-name]
sudo inspec exec [filename].rb -t docker://[container-id]