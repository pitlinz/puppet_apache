Facter.add('apache2minorversion') do
  confine :kernel => 'Linux'
  setcode do
    if File.file?('/usr/sbin/apache2ctl')
      Facter::Core::Execution.exec("/usr/sbin/apache2ctl -v | grep Apache | cut -f2 -d'/' | cut -f2 -d'.'")
    end  
  end
end