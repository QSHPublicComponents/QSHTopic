#!/bin/bash

git stash
git pull origin master --tags
git stash pop

VersionString=`grep -E 's.version.*=' QSHTopic.podspec`
VersionNumber=`tr -cd 0-9 <<<"$VersionString"`

NewVersionNumber=$(($VersionNumber + 1))
LineNumber=`grep -nE 's.version.*=' QSHTopic.podspec | cut -d : -f1`
sed -i "" "${LineNumber}s/${VersionNumber}/${NewVersionNumber}/g" QSHTopic.podspec

echo "current version is ${VersionNumber}, new version is ${NewVersionNumber}"

git add .
git commit -am ${NewVersionNumber}
git tag ${VersionString}
git push origin master --tags
cd ~/.cocoapods/repos/qshpublicspecs && git clean -f && git pull origin master && cd - && pod repo push qshpublicspecs QSHTopic.podspec --verbose --allow-warnings

