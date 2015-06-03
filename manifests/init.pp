# Class: awsutils
#
# This module install amazon apitools and amitools.
#
# Parameters:
#  $ec2_api_tools = 'ec2-api-tools.zip',
#  $ec2_ami_tools = 'ec2-ami-tools.zip',
#  $download_url  = 'http://s3.amazonaws.com/ec2-downloads/',
#  $dest_path     = '/opt/aws',
#
# Requires: see Modulefile
#
# Sample Usage: include awsutils
#
class awsutils (
  $ec2_api_tools = 'ec2-api-tools.zip',
  $ec2_ami_tools = 'ec2-ami-tools.zip',
  $download_url  = 'http://puppetmaster01.iaistg.quadanalytix.com',
  $dest_path     = '/opt/aws',
  ) {

  $ec2_api_tools_source="$::download_url/$ec2_api_tools"
  $ec2_ami_tools_source="$::download_url/$ec2_ami_tools"

  file { "$dest_path":
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }
  exec { "get_aws_utils":
    path    => "/usr/local/bin:/bin:/usr/bin",
    cwd     => "/tmp/",
    command => "touch /tmp/placehodler && wget $ec2_api_tools_source $ec2_ami_tools_source && unzip 'ec2-*-tools.zip' && rm -rf 'ec2-*-tools.zip' && mv ec2-a* $dest_path",
    onlyif  => ["test  ! -f /tmp/placehodler"],
  }
  file { "$dest_path/apitools":
    ensure  => link,
    target  => "$dest_path/ec2-api-tools-1.7.4.0",
    require => File["$dest_path"],
  }
  file { "$dest_path/amitools":
    ensure  => link,
    target  => "$dest_path/ec2-ami-tools-1.5.7",
    require => File["$dest_path"],
  }
  file { '/etc/profile.d/awsutils-path.sh':
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => "PATH=\$PATH:$dest_path/apitools/bin:$dest_path/amitools/bin",
  }
}
