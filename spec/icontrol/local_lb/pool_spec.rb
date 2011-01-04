require File.expand_path(File.join(File.dirname(__FILE__),"..","..",'/spec_helper'))

describe IControl::LocalLB::Pool do

  use_vcr_cassette "IControl::LocalLB::Pool", :record => :all, :match_requests_on => [:uri, :method, :body] # Change :record => :new_episodes when done

  before(:each) do
    # Here you should provide an implementation of the creation of the object that is going to
    # be used to test the name will be test_pool

    @pool = IControl::LocalLB::Pool.find("test_pool")
  end

  after(:each) do
    # Here you should provide a way of deleting the object that was used to test ( test_pool )
  end

  describe "#add_member" do
    it "Adds members to the specified pools." do
      lambda { @pool.add_member(:members => [{:address => "192.168.50.1",:port => "80"}]) }.should_not raise_exception
    end

    it "works this way" do
      @pool.add_member(:members => [{:address => "192.168.52.10",:port => "80"},
                                    {:address => "192.168.52.11",:port => "80"},
                                    {:address => "192.168.52.12",:port => "80"}])
    end
  end

  describe "#create" do

    it "Creates a new pool." do
      IControl::LocalLB::Pool.find("test_pool_creation").should be_nil      
      lambda { IControl::LocalLB::Pool.create(:pool_name => "test_pool_creation",
                                       :lb_method => IControl::LocalLB::LBMethod::LB_METHOD_ROUND_ROBIN,
                                       :members => [{:address => "192.168.50.1",:port => "80"}]) }.should_not raise_exception
      IControl::LocalLB::Pool.find("test_pool_creation").should_not be_nil
      IControl::LocalLB::Pool.find("test_pool_creation").delete_pool            
    end

    it "works this way" do
      IControl::LocalLB::Pool.create(:pool_name => "foo_pool",
                                       :lb_method => IControl::LocalLB::LBMethod::LB_METHOD_ROUND_ROBIN,
                                       :members => [{:address => "192.168.50.1",:port => "80"}])

      # After creation you can erase it calling #delete_pool
      
      IControl::LocalLB::Pool.find("foo_pool").delete_pool      
    end
  end

  describe "#delete_persistence_record" do
    it "Deletes the persistence records based on the specified persistent modes for the specified pools." do
      pending
    end

    it "works this way" do
      pending
    end
  end

  describe "#delete_pool" do
    it "Deletes the specified pools." do
      pending
    end

    it "works this way" do
      pending
    end
  end

  describe "#action_on_service_down" do
    it "should return without raise any exception" do
      lambda { @pool.action_on_service_down }.should_not raise_exception
    end

    it "Gets the action to take when the node goes down for the specified pools." do
      @pool.action_on_service_down
    end

    it "works this way" do
      action_down = @pool.action_on_service_down
      # => :SERVICE_DOWN_ACTION_NONE
    end

    it "returns an instance of IControl::LocalLB::ServiceDownAction" do
      IControl::LocalLB::ServiceDownAction.constants.should include(@pool.action_on_service_down)
    end
  end

  describe "#active_member_count" do
    it "should return without raise any exception" do
      lambda { @pool.active_member_count }.should_not raise_exception
    end

    it "Gets the current active member counts for the specified pools." do
      @pool.active_member_count
    end

    it "works this way" do
      member_count = @pool.active_member_count
      # => 0
    end

    it "returns an instance of long" do
      @pool.active_member_count.class.ancestors.should include(Numeric)
    end
  end

  describe "#aggregate_dynamic_ratio" do
    it "should return without raise any exception" do
      lambda { @pool.aggregate_dynamic_ratio }.should_not raise_exception
    end

    it "Gets the aggregate dynamic ratio values from all the members of the pools." do
      @pool.aggregate_dynamic_ratio.should == 0
    end

    it "works this way" do
      dynamic_ratio = @pool.aggregate_dynamic_ratio
      # => 0
    end

    it "returns an instance of long" do
      @pool.aggregate_dynamic_ratio.class.ancestors.should include(Numeric)
    end
  end

  describe "#all_statistics" do
    it "should return without raising any exception" do
      lambda { @pool.all_statistics }.should_not raise_exception
    end

    it "Gets the statistics for all the pools." do
      @pool.all_statistics.should_not be_nil
    end

    it "works this way" do
      all_statistics = @pool.all_statistics

      # => #<IControl::LocalLB::Pool::PoolStatistics:0x92e4ccc@attributes={:statistics=>[#<IControl::LocalLB::Pool::PoolStatisticEntry:0x96868f8 @attributes={:pool_name=>"foo", :statistics=>[#<IControl::Common::Statistic:0x968d428 @attributes={:type=>:STATISTIC_SERVER_SIDE_BYTES_IN, :value=>#<IControl::Common::ULong64:0x968d4a0 @attributes={:high=>"0", :low=>"10674286", :id=>nil}>, :time_stamp=>"0", :id=>nil}>, #<IControl::Common::Statistic:0x968cce4 @attributes={:type=>:STATISTIC_SERVER_SIDE_BYTES_OUT, :value=>#<IControl::Common::ULong64:0x968cd70 @attributes={:high=>"0", :low=>"254145734", :id=>nil}>, :time_stamp=>"0", :id=>nil}>, #<IControl::Common::Statistic:0x968c514...

      all_statistics.statistics      
      # => [<IControl::Common::Statistic:0x..... ] An array with every statistic

      all_statistics.time_stamp.inspect
      # => #<IControl::Common::TimeStamp:0x9ddcf6c @attributes={:year=>"2011", :month=>"1", :day=>"4", :hour=>"10", :minute=>"59", :second=>"29", :id=>nil}>


      test_pool_statistics = all_statistics.statistics.find { |i| i.pool_name == "test_pool" }
      # => #<IControl::LocalLB::Pool::PoolStatisticEntry:0xa492f8c @attributes={:pool_name=>"test_pool", :statistics=>["<.....   The statistics for a given pool
      test_pool_statistics.statistics
      # => [#<IControl::Common::Statistic:0xa497d34 @attributes={:type=>:STATISTIC_SERVER_SIDE_BYTES_IN, :value=>#<IControl::Common::ULong64:0xa497d98 @attributes={:high=>"0", :low=>"0", :id=>nil}>, :time_stamp=>"0", :id=>nil}>, #<IControl::Common::Statistic:0xa497780.... The actual values    

    end

    it "returns an instance of PoolStatistics" do
      @pool.all_statistics.class.should == IControl::LocalLB::Pool::PoolStatistics
    end
  end

  describe "#allow_nat_state" do
    it "should return without raising any exception" do
      lambda { @pool.allow_nat_state }.should_not raise_exception
    end

    it "Gets the states indicating whether NATs are allowed for the specified pools." do
      @pool.allow_nat_state.should_not be_nil
    end

    it "works this way" do
      @pool.allow_nat_state
      # => :STATE_ENABLED
    end

    it "returns an instance of IControl::LocalLB::EnabledState" do
      IControl::Common::EnabledState.constants.should include(@pool.allow_nat_state)
    end
  end

  describe "#allow_snat_state" do
    it "should return without raising any exception" do
      lambda { @pool.allow_snat_state }.should_not raise_exception
    end

    it "Gets the states indicating whether SNATs are allowed for the specified pools." do
      @pool.allow_snat_state.should_not be_nil
    end

    it "works this way" do
      @pool.allow_snat_state
      # => :STATE_ENABLED
    end

    it "returns an instance of EnabledState" do
      IControl::Common::EnabledState.constants.should include(@pool.allow_snat_state)
    end
  end

  describe "#client_ip_tos" do
    it "should return without raising any exception" do
      lambda { @pool.client_ip_tos }.should_not raise_exception
    end

    it "Gets the IP ToS values for client traffic for the specified pools." do
      @pool.client_ip_tos.should_not be_nil
    end

    it "works this way" do
      @pool.client_ip_tos
      # => 65535
    end

    it "returns an instance of long" do
      @pool.client_ip_tos.class.ancestors.should include(Numeric)
    end
  end

  describe "#client_link_qos" do
    it "should return without raising any exception" do
      lambda { @pool.client_link_qos }.should_not raise_exception
    end

    it "Gets the link QoS values for client traffic for the specified pools." do
      @pool.client_link_qos.should_not be_nil
    end

    it "works this way" do
      @pool.client_link_qos
      # => 65535
    end

    it "returns an instance of long" do
      @pool.client_link_qos.class.ancestors.should include(Numeric)
    end

  end

  describe "#gateway_failsafe_unit_id" do
    it "should return without raising any exception" do
      lambda { @pool.gateway_failsafe_unit_id }.should_not raise_exception
    end

    it "Gets the gateway failsafe unit IDs for the specified pools." do
      @pool.gateway_failsafe_unit_id.should_not be_nil
    end

    it "works this way" do
      @pool.gateway_failsafe_unit_id
      # => 65535
    end

    it "returns an instance of long" do
      @pool.gateway_failsafe_unit_id.class.ancestors.should include(Numeric)
    end

  end

  describe "#lb_method" do
    it "should return without raising any exception" do
      lambda { @pool.lb_method }.should_not raise_exception
    end

    it "Gets the load balancing methods for the specified pools." do
      @pool.lb_method.should_not be_nil
    end

    it "works this way" do
      @pool.lb_method.inspect
      # => :LB_METHOD_DYNAMIC_RATIO
    end

    it "returns an instance of IControl::LocalLB::LBMethod" do
      IControl::LocalLB::LBMethod.constants.should include(@pool.lb_method)
    end
  end

  describe "#list" do
    it "should return without raising any exception" do
      lambda { IControl::LocalLB::Pool.get_list }.should_not raise_exception
    end

    it "Gets a list of all pools." do
      pending
    end

    it "works this way" do
      pending
    end

    it "returns an instance of String" do
      pending
    end
  end

  describe "#member" do
    it "should return without raising any exception" do
      lambda { @pool.member }.should_not raise_exception
    end

    it "Gets a list of pool members." do
      @pool.member.should_not be_nil
    end

    it "works this way" do
      @pool.member.map do |member|
        member.address
      end
      # => [ "192.168.1.2","192.168.1.20",....]
    end

    it "returns an instance of IControl::Common::IPPortDefinition[]" do
      @pool.member.first.class.should == IControl::Common::IPPortDefinition
    end
  end

  describe "#minimum_active_member" do
    it "should return without raising any exception" do
      lambda { @pool.minimum_active_member }.should_not raise_exception
    end

    it "Gets the minimum active member counts for the specified pools." do
      @pool.minimum_active_member.should_not be_nil
    end

    it "works this way" do
      puts @pool.minimum_active_member.inspect
      # => 0
    end

    it "returns an instance of long" do
      @pool.minimum_active_member.class.ancestors.should include(Numeric)
    end
  end

  describe "#minimum_up_member" do
    it "should return without raising any exception" do
      lambda { @pool.minimum_up_member }.should_not raise_exception
    end

    it "Gets the minimum member counts that are required to be UP for the specified pools." do
      @pool.minimum_up_member.should_not be_nil
    end

    it "works this way" do
      @pool.minimum_up_member.inspect
      # => 0
    end

    it "returns an instance of long" do
      @pool.minimum_up_member.class.ancestors.should include(Numeric)
    end
  end

  describe "#minimum_up_member_action" do
    it "should return without raising any exception" do
      lambda { @pool.minimum_up_member_action }.should_not raise_exception
    end

    it "Gets the actions to be taken if the minimum number of members required to be UP for the specified pools is not met." do
      @pool.minimum_up_member_action.should_not be_nil
    end

    it "works this way" do
      minimum_up_member_action = @pool.minimum_up_member_action
      # => :HA_ACTION_FAILOVER
    end

    it "returns an instance of IControl::Common::HAAction" do
      IControl::Common::HAAction.constants.should include(@pool.minimum_up_member_action)
    end
  end

  describe "#minimum_up_member_enabled_state" do
    it "should return without raising any exception" do
      lambda { @pool.minimum_up_member_enabled_state }.should_not raise_exception
    end

    it "Gets the states indicating that the feature that requires a minimum number of members to be UP is enabled/disabled for the specified pools." do
      @pool.minimum_up_member_enabled_state.should_not be_nil
    end

    it "works this way" do
      minimum_up_member_enabled_state = @pool.minimum_up_member_enabled_state
      # => :STATE_DISABLED
    end

    it "returns an instance of IControl::Common::EnabledState" do
      IControl::Common::EnabledState.constants.should include(@pool.minimum_up_member_enabled_state)
    end
  end

  describe "#monitor_association" do
    it "should return without raising any exception" do
      lambda { @pool.monitor_association }.should_not raise_exception
    end

    it "Gets the monitor associations for the specified pools, i.e. the monitor rules used by the pools." do
      @pool.monitor_association.should_not be_nil
    end

    it "works this way" do
       @pool.monitor_association
    end

    it "returns an instance of IControl::LocalLB::Pool::MonitorAssociation" do
      @pool.monitor_association.class.should == IControl::LocalLB::Pool::MonitorAssociation
    end
  end

  describe "#monitor_instance" do
    it "should return without raising any exception" do
      lambda { @pool.monitor_instance }.should_not raise_exception
    end

    it "Gets the monitor instance information for the specified pools, i.e. the monitor instance information for the pool members of the specified pools." do
      @pool.monitor_instance.should_not be_nil
    end

    it "works this way" do
      monitor_states = @pool.monitor_instance
      monitor_states.first.instance_state
      # => :INSTANCE_STATE_DOWN  (The actual state of the first member)
      monitor_states.first.instance.instance_definition
      # => #<IControl::LocalLB::MonitorIPPort:0x9f1c8a0 @attributes={:address_type=>:ATYPE_EXPLICIT_ADDRESS_EXPLICIT_PORT, :ipport=>#<IControl::Common::IPPortDefinition:0x9f1c918 @attributes={:address=>"192.168.52.10", :port=>"80", :id=>nil}>, :id=>nil}>
      monitor_states.first.instance.template_name
      # => tcp ( the monitor itself )
    end

    it "returns an instance of MonitorInstanceState[]" do
      @pool.monitor_instance.first.class.should == IControl::LocalLB::MonitorInstanceState
    end
  end

  describe "#object_status" do
    it "should return without raising any exception" do
      lambda { @pool.object_status }.should_not raise_exception
    end

    it "Gets the statuses of the specified pools." do
      @pool.object_status.should_not be_nil
    end

    it "works this way" do
      status = @pool.object_status
      status.availability_status
      # => :AVAILABILITY_STATUS_RED ( down )
      status.enabled_status
      # => :ENABLED_STATUS_ENABLED ( enabled ) this configuration corresponds with the red box in the GUI
      status.status_description
      # => "The children pool member(s) are down"
    end

    it "returns an instance of IControl::LocalLB::ObjectStatus" do
      @pool.object_status.class.should == IControl::LocalLB::ObjectStatus
    end
  end

  describe "#persistence_record" do

    it "Gets the persistence records based on the specified persistent modes for the specified pools." do
      pending
    end

    it "works this way" do
      pending
    end

    it "returns an instance of PersistenceRecord[]" do
      pending
    end
  end

  describe "#server_ip_tos" do
    it "should return without raising any exception" do
      lambda { @pool.server_ip_tos }.should_not raise_exception
    end

    it "Gets the IP ToS values for server traffic for the specified pools." do
      pending
    end

    it "works this way" do
      pending
    end

    it "returns an instance of long" do
      pending
    end
  end

  describe "#server_link_qos" do
    it "should return without raising any exception" do
      lambda { @pool.server_link_qos }.should_not raise_exception
    end

    it "Gets the link QoS values for server traffic for the specified pools." do
      pending
    end

    it "works this way" do
      pending
    end

    it "returns an instance of long" do
      pending
    end
  end

  describe "#simple_timeout" do
    it "should return without raising any exception" do
      lambda { @pool.simple_timeout }.should_not raise_exception
    end

    it "Gets the simple timeouts for the specified pools." do
      pending
    end

    it "works this way" do
      pending
    end

    it "returns an instance of long" do
      pending
    end
  end

  describe "#slow_ramp_time" do
    it "should return without raising any exception" do
      lambda { @pool.slow_ramp_time }.should_not raise_exception
    end

    it "Gets the ramp-up time (in seconds) to gradually ramp up the load on newly added or freshly detected UP pool members." do
      pending
    end

    it "works this way" do
      pending
    end

    it "returns an instance of long" do
      pending
    end
  end

  describe "#statistics" do
    it "should return without raising any exception" do
      lambda { @pool.statistics }.should_not raise_exception
    end

    it "Gets the statistics for the specified pools." do
      pending
    end

    it "works this way" do
      pending
    end

    it "returns an instance of PoolStatistics" do
      pending
    end
  end

  describe "#version" do
    it "should return without raising any exception" do
      lambda { @pool.version }.should_not raise_exception
    end

    it "Gets the version information for this interface." do
      pending
    end

    it "works this way" do
      pending
    end

    it "returns an instance of String" do
      pending
    end
  end

  describe "#remove_member" do
    it "Removes members from the specified pools." do
      pending
    end

    it "works this way" do
      pending
    end
  end

  describe "#remove_monitor_association" do
    it "Removes the monitor associations for the specified pools. This basically deletes the monitor associations between a pool and a monitor rule, i.e. the specified pools will no longer be monitored." do
      pending
    end

    it "works this way" do
      pending
    end
  end

  describe "#reset_statistics" do
    it "Resets the statistics for the specified pools." do
      pending
    end

    it "works this way" do
      pending
    end
  end

  describe "#set_action_on_service_down" do
    it "Sets the action to take when the node goes down for the specified pools." do
      pending
    end

    it "works this way" do
      pending
    end
  end

  describe "#set_allow_nat_state" do
    it "Sets the states indicating whether NATs are allowed for the specified pools." do
      pending
    end

    it "works this way" do
      pending
    end
  end

  describe "#set_allow_snat_state" do
    it "Sets the states indicating whether SNATs are allowed for the specified pools." do
      pending
    end

    it "works this way" do
      pending
    end
  end

  describe "#set_client_ip_tos" do
    it "Sets the IP ToS values for client traffic for the specified pools." do
      pending
    end

    it "works this way" do
      pending
    end
  end

  describe "#set_client_link_qos" do
    it "Sets the link QoS values for client traffic for the specified pools." do
      pending
    end

    it "works this way" do
      pending
    end
  end

  describe "#set_gateway_failsafe_unit_id" do
    it "Sets the gateway failsafe unit IDs for the specified pools." do
      pending
    end

    it "works this way" do
      pending
    end
  end

  describe "#set_lb_method" do
    it "Sets the load balancing methods for the specified pools." do
      pending
    end

    it "works this way" do
      pending
    end
  end

  describe "#set_minimum_active_member" do
    it "Sets the minimum active member counts for the specified pools." do
      pending
    end

    it "works this way" do
      pending
    end
  end

  describe "#set_minimum_up_member" do
    it "Sets the minimum member counts that are required to be UP for the specified pools." do
      pending
    end

    it "works this way" do
      pending
    end
  end

  describe "#set_minimum_up_member_action" do
    it "Sets the actions to be taken if the minimum number of members required to be UP for the specified pools is not met." do
      pending
    end

    it "works this way" do
      pending
    end
  end

  describe "#set_minimum_up_member_enabled_state" do
    it "Sets the states indicating that the feature that requires a minimum number of members to be UP is enabled/disabled for the specified pools." do
      pending
    end

    it "works this way" do
      pending
    end
  end

  describe "#set_monitor_association" do
    it "Sets/creates the monitor associations for the specified pools. This basically creates the monitor associations between a pool and a monitor rule." do
      pending
    end

    it "works this way" do
      pending
    end
  end

  describe "#set_server_ip_tos" do
    it "Sets the IP ToS values for server traffic for the specified pools." do
      pending
    end

    it "works this way" do
      pending
    end
  end

  describe "#set_server_link_qos" do
    it "Sets the link QoS values for server traffic for the specified pools." do
      pending
    end

    it "works this way" do
      pending
    end
  end

  describe "#set_simple_timeout" do
    it "Sets the simple timeouts for the specified pools." do
      pending
    end

    it "works this way" do
      pending
    end
  end

  describe "#set_slow_ramp_time" do
    it "Sets the ramp-up time (in seconds) to gradually ramp up the load on newly added or freshly detected UP pool members." do
      pending
    end

    it "works this way" do
      pending
    end
  end
end
