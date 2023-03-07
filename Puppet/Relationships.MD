##Resource Ordering: 
- Resources are read in the order they are written
- That doesn't always mean that's the order they will be applied in
- Manifest ordering is now default, but explicit relatioships are clearer especially with resources across multiple classes
- The ordering option defaults to **manifest** in later versions of Puppet, but could be **title-hash or random**




##Resource Chaining: 

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
