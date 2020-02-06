#Testing for configuration files in the container datanode
describe file('/usr/sbin/start-hadoop-datanode-nodemanager') do
  it { should exist }
  it { should be_file }
  it { should_not be_directory }  
  its('type') { should eq :file }
end

#Checking for Environment variables
describe os_env('JSVC_HOME') do
  its('content') { should eq '/usr/bin' }
end

describe os_env('HADOOP_SECURE_DN_USER') do
  its('content') { should eq 'root' }
end

describe os_env('PIPELINE_CACHE') do
  its('content') { should eq '/usr/local/paxata/pipeline/cache' }
end

describe os_env('SPARK_TMP') do
  its('content') { should eq '/usr/local/paxata/spark/tmp' }
end

#Checking processes and other commands inside the environment
describe command('ps -eaf') do
  its('stdout') { should match 'datanode' }
  its('stderr') { should eq '' }
  its('exit_status') { should eq 0 }
end

describe command('jps') do
  its('stdout') { should match 'NodeManager' }
  its('stderr') { should eq '' }
  its('exit_status') { should eq 0 }
end

#Setting kinit for DataNode
describe command('kinit -kt /etc/hadoop/conf/hdfs.keytab hdfs/$(hostname -f)') do
  its('stderr') { should eq '' }
  its('exit_status') { should eq 0 }
end