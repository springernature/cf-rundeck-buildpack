# Cloud Foundry Rundeck Buildpack

## ! WIP not usable at the moment

## Description
This buildpack makes it easy to install [Rundeck](https://www.rundeck.com/open-source) on Cloud Floundry. 

## Supported platforms
The buiildpack is tested with Cloud Foundry 6.36.1. 

## How to install
Use this repo as your buildpack for your Cloud Foundry app. It [supplies](/bin/supply) Java 8 and the installed (but not started) Rundeck application including all of specified plugins, but not the custom folders and properties. In [finalize](/bin/finalize) the custom folders are get copied to the installed rundeck application get started. 

## How to use
Your Cloud Foundry rundeck application should have a folder structure similar to this one:
```bash
├── etc
│   ├── permissions.aclpolicy
│   └── ...
├── server
│   ├── config
│   │   ├── jaas-login.conf
│   │   ├── rundeck-config.properties
│   │   └── ...
│   └── ...
├── manifest.yml
├── README.md
└── rundeck-plugins.txt

```

### Custom rundeck files 
All top-level folders of your application will be copied to the installed Rundeck application. Existing files will be overwritten. 

### Plugins
To install plugins just put a link to the corresponding `.jar` into `rundeck-plugins.txt` (one link per row). The buildpack will download and install them. The file could look like

```
https://github.com/joscha-alisch/vault-storage/releases/download/1.1.0/vault-storage-1.1.0.jar
https://github.com/rundeck-plugins/slack-incoming-webhook-plugin/releases/download/v1.1/slack-incoming-webhook-plugin-1.1.jar
```

### Security-role
If you want to use a different [security role](http://rundeck.org/docs/administration/authenticating-users.html#security-role) you don't have to put a custom `web.xml` in your CF application (but you can). Instead you can specify it as environment variable. You can specify the rundeck version you want to use as environment variable as well. The section in your `manifest.yml` should look like: 

```yaml
---
applications:
# ... your application settings ...
  env:
    RUNDECK_VERSION: "2.11.3"
    RUNDECK_SECURITY_ROLE: "cm-ops"
```

## Licensing 
This software is available under the [MIT license](LICENSE).

## Maintenance
