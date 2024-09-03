#!/bin/sh

# -------------- config --------------

# Uncomment for debugging
set -x

# Set bash script to exit immediately if any commands fail
set -e

# Directory to search for .podspec files
SEARCH_DIR="."

# Find all .podspec files and extract name and version from each
find "$SEARCH_DIR" -name '*.podspec' | while read -r PODSPEC_FILE; do
    # Extract the name and version number

    version=$(grep 's.version' $PODSPEC_FILE | sed -n -e 's/^.*s.version *= *//p'| tr -d '"' | tr -d "'")
    moduleName=$(grep 's.name' $PODSPEC_FILE | sed -n -e 's/^.*s.name *= *//p'| tr -d '"' | tr -d "'")

    # Output the results
    if [ -n "$moduleName" ]; then
        echo "Name: $moduleName"
    else
        echo "Name not found."
        exit 1
    fi

    if [ -n "$VERSION" ]; then
        echo "Version: $VERSION"
    else
        echo "Version not found."
        exit 1
    fi

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
    git tag $version
    git push --tags origin
    pod repo push carota $moduleName.podspec --allow-warnings

done
