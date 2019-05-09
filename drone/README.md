# Drone - Continues Integration

This section depicts how to configure Drone.io to handle versions.

## Drone configuration

### Secrets

* RSA: SSH private key used as deploy key to creating new tags.
* PUB_RSA: SSH public key used as deploy key to creating new tags.

### Repository Settings

* Repository Hooks:
    * push
    * tag
    * deployment

## Version Convention

In order to organize the software packages generation, XumaK proposes to implement a version convention that will help to relate a version with the application state. 
A version will look like:

<center>< MAJOR >.< MINOR >.< PATCH >[-(dev|uat)${commitsNumber}]</center>

Where:

- MAJOR. Incremented when the application had more than 1500 commits ahead of the latest release. 
- MINOR. Incremented when the application had more than 500 commits ahead of the latest release.
- PATCH. Incremented when the application had less than 500 commits ahead of the latest release.
- commitNumber. This number came from the number of commits ahead of the latest release, it is used to identify the version installed in Dev and UAT environments.

## CI/CD Process

### Development

Trigger: Push <br>
Branch: development <br>
Version: ${latest-tag}-dev${commintNumber} <br>
Environments:

* Development

### Staging

Trigger: Push <br>
Branch: master <br>
Version: ${latest-tag}-uat${commintNumber} <br>
Environments:

* Staging environments

### Releases

Trigger: Push <br>
Branch: release/* <br>
Tag: The tag created in this task depends on the number of commits:

* 0 - 500 commits: Creates a patch version change ${latest-major-version}.${latest-minor-version}.**${latest-patch + 1}**
* 501 - 1500 commits: Creates a minor version change ${latest-major-version}.**${latest-minor-version + 1}**.0
* 1501+ commits: Creates a major version change **${latest-major-version + 1}**.0.0

### Production

Trigger: Tag creation <br>
Version: ${tag-name} <br>
Environments:

* Production environments

## References

* [https://nvie.com/posts/a-successful-git-branching-model/]()
