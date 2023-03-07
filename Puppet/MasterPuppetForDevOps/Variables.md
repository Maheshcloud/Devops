## Working with Variables in Puppet:
- Variables in Puppet are prefixed with $
- Assigned with =
- Must begin with a lower case letter or underscore
- The variable name can include alphanumeric and underscores

    $pkgname = 'httpd'
- Once declared, a variable cannot be modified or re-declared
- Variables can be used for resource titles
Example: 
```sh 
package { $pkgname: 
  ensure => installed,
}
```

## Variable Interpolation
- Strings in Puppet should always be quoted
- Single quotes for static content
- Double quotes for interpolated content
- When interpolating a variable into a string, the variable should be in brackets

Example: 
```sh
$prefix = 'README'
$suffix = 'txt'
$filename="${prefix}.${suffix}"
```
Real Example for our previous ones
```sh

class apache {

    $package_name = 'httpd'
    $service_name = 'httpd'
    $config_file = '/etc/httpd/conf/httpd.conf'

    package { $package_name: 
      ensure => installed, 
    }

    file { $config_file:
      ensure => file,
      source => 'puppet:///modules/apache/httpd_minimal.conf',
      require => Package[$package_name],
    }

    service { $service_name :
      ensure => running,
      enable => true,
      subscribe => File[$config_file],
    }

    file { '/var/www/html' :
      ensure => directory,
    }
}
```
## Arrays
- Array items are declated inside square brackets
- You can use an array in the resource title, this creates multiple resources

Example: 
```sh
$users = [ 'bob', 'susan', 'peter' ]
user { $users:
  ensure => present,
}
```
- Some resource types take arrays for their attributes

Example: 
```sh
$groups = [ 'sysadmins', 'dbas' ]
user { 'bob' : 
  ensure => present, 
  groups => $groups,
}
```
- [ ] Denotes an array
- Resource references are no different

Example: 
```sh
file { '/etc/app.conf' :
   ensure => file,
   required => Package['httpd', 'acmeapp'],
 }
 file { '/etc/web.conf' :
   ensure => file,
   required => [ Package['httpd'], Service['acmed'] ],
 }
```

## Hashes
- Hashes are declared using { }
- Key values are separated by a hashrocket (=>)

Example: 
```sh
$uids = {
    'bob' => '9999',
    'susan' => '9998',
    'peter' => '9997',
}
```
- Values can be looked up by placing the hash key in square brackets

Example: 
```sh
$uid_susan = $uids['susan']
notify { "Susan has the uid ${uid_susan}": }
```

## Scope
- Variables exist within a scope
- If a variable is not found in the current scope, the next scope is searched
- Scopes are namespaces with :: i.e if we want to access the top scope variable then we use :: like $::var
- To refer to a variable in a different class:
```sh
class foo {
    $var = 2
}
class bar {
    $var = 3
    $::foo::var # The output will be 2
}
```
