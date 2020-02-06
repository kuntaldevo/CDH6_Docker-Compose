#Checking configuration files in the hive container
describe file('/usr/sbin/start-hive') do
  it { should exist }
  it { should be_file }
  it { should_not be_directory }  
  its('type') { should eq :file }
end

describe file('/usr/local/hive/conf/hive-site.xml') do
  it { should exist }
  it { should be_file }
  it { should_not be_directory }  
  its('type') { should eq :file }
end

describe file('/usr/local/hive/lib/postgresql-9.4.1212.jre7.jar') do
  it { should exist }
  it { should be_file }
  it { should_not be_directory }  
  its('type') { should eq :file }
end

#Checking for Environment variables
describe os_env('HIVE_HOME') do
  its('content') { should eq '/usr/local/hive' }
end

describe os_env('HIVE_CONF_DIR') do
  its('content') { should eq '/usr/local/hive/conf' }
end

#Checking processes and other commands inside the environment
describe command('ps -eaf') do
  its('stdout') { should match 'HiveMetaStore' }
  its('stdout') { should match 'HiveServer2' }
  its('stderr') { should eq '' }
  its('exit_status') { should eq 0 }
end

#Checking hive version
describe command('hive --version') do  
  its('stdout') { should match '1.1.0-cdh5.12.1' }
  its('exit_status') { should eq 0 }
end

#Setting kinit for Hive
describe command('kinit -kt /usr/local/hive/conf/hive.keytab hive/$(hostname -f)') do
  its('stderr') { should eq '' }
  its('exit_status') { should eq 0 }
end