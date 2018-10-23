#!/bin/sh
#set -x

##
# Temporary path
TMP_DIR="/tmp/por"
MYCURDIR=`pwd`

##
# Path of the executable: set it to empty when this is the current directory.
EXEC_PATH=`dirname $0`
# Trick to get the actual full-path
EXEC_FULL_PATH=`pushd ${EXEC_PATH}`
EXEC_FULL_PATH=`echo ${EXEC_FULL_PATH} | cut -d' ' -f1`
EXEC_FULL_PATH=`echo ${EXEC_FULL_PATH} | sed -e 's|~|'${HOME}'|'`
#
CURRENT_DIR=`pwd`
if [ ${CURRENT_DIR} -ef ${EXEC_PATH} ]
then
    EXEC_PATH="."
    TMP_DIR="."
fi
# If the international org-reference POR dump file is in the current directory,
# then the current directory is certainly intended to be the temporary directory.
if [ -f ${INTORG_TAB_FILENAME} ]
then
    TMP_DIR="."
fi
EXEC_PATH="${EXEC_PATH}/"
TMP_DIR="${TMP_DIR}/"

if [ ! -d ${TMP_DIR} -o ! -w ${TMP_DIR} ]
then
    \mkdir -p ${TMP_DIR}
fi

##
# OpenTravelData directory
OPTD_DIR=`dirname ${EXEC_FULL_PATH}`
OPTD_DIR="${OPTD_DIR}/"

##
# OPTD sub-directory
DATA_DIR=${OPTD_DIR}opentraveldata/
TOOLS_DIR=${OPTD_DIR}tools/

##
# Sanity check: that (executable) script should be located in the tools/
# sub-directory of the OpenTravelData project Git clone
EXEC_DIR_NAME=`basename ${EXEC_FULL_PATH}`
if [ "${EXEC_DIR_NAME}" != "tools" ]
then
    echo
    echo "[$0:$LINENO] Inconsistency error: this script ($0) should be located in the tools/ sub-directory of the OpenTravelData project Git clone, but apparently is not. EXEC_FULL_PATH=\"${EXEC_FULL_PATH}\""
    echo
    exit -1
fi

# Input data file: OpenTravelData (OPTD) generated POR
OPTD_POR_FILENAME="optd_por_public_all.csv"

# Output data file: POR having a UN/LOCODE
TGT_FILENAME="optd_por_unlc.csv"

# Full file-path
OPTD_POR_FILE="${DATA_DIR}${OPTD_POR_FILENAME}"
TGT_FILE="${DATA_DIR}${TGT_FILENAME}"

# Temporary
TMP_TGT_FILE=${TGT_FILE}.tmp
STD_TGT_FILE=${TGT_FILE}.std
HDR_TGT_FILE=${TGT_FILE}.hdr

# Processing
PROCESSOR="extract_por_unlc.awk"
time awk -F'^' -f ${PROCESSOR} ${OPTD_POR_FILE} > ${TMP_TGT_FILE}
sort -t'^' -k1,1 ${TMP_TGT_FILE} | uniq > ${STD_TGT_FILE}
echo "unlocode^latitude^longitude^geonames_id^feat_class^feat_code" \
	 > ${HDR_TGT_FILE}
cat ${HDR_TGT_FILE} ${STD_TGT_FILE} > ${TGT_FILE}

# Cleaning
\rm -f ${TMP_TGT_FILE} ${HDR_TGT_FILE} ${STD_TGT_FILE}

# Reporting
NB_POR=`wc -l ${TGT_FILE}|sed -e 's/^\([^0-9]*\)\([0-9]\+\)\([^0-9]\)*$/\2/g'`
echo
echo "The UN/LOCODE POR file ('${TGT_FILE}') has been generated from '${OPTD_POR_FILE}'"
echo "There are ${NB_POR} records"
echo

