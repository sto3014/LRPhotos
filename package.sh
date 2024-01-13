#!/usr/bin/env bash
cd "$(dirname "$0")"
export SCRIPT_DIR="$(pwd)"
export PACKAGE_NAME=LRPhotos
export TARGET_DIR_MAC="$SCRIPT_DIR/target/mac/Library/Application Support/Adobe/Lightroom"
export TARGET_DIR_SERVICES="$SCRIPT_DIR/target/mac/Library/Services"
export TARGET_DIR_SCRIPT_LIBRARIES="$SCRIPT_DIR/target/mac/Library/Script Libraries"
export SOURCE_DIR=$SCRIPT_DIR/src/main/$PACKAGE_NAME.lrdevplugin
export SOURCE_DIR_SERVICES=/Users/dieterstockhausen/Projekte/Automation/Services/workflow
export SOURCE_DIR_SCRIPT_LIBRARIES="/Users/dieterstockhausen/Projekte/Automation/Script Libraries/src"
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

cp $SOURCE_DIR/* "$TARGET_DIR_MAC/Modules/$PACKAGE_NAME.lrplugin"
cp -R $SOURCE_DIR/PhotosImport/PhotosImport.app "$TARGET_DIR_MAC/Modules/$PACKAGE_NAME.lrplugin"
cp -R $SOURCE_DIR/ShowAlbum/ShowAlbum.app "$TARGET_DIR_MAC/Modules/$PACKAGE_NAME.lrplugin"
cp -R $SOURCE_DIR/ShowPhoto/ShowPhoto.app "$TARGET_DIR_MAC/Modules/$PACKAGE_NAME.lrplugin"
rm "$TARGET_DIR_MAC/Modules/$PACKAGE_NAME.lrplugin/ShowPhoto.applescript"
rm "$TARGET_DIR_MAC/Modules/$PACKAGE_NAME.lrplugin/ShowAlbum.applescript"
rm "$TARGET_DIR_MAC/Modules/$PACKAGE_NAME.lrplugin/PhotosImport.applescript"

cp -R "$SOURCE_DIR_SERVICES/PhotosDisplayUUID.workflow" "$TARGET_DIR_SERVICES/"
cp -R "$SOURCE_DIR_SCRIPT_LIBRARIES/hbPhotosUtilities/hbPhotosUtilities.scptd" "$TARGET_DIR_SCRIPT_LIBRARIES/"
cp -R "$SOURCE_DIR_SCRIPT_LIBRARIES/hbMacRomanUtilities/hbMacRomanUtilities.scptd" "$TARGET_DIR_SCRIPT_LIBRARIES/"
cp -R "$SOURCE_DIR_SCRIPT_LIBRARIES/hbStringUtilities/hbStringUtilities.scptd" "$TARGET_DIR_SCRIPT_LIBRARIES/"
cp -R "$SOURCE_DIR_SCRIPT_LIBRARIES/hbPhotosServices/hbPhotosServices.scptd" "$TARGET_DIR_SCRIPT_LIBRARIES/"

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
