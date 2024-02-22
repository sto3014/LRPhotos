#!/usr/bin/env bash
cd "$(dirname "$0")" 
export SCRIPT_DIR="$(pwd)"

echo copy LRPhotos to ~/Library/...
cp -R "./Application Support" ~/Library
cp -R "./Script Libraries" ~/Library
cp -R "./Services" ~/Library
echo done
