#!/usr/bin/env bash
cd "$(dirname "$0")"
export SCRIPT_DIR="$(pwd)"
export PACKAGE_NAME=LRPhotos
export TARGET_DIR_MAC="$SCRIPT_DIR/target/mac/Library/Application Support/Adobe/Lightroom"
export SOURCE_DIR=$SCRIPT_DIR/src/main/lua/$PACKAGE_NAME.lrdevplugin
export RESOURCE_DIR=$SCRIPT_DIR/res
export VERSION=1.1.0.0
#
# mac
#
if [ -d  "$TARGET_DIR_MAC" ]; then
   rm -d -f -r "$TARGET_DIR_MAC"
fi
rm $SCRIPT_DIR/target/$PACKAGE_NAME$VERSION"_mac.zip"

mkdir -p "$TARGET_DIR_MAC/Modules/$PACKAGE_NAME.lrplugin"
# copy dev

cp -R $SOURCE_DIR/* "$TARGET_DIR_MAC/Modules/$PACKAGE_NAME.lrplugin"
# compile
cd "$TARGET_DIR_MAC/Modules/$PACKAGE_NAME.lrplugin"
for f in *.lua
do
 luac5.1 -o $f $f
done
# cd $RESOURCE_DIR
# cp -R * "$TARGET_DIR_MAC"
cd "$SCRIPT_DIR/target/mac"
zip -q -r ../$PACKAGE_NAME$VERSION"_mac.zip" Library
