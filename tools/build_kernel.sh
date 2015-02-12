#!/bin/bash
## Build Automation Scripts - Kernel Edition
##
## Copywrite 2014 - Donald Hoskins <grommish@gmail.com>
## on behalf of Team Octos et al.

# Figure out where we are, so we can get back
CWD=$(pwd)
echo "Currently working in: ${CWD}"
# Set the Revision
REV="0.1"
BUILD_DATE=`date -u +%Y%m%d-%H%M`
OUT_ZIP="OCT-L-${BUILD_DATE}-${TO_BUILD}-kernel.zip"

echo "Using $OUT_ZIP"
# Check some basic premises
# Is OUT defined?
if [[ $OUT == "" ]]; then
  source ${CWD}/build/envsetup.sh
fi

# Is the device defined?
if [[ $TO_BUILD == "" || $TO_BUILD == "full" ]]; then
  echo -e "No device selected to build the kernel for!\r\nRun 'lunch' and try again."
  exit -1
fi

# Kernel Out Dir - This Directory Hold the Updater Scripts and Structure
KOUT="${CWD}/kernel-dev"
UPDATER="vendor/to/tools/Octos_Template.zip"

## Clean Up Previous Builds as well as old module files
make installclean && rm -rf ${KOUT}

# Build command
make -j${TO_OR} bootimage

echo "Using ${UPDATER} - ${UPDATER##*/}"
if [[ -d $KOUT ]]; then
   rm -rf ${KOUT}
fi

mkdir -p ${KOUT}
cp ${UPDATER} ${KOUT}
cd ${KOUT} && unzip ${UPDATER##*/} && rm -rf *.zip

echo "Moving boot.img to ${KOUT}"
cp -f ${OUT}/boot.img ${KOUT}
echo "Moving modules to ${KOUT}/system/lib/modules/"
cp -f ${OUT}/system/lib/modules/*.ko ${KOUT}/system/lib/modules/
echo "Ziping Flashable"
cd ${KOUT} && zip -r ${OUT_ZIP} * && cd ${CWD}
