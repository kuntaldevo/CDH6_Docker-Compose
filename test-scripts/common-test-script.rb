#Testing for OS
describe os[:family] do
  it { should eq 'redhat' }
end

#Testing for java, gosu and other packages
describe command('java').exist? do
  it { should eq true }
end

describe command('java -version') do
  its('stdout') { should eq '' }
  its('stderr') { should match '1.8.0_144' }
  its('exit_status') { should eq 0 }
end

describe command('gosu').exist? do
  it { should eq true }
end

describe command("gosu root bash -c 'whoami'") do
  its('stdout') { should match 'root' }
  its('stderr') { should eq '' }
  its('exit_status') { should eq 0 }
end

describe package('tar') do
  it { should be_installed }
end

describe package('wget') do
  it { should be_installed }
end

describe package('unzip') do
  it { should be_installed }
end

describe package('which') do
  it { should be_installed }
end

describe package('krb5-workstation') do
  it { should be_installed }
end

describe package('krb5-libs') do
  it { should be_installed }
end

#Testing for Hadoop and Yarn
describe command('hadoop version') do
  its('stdout') { should match '2.6.0-cdh5.12.1' }
  its('stderr') { should eq '' }
  its('exit_status') { should eq 0 }
end

describe command('yarn version') do  
  its('stdout') { should match '2.6.0-cdh5.12.1' }
  its('stderr') { should eq '' }
  its('exit_status') { should eq 0 }
end

#Checking for Environment variables
describe os_env('HADOOP_HOME') do
  its('content') { should eq '/usr/local/hadoop' }
end

describe os_env('HADOOP_CONF_DIR') do
  its('content') { should eq '/etc/hadoop/conf' }
end

describe os_env('JAVA_HOME') do
  its('content') { should eq '/usr/java/latest' }
end