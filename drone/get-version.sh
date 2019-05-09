#!/bin/bash
MASTER="drone/master"
DEVELOP="drone/develop"
RELEASE="drone/release/"
PATCH=0
# Get next version for production
next_version() {
    major=$1
    minor=$2
    patch=$3
    if [[ $4 -le 500 ]]
    then
        patch=$(($3+1))
    elif [[ $4 -le 1500 ]]
    then
        minor=$(($2+1))
        patch=0
    else
        major=$(($1+1))
        minor=0
        patch=0
    fi
    echo "$major.$minor.$patch"
}
# Check if this build has changes since the last release
if [ -n $2 ]
then
    PATCH=$2
fi
# Set the version corresponding to the branch
if [[ -n $(echo "${DRONE_BRANCH}" | grep "^$RELEASE*") ]]
then
    #IFS="." read -ra VERSION_ARRAY <<< $(git describe --tags)
    export VERSION=$(next_version $(echo $1 | tr "." " ") $PATCH)
    eval `ssh-agent -s`
    ssh-add
    ssh-keyscan -t rsa github.com >> /root/.ssh/known_hosts
    git tag -a $VERSION -m "Added version: $VERSION"
    git push origin $VERSION
    git fetch
    git checkout $DEVELOP
    git merge --no-ff $VERSION
    git push origin $DEVELOP
elif [ "${DRONE_BRANCH}" = "$DEVELOP" ]
then
    export VERSION="$1-dev$PATCH"
elif [ "${DRONE_BRANCH}" = "$MASTER" ]
then
    export VERSION="$1-uat$PATCH"
fi
echo "$VERSION"