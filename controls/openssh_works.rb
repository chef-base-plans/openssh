title 'Tests to confirm openssh works as expected'

plan_origin = ENV['HAB_ORIGIN']
plan_name = input('plan_name', value: 'openssh')

control 'core-plans-openssh-works' do
  impact 1.0
  title 'Ensure openssh works as expected'
  desc '
  Verify openssh by ensuring 
  (1) its installation directory exists and 
  (2) that it returns the expected version.
  '
  
  plan_installation_directory = command("hab pkg path #{plan_origin}/#{plan_name}")
  describe plan_installation_directory do
    its('exit_status') { should eq 0 }
    its('stdout') { should_not be_empty }
    its('stderr') { should be_empty }
  end
  
  command_relative_path = input('command_relative_path', value: 'bin/sshd')
  command_full_path = File.join(plan_installation_directory.stdout.strip, "#{command_relative_path}")
  plan_pkg_version = plan_installation_directory.stdout.split("/")[5]
  describe command("#{command_full_path} -V") do
    its('exit_status') { should eq 1 }
    its('stdout') { should be_empty }
    its('stderr') { should_not be_empty }
    its('stderr') { should match /^OpenSSH_#{plan_pkg_version}/ }
  end
end