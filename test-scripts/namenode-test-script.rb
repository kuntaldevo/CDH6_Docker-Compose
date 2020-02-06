#Testing for configuration files in the container namenode
describe file('/usr/sbin/start-hadoop-namenode') do
  it { should exist }
  it { should be_file }
  it { should_not be_directory }  
  its('type') { should eq :file }
end

#Checking processes and other commands inside the environment
describe command('jps') do
  its('stdout') { should match 'NameNode' }
  its('stderr') { should eq '' }
  its('exit_status') { should eq 0 }
end

#Setting kinit for NameNode
describe command('kinit -kt /etc/hadoop/conf/hdfs.keytab hdfs/$(hostname -f)') do
  its('stderr') { should eq '' }
  its('exit_status') { should eq 0 }
end