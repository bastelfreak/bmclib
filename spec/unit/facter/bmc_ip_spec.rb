require 'spec_helper'

describe :bmc_ip, :type => :fact do

  before :each do
    Facter.clear
    # stub the default values
    allow(Facter::Core::Execution).to receive(:exec).and_return('')
    allow(Facter::Core::Execution).to receive(:which).and_return('')
    allow(Facter::Core::Execution).to receive(:exec).with('/usr/bin/ipmitool lan print 2 2>/dev/null').and_return(@data)
    allow(Facter::Core::Execution).to receive(:exec).with('/usr/bin/ipmitool lan print 1 2>/dev/null').and_return(@data)
    allow(Facter::Core::Execution).to receive(:which).with('ipmitool').and_return('/usr/bin/ipmitool')
    allow(Facter).to receive(:value).with(:manufacturer).and_return('HP')
    allow(Facter).to receive(:value).with(:kernel).and_return('Linux')
    allow(Facter).to receive(:value).with(anything)
    allow(Facter).to receive(:[]).with(anything)
  end


  before :all do
    File.open("spec/fixtures/ipmitool/lan.txt",'r') do |file|
      @data = file.read
    end
  end

  describe :without_bmc_device do
    before :each do
      bdp = double(Facter::Util::Fact)
      allow(bdp).to receive(:value).and_return(false)
      allow(Facter).to receive(:[]).with(:bmc_device_present).and_return(bdp)
    end
    it 'should not contain ip' do
      expect(Facter.fact(:bmc_ip).value.nil?).to be true
    end

    it 'should not contain ip' do
      expect(Facter.fact(:bmc_ip).value.nil?).to be true
    end
  end
  describe :with_bmc_device do
    before :each do
      bdp = double(Facter::Util::Fact)
      allow(bdp).to receive(:value).and_return(true)
      allow(Facter).to receive(:[]).with(:bmc_device_present).and_return(bdp)
    end
    it 'should contain ip' do
      expect(Facter.fact(:bmc_ip).value).to eq('192.168.1.41')
    end
  end
end