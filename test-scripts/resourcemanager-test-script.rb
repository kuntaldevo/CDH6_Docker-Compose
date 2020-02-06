#Testing for configuration files in the container resourcemanager
describe file('/usr/sbin/start-hadoop-resourcemanager') do
  it { should exist }
  it { should be_file }
  it { should_not be_directory }  
  its('type') { should eq :file }
end

#Checking processes and other commands inside the environment
describe command('jps') do
  its('stdout') { should match 'ResourceManager' }
  its('stdout') { should match 'JobHistoryServer' }
  its('stderr') { should eq '' }
  its('exit_status') { should eq 0 }
end

#Setting kinit for ResourceManager
describe command('kinit -kt /etc/hadoop/conf/yarn.keytab yarn/$(hostname -f)') do
  its('stderr') { should eq '' }
  its('exit_status') { should eq 0 }
end