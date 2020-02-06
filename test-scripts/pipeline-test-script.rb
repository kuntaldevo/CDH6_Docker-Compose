#Testing for configuration files in the container pipeline
describe file('/usr/local/paxata/pipeline/pipeline.jar') do
  it { should exist }
  it { should be_file }
  it { should_not be_directory }  
  its('type') { should eq :file }
end

#Checking for Environment variables
describe os_env('SPARK_HOME') do
  its('content') { should eq '/usr/local/spark' }
end

describe os_env('SPARK_CONF_DIR') do
  its('content') { should eq '/usr/local/spark/conf' }
end

#Checking processes and other commands inside the environment
#describe command('jps') do
#  its('stdout') { should match 'SparkSubmit' }
#  its('stderr') { should eq '' }
#  its('exit_status') { should eq 0 }
#end

#Version of Spark
describe command('spark-submit --version') do  
  its('stderr') { should match '2.2.0.cloudera1*' }
  its('stdout') { should eq '' }
  its('exit_status') { should eq 0 }
end

#Setting kinit for Pipeline
describe command('kinit -kt /usr/local/paxata/pipeline/config/paxata.keytab paxata/$(hostname -f)') do
  its('stderr') { should eq '' }
  its('exit_status') { should eq 0 }
end