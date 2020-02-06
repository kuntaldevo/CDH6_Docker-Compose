# Inspec container tests for the image "docker-kerberos"
describe docker_container('kdc.paxata.com') do
   it { should exist }  
   it { should be_running } 
   its('image') { should eq 'docker-kerberos' }
   its('ports') { should eq '88/tcp, 749/tcp'}   
end

# Inspec container tests for the image "dtr.paxatadev.com/cloudera/namenode:5.12.1-kerberos-8-cdh"
describe docker_container('namenode') do
   it { should exist }  
   it { should be_running } 
   its('image') { should eq 'dtr.paxatadev.com/cloudera/namenode:5.12.1-kerberos-8-cdh' }
   its('ports') { should eq '8020/tcp, 8022/tcp, 50470/tcp, 0.0.0.0:50070->50070/tcp'}   
   its('command') { should eq 'start-hadoop-namenode' } 
end

# Inspec container tests for the image "dtr.paxatadev.com/cloudera/datanode-nodemanager:5.12.1-kerberos-8-cdh"
describe docker_container('datanode') do
   it { should exist }  
   it { should be_running }
   its('image') { should eq 'dtr.paxatadev.com/cloudera/datanode-nodemanager:5.12.1-kerberos-8-cdh' }
   its('ports') { should eq '8010/tcp, 50010/tcp, 50075/tcp, 50090/tcp, 50475/tcp'}   
   its('command') { should eq 'start-hadoop-datanode-nodemanager' } 
end

# Inspec container tests for the image "dtr.paxatadev.com/cloudera/resourcemanager:5.12.1-kerberos-8-cdh"
describe docker_container('resourcemanager') do
   it { should exist }  
   it { should be_running } 
   its('image') { should eq 'dtr.paxatadev.com/cloudera/resourcemanager:5.12.1-kerberos-8-cdh' }
   its('ports') { should eq '8030-8033/tcp, 8090/tcp, 19888-19889/tcp, 0.0.0.0:8088->8088/tcp'}   
   its('command') { should eq 'start-hadoop-resourcemanager' } 
end

# Inspec container tests for the image "dtr.paxatadev.com/cloudera/pipeline:5.12.1-spark-2.2.0-kerberos-8-cdh"
describe docker_container('pipeline') do
   it { should exist }  
   it { should be_running } 
   its('image') { should eq 'dtr.paxatadev.com/cloudera/pipeline:5.12.1-spark-2.2.0-kerberos-8-cdh' }
   its('ports') { should eq '4040/tcp, 8080-8081/tcp, 0.0.0.0:8090->8090/tcp'}
   its('command') { should eq '/root/bootstrap.sh' }   
end

# Inspec container tests for the image "postgres:9"
describe docker_container('postgres') do
   it { should exist }  
   it { should be_running }
   its('image') { should eq 'postgres:9' }  
   its('ports') { should eq '5432/tcp'}   
end

#Inspec container tests for the image "dtr.paxatadev.com/cloudera/hive:5.12.1-kerberos-8-cdh"
describe docker_container('hive') do
   it { should exist }  
   it { should be_running } 
   its('image') { should eq 'dtr.paxatadev.com/cloudera/hive:5.12.1-kerberos-8-cdh' }
   its('ports') { should eq '9083/tcp, 10000-10002/tcp'}   
   its('command') { should eq 'start-hive' } 
end