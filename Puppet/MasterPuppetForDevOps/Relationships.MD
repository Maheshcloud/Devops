## Resource Ordering: 
- Resources are read in the order they are written
- That doesn't always mean that's the order they will be applied in
- Manifest ordering is now default, but explicit relatioships are clearer especially with resources across multiple classes
- The ordering option defaults to **manifest** in later versions of Puppet, but could be **title-hash or random**

relationships.pp
```sh
notify { 'a' : }
notify { 'b' : }
notify { 'c' : }
```
To run the relationships.pp
```sh
puppet apply relationships.pp
```

To check the ordering 
```sh
puppet config print ordering
```
To apply with ordering as title-hash
```sh
puppet apply relationships.pp --ordering title-hash
```
To apply with ordering as random
```sh 
puppet apply relationships.pp --ordering random
```
- A resource reference is a pointer to a resource declaration

Example: 
```sh
package { 'httpd' :
  ensure => installed,
}

Package['httpd'] #referencing the package httpd
```

- Using the **required** attribute
```sh
package { 'httpd' :
  ensure => installed,
}
service { 'httpd' :
  ensure => running, 
  require => Package['httpd'], # This required will make sure than once package resource ran then only service resource runs. Its like depends on
}

```
- Using the **before** attribute
```sh
package { 'httpd' :
  ensure => installed,
  before => Service['httpd'], # This runs before the service resource runs
}
service { 'httpd' :
  ensure => running, 
}
```
## Triggering Events: 
- Some resources need to take an action based on an event occurring in a different resource
- For example when a configuration file is changed we want to restart the service 
- Some resource types are **refreshable**, meaning they taken an action when they receive a refresh event
- In this example, we need to restart the service whenever the Apache configuration file is updated
```sh
file { '/etc/httpd/httpd.conf' : 
  ensure => file,
  source => 'puppet:///modules/apache/httpd.conf',
}
service { 'httpd' : 
  ensure => running,
}
```
- We can use **subscribe** or **notify** to send an event notification.
- Subscribe behaves as require but the only difference is subscribe refreshes 
- Notify behaves as before

Example using subscribe:
```sh
file { '/etc/httpd/httpd.conf' : 
  ensure => file,
  source => 'puppet:///modules/apache/httpd.conf',
}
service { 'httpd' : 
  ensure => running,
  subscribe => File['/etc/httpd/httpd.conf'], # This will trigger a refresh event
}
```
Example using notify:
```sh
file { '/etc/httpd/httpd.conf' : 
  ensure => file,
  source => 'puppet:///modules/apache/httpd.conf',
  notify => Service['httpd'],
}
service { 'httpd' : 
  ensure => running,
}
```

- The exec resource is also refreshable
Example: 
```sh
service { 'tinpot' : 
  ensure => running,
  enable => true, 
  notify => Exec['clean tinpot cache'],
}
exec { 'clean tinpot cache' : 
  path => '/opt/tinpot/bin',
  command => 'tinpot --cleancache', 
  refreshonly => true, 
}
```

- **require** sets order from the referenced resource to the container resource
- **before** sets order from the container resource to the referenced resource
- **subscribe** refreshes itself when the referenced resource changes
- **notify** refreshes the referenced resource when there are changes to itself
- **subscribe** implies **require**, **notify** implies **before**

## Resource Chaining: 

- Puppet also supports a short hand syntax for expressing relationships by referencing the resources and chaining them together
- When referencing resources, they must be declared

```sh
Package['httpd'] -> File['/etc/httpd/httpd.conf']
```
```sh
Example: 
notify { 'a' : }
notify { 'b' : }
notify { 'c' : }

Notify['a'] -> Notify['b'] -> Notify['c']
```

Resource declarations can also be directly chained

```sh
package { 'httpd' :
  ensure => installed,
} ->
file { '/etc/httpd/httpd.conf' : 
  ensure => file,
  source => 'puppet:///modules/apache/httpd.conf'
}
```

*  -> left before right
*  <- right before left
*  ~> left refreshes right
*  <~ right refreshes left

```sh
Package['httpd'] -> File['/etc/httpd/httpd.conf'] ~> Service['httpd']
Service['httpd'] <~ File['/etc/httpd/httpd.conf'] <- Package['httpd']
```

When referencing a resource, we are managing the resource declaration in Puppet, not in the configured entity on the agent. 
```sh
file { '/home/bob/test/txt' :
  ensure => file,
  require => User['bob'],
}

user { 'bob' : 
  ensure => present, 
}
```
