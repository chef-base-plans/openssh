title 'Tests to confirm openssh works as expected'

plan_name = input('plan_name', value: 'openssh')
plan_ident = "#{ENV['HAB_ORIGIN']}/#{plan_name}"
openssh_path = command("hab pkg path #{plan_ident}")
openssh_pkg_ident = ((openssh_path.stdout.strip).match /(?<=pkgs\/)(.*)/)[1]

control 'core-plans-openssh-works-001' do
  impact 1.0
  title 'sshd is the expected version'
  desc '
  '

  describe openssh_path do
    its('exit_status') { should eq 0 }
    its('stdout') { should_not be_empty }
  end
  
  describe command("DEBUG=true; hab pkg exec #{openssh_pkg_ident} ssh -V") do
    its('exit_status') { should eq 0 }
    its('stdout') { should be_empty }
    its('stderr') { should match /^OpenSSH_7.5p1/ }
  end
end

control 'core-plans-openssh-works-002' do
  impact 1.0
  title 'openssh habitat service is "up"'
  describe command("hab svc status") do
    its('exit_status') { should eq 0 }
    its('stdout') { should_not be_empty }
    its('stdout') { should match /(?<package>#{openssh_pkg_ident})\s+(?<type>standalone)\s+(?<desired>up)\s+(?<state>up)/ }
    its('stderr') { should be_empty }
  end
end

control 'core-plans-openssh-works-003' do
  impact 1.0
  title 'sshd process is running in the background'
  describe command("hab pkg exec core/busybox-static ps -efl") do
    its('exit_status') { should eq 0 }
    its('stdout') { should_not be_empty }
    its('stdout') { should match /\/hab\/pkgs\/#{openssh_pkg_ident}\/sbin\/sshd -D -f \/hab\/svc\/openssh\/config\/sshd_config/ }
    its('stderr') { should be_empty }
  end
end

