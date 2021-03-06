## Apache Zookeeper Puppet Module

![Build Status](https://travis-ci.org/MetaCenterCloudPuppet/cesnet-zookeeper.svg?branch=master)](https://travis-ci.org/MetaCenterCloudPuppet/cesnet-zookeeper)

####Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with Zookeeper](#setup)
    * [What cesnet-zookeeper module affects](#what-zookeeepr-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with Zookeeper](#beginning-with-zookeeeper)
4. [Usage - Configuration options and additional functionality](#usage)
    * [Superuser Access](#superuser)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
    * [Classes](#classes)
    * [Module Parameters](#parameters)
6. [Development - Guide for contributing to the module](#development)


1. [Overview](#overview)

<a name="overview"></a>
## Overview

The zookeeper module installs and configures Apache Zookeeper quorum cluster. Optionally, the security can be enabled.

<a name="module-description"></a>
##Module Description

This module install and configure Apache Zookeeper quorum cluster. It expects list of hostnames, where zookeeper should be running. Zookeeper IDs will be generated according to the ordering of these hostnames.

Optionally the security based on Kerberos can be enabled.

Supported are:

* Debian 7/wheezy: Cloudera distribution (tested with CDH 5.3.0/zookeeper 3.4.5)
* Ubuntu 14/trusty
* RHEL 6, CentOS 6, Scientific Linux 6: Cloudera distribution (tested with CDH 5.4.2/zookeeper 3.4.5)

<a name="setup"></a>
##Setup

<a name="what-zookeeper-affects"></a>
###What cesnet-zookeeper module affects

* Packages: zookeeper server package
* Alternatives:
 * alternatives are used for */etc/zookeeper/conf* in Cloudera
 * this module switches to the new alternative by default on Debian, so the Cloudera original configuration can be kept intact
* Files modified:
 * */etc/zookeeper/conf\**
 * */var/lib/zookeeper/\**
* Secret files (keytab): ownerships and permissions modified
* Java system properties set for Zookeeper:
 * *java.security.auth.login.config*
 * *zookeeper.security.auth\_to\_local*

<a name="setup-requirements"></a>
###Setup Requirements

There are several known or intended limitations in this module.

Be aware of:

* **Repositories** - see cesnet-hadoop module Setup Requirements for details

* **Secure mode**: keytab must be prepared in */etc/security/keytabs/zookeeper.service.keytab* (see *realm* parameter)

<a name="beginning-with-zookeeper"></a>
###Beginning with Zookeeper

**Example**: one-machine zookeeper quorum without security:

    class{'zookeeper':
      hostnames => [ $::fqdn ],
      realm => '',
    }

It is recommended to have at least three or more (odd-numbered) zookeeper machines. All zookeeper hostnames must be specified in *hostnames* and the order must be the same across all of the nodes.

<a name="usage"></a>
##Usage

**Example**: Setup with security:

    class{'zookeeper':
      hostnames => [ $::fqdn ],
      realm => 'MY.REALM',
    }

The keytab file must be available at */etc/security/keytabs/zookeeper.service.keytab*.

Note: you can consider removing or changing property *zookeeper.security.auth\_to\_local*:

    properties => {
      'zookeeper.security.auth_to_local' => '::undef',
    }

Default value is valid for principal names according to Hadoop documentation at [http://hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-common/SecureMode.html](http://hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-common/SecureMode.html) and it is needed only with cross-realm authentication.

<a name="superuser"></a>
###Superuser Access

It is recommended to set super user credentials (for example to be able to restore bad ACLs).

####Get the digest string:
(replace $PASSWORD by real password)

    export ZK_HOME=/usr/lib/zookeeper
    java -cp $ZK_HOME/lib/*:$ZK_HOME/zookeeper.jar org.apache.zookeeper.server.auth.DigestAuthenticationProvider super:$PASSWORD

####Use the digest in *properties*:

    class{'zookeeper':
      hostnames => [ $::fqdn ],
      realm => 'MY.REALM',
      properties => {
        zookeeper.DigestAuthenticationProvider.superDigest => 'super:XXXXX',
      },
    }

####Using in the client:

    zooclient-cli
      addauth digest super:PASSWORD

<a name="reference"></a>
##Reference

<a name="classes"></a>
###Classes

* config.pp
* **init.pp**: Setup Zookeeper Cluster
* install.pp
* params.pp
* service.pp

<a name="parameters"></a>
###Module Parameters

####`alternatives`

Use alternatives to switch configuration. Use only when supported (Cloudera for example).

####`hostnames` (empty)

Array of zookeeper nodes hostnames.

####`realm` (required)

  Kerberos realm. Required parameter, empty string disables Kerberos authentication.a

  To enable security, there are required:

  * configured Kerberos (/etc/krb5.conf, /etc/krb5.keytab)
  * /etc/security/keytab/zookeeper.service.keytab (on zookeeper nodes)

<a name="development"></a>
##Development

* Repository: [https://github.com/MetaCenterCloudPuppet/cesnet-zookeeper](https://github.com/MetaCenterCloudPuppet/cesnet-zookeeper)
* Tests: [https://github.com/MetaCenterCloudPuppet/hadoop-tests](https://github.com/MetaCenterCloudPuppet/hadoop-tests)
* Email: František Dvořák &lt;valtri@civ.zcu.cz&gt;
