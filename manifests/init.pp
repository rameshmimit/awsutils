# Class: awsutils
#
# This module install amazon apitools and amitools.
#
# Parameters:
#  $ec2_api_tools  = 'ec2-api-tools.zip',
#  $ec2_ami_tools  = 'ec2-ami-tools.zip',
#  $download_url   = 'http://s3.amazonaws.com/ec2-downloads/',
#  $dest_path      = '/opt/aws',
#  $aws_access_key = 'BKLJJVVVCC444574F4CIN'
#  $aws_access_key = 'Abcdde34567890ksjhdanska45jk'
#
# Requires: see Modulefile
#
# Sample Usage: 
# class awsutils {
  #  $ec2_api_tools  = 'ec2-api-tools.zip'
  #  $ec2_ami_tools  = 'ec2-ami-tools.zip'
  #  $download_url   = 'http://s3.amazonaws.com/ec2-downloads/'
  #  $dest_path      = '/opt/aws'
  #  $aws_access_key = 'BKLJJVVVCC444574F4CIN'
  #  $aws_access_key = 'Abcdde34567890ksjhdanska45jk'  
# }

class awsutils (
  $ec2_api_tools  = $awsutils::params::ec2_api_tools,
  $ec2_ami_tools  = $awsutils::params::ec2_ami_tools,
  $download_url   = $awsutils::params::download_url,
  $dest_path      = $awsutils::params::dest_path,
  $aws_access_key = $awsutils::params::aws_access_key,
  $aws_secret_key = $awsutils::params::aws_secret_key,
  ) {

  $ec2_api_tools_source="$::download_url/$ec2_api_tools"
  $ec2_ami_tools_source="$::download_url/$ec2_ami_tools"

  package { 'java-1.7.0-openjdk':
    ensure => installed,
  } 
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
    onlyif  => ["test  ! -f /tmp/aws_placehodler"],
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
    content => template('awsutils/awsutils-path.erb'),
  }
}
