#!/bin/sh

# -------------- config --------------

# Uncomment for debugging
set -x

# Set bash script to exit immediately if any commands fail
set -e

moduleName="CarotaService"

iphoneosArchiveDirectoryPath="/$moduleName-iphoneos.xcarchive"
iphoneosArchiveDirectory="$( pwd; )$iphoneosArchiveDirectoryPath"

iphoneosArchiveDirectoryPath="/$moduleName-iphonesimulator.xcarchive"
iphoneosSimulatorDirectory="$( pwd; )$iphoneosArchiveDirectoryPath"

outputDirectory="$( pwd; )/Release/$moduleName.xcframework"

## Cleanup

rm -rf $iphoneosArchiveDirectory
rm -rf $iphoneosSimulatorDirectory
rm -rf $outputDirectory


# Archive
xcodebuild archive -workspace ./Example/$moduleName.xcworkspace \
     -scheme $moduleName \
     -archivePath $iphoneosArchiveDirectory \
     -sdk iphoneos \
     SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES
      
xcodebuild archive -workspace ./Example/$moduleName.xcworkspace \
     -scheme $moduleName \
     -archivePath $iphoneosSimulatorDirectory \
     -sdk iphonesimulator \
     SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES

## XCFramework
xcodebuild -create-xcframework \
    -framework "$iphoneosArchiveDirectory/Products/Library/Frameworks/$moduleName.framework" \
    -framework "$iphoneosSimulatorDirectory/Products/Library/Frameworks/$moduleName.framework" \
    -output $outputDirectory

## Cleanup
rm -rf $iphoneosArchiveDirectory
rm -rf $iphoneosSimulatorDirectory

#Publish Release
while getopts v: flag
do
    case "${flag}" in
        v) version=${OPTARG};;
    esac
done

git add .
git commit -m "Version $version"

git tag $version
git push --tags origin develop
pod repo push carota $moduleName.podspec --allow-warnings