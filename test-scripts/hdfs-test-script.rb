#Test for hdfs commands
describe command('klist') do
    its('stderr') { should eq '' }
    its('exit_status') { should eq 0 }
  end
  
  describe command('hdfs dfsadmin -report') do
    its('stderr') { should eq '' }
    its('exit_status') { should eq 0 }
  end
  
  describe command('hdfs dfs -ls /') do
    its('stdout') { should match 'tmp*' }
    its('stdout') { should match 'usr*' }
    its('stderr') { should eq '' }
    its('exit_status') { should eq 0 }
  end
  
#Finally destroying the ticket generated using the kinit command
  describe command('kdestroy') do
    its('stderr') { should eq '' }
    its('exit_status') { should eq 0 }
  end