Resource Chaining: 

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
