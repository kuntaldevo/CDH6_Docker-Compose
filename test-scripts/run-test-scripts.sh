#Testing all the containers and images
inspec exec container-test-script.rb

#Testing Namenode
inspec exec common-test-script.rb -t docker://namenode
inspec exec namenode-test-script.rb -t docker://namenode
inspec exec hdfs-test-script.rb -t docker://namenode

#Testing Datanode
inspec exec common-test-script.rb.rb -t docker://datanode
inspec exec datanode-test-script.rb -t docker://datanode
inspec exec hdfs-test-script.rb -t docker://datanode

#Testing ResourceManager
inspec exec common-test-script.rb.rb -t docker://resourcemanager
inspec exec resourcemanager-test-script.rb -t docker://resourcemanager
inspec exec hdfs-test-script.rb -t docker://resourcemanager

#Testing Pipeline
inspec exec common-test-script.rb -t docker://pipeline
inspec exec pipeline-test-script.rb -t docker://pipeline
inspec exec hdfs-test-script.rb -t docker://pipeline

#Testing Hive
inspec exec common-test-script.rb.rb -t docker://hive
inspec exec hive-test-script.rb -t docker://hive
inspec exec hdfs-test-script.rb -t docker://hive
