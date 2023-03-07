
## An Apache Module: 
- Manage the httpd package and service
- Manage the default httpd.conf file
- Ensure the document root exists

Perform below steps in PuppetServer: 

cd /etc/puppetlabs/code/environments/production/modules/

mkdir apache

cd apache

mkdir manifests

mkdir files

cd files

cp /rooot/httpd_minimal.conf . 

cd ..

cd manifests

vi init.pp
```sh
class apache {
    package { 'httpd' : 
      ensure => installed, 
    }

    file { '/etc/httpd/conf/httpd.conf' :
      ensure => file,
      source => 'puppet:///modules/apache/httpd_minimal.conf',
      require => Package['httpd'],
    }

    service { 'httpd' :
      ensure => running,
      enable => true,
      subscribe => File['/etc/httpd/conf/httpd.conf'],
    }

    file { '/var/www/html' :
      ensure => directory,
    }
}
```
cd /etc/puppetlabs/code/environments/production/manifests/

vi site.pp

```sh
node "agent.localdomain" {
    include motd
    include apache
}
```

Run below command in agent: 
puppet agent -t
