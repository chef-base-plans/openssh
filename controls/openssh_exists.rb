title 'Tests to confirm openssh exists'

plan_name = input('plan_name', value: 'openssh')
plan_ident = "#{ENV['HAB_ORIGIN']}/#{plan_name}"
openssh_relative_path = input('command_path', value: '/sbin/sshd')
openssh_installation_directory = command("hab pkg path #{plan_ident}")
openssh_full_path = openssh_installation_directory.stdout.strip + "#{ openssh_relative_path}"
 
control 'core-plans-openssh-exists' do
  impact 1.0
  title 'Ensure openssh exists'
  desc '
  '
   describe file(openssh_full_path) do
    it { should exist }
  end
end
