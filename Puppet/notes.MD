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

