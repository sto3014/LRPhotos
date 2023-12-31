#!/usr/bin/env bash
cd "$(dirname "$0")"
export SCRIPT_DIR="$(pwd)"
export PACKAGE_NAME=LRPhotos
export TARGET_DIR_MAC="$SCRIPT_DIR/target/mac/Library/Application Support/Adobe/Lightroom"
export TARGET_DIR_SERVICES="$SCRIPT_DIR/target/mac/Library/Services"
export SOURCE_DIR=$SCRIPT_DIR/src/main/$PACKAGE_NAME.lrdevplugin
export SOURCE_DIR_SERVICES=$SCRIPT_DIR/src/main/services
export RESOURCE_DIR=$SCRIPT_DIR/res
export VERSION=1.1.0.0
#
# mac
#
if [ -d  "$TARGET_DIR_MAC" ]; then
   rm -d -f -r "$TARGET_DIR_MAC"
fi
if [ -d  "$TARGET_DIR_SERVICES" ]; then
   rm -d -f -r "$TARGET_DIR_SERVICES"
fi
rm $SCRIPT_DIR/target/$PACKAGE_NAME$VERSION"_mac.zip"

mkdir -p "$TARGET_DIR_MAC/Modules/$PACKAGE_NAME.lrplugin"
mkdir -p "$TARGET_DIR_SERVICES"
# copy dev

cp -R $SOURCE_DIR/* "$TARGET_DIR_MAC/Modules/$PACKAGE_NAME.lrplugin"
cp -R "$SOURCE_DIR_SERVICES/Zeige Foto UUID.workflow" "$TARGET_DIR_SERVICES/Zeige Foto UUID.workflow"
# compile
#cd "$TARGET_DIR_MAC/Modules/$PACKAGE_NAME.lrplugin"
#for f in *.lua
#do
# luac5.1 -o $f $f
# done
# cd $RESOURCE_DIR
# cp -R * "$TARGET_DIR_MAC"
cd "$SCRIPT_DIR/target/mac"
zip -q -r ../$PACKAGE_NAME$VERSION"_mac.zip" Library
