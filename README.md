# Cloud Foundry Rundeck Buildpack

## Description
This buildpack makes it easy to install [Rundeck](https://www.rundeck.com/open-source) on Cloud Foundry. 

## Supported platforms
This buildpack is tested with Cloud Foundry 6.36.1-6.37.0. **It only works at the moment with rundeck versions < 3.0.0**

## How to install
Use this repo as your buildpack for your Cloud Foundry app. It [supplies](/bin/supply) Java 8 and rundeck with the version specified by the `RUNDECK_VERSION` environment variable, including all of the specified plugins. In [finalize](/bin/finalize) the uploaded folders are moved to the rundeck application. The finalize step will also create [`startRundeck.sh`](startRundeck.sh) to start Rundeck. 

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
### Required files
To use this buildpack `server/config/jaas-login.conf` and `server/config/rundeck-config.properties` have to be present. 

### Custom rundeck files 
All top-level folders of your application will be copied to the installed Rundeck application. Existing files will be overwritten. 

### Plugins
To install plugins just put a link to the corresponding `.jar` into `rundeck-plugins.txt` (one link per row). The buildpack will download and install them. The file could look like

```
https://github.com/joscha-alisch/vault-storage/releases/download/1.1.0/vault-storage-1.1.0.jar
https://github.com/rundeck-plugins/rundeck-s3-log-plugin/releases/download/v1.0.5/rundeck-s3-log-plugin-1.0.5.jar
```

### S3 Logfile Storage
In order to use the S3 log storage, just add the plugin to `rundeck-plugins.txt` as explained above and bind an s3-bucket to your cf-app. The buildpack will automatically write the necessary configuration.

### Security-role
If you want to use a different [security role](http://rundeck.org/docs/administration/authenticating-users.html#security-role) you don't have to put a custom `web.xml` in your CF application (but you can). Instead you can specify it as environment variable. You can specify the rundeck version you want to use as environment variable as well. The section in your `manifest.yml` should look like: 

```yaml
---
applications:
# ... your application settings ...
  env:
    RUNDECK_VERSION: "2.11.3"
    RUNDECK_SECURITY_ROLE: "your-custom-security-role"
```

## Licensing 
This software is available under the [MIT license](LICENSE).

## Maintenance
This buildpack is maintained by the CMS team of Springer Nature.
