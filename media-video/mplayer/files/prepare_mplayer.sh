#!/bin/sh
VERSION=$(date +%Y%m%d)
PACKAGE="mplayer-1.2_pre${VERSION}"
DUMP_FFMPEG="$(dirname $0)/dump_ffmpeg.sh"

svn checkout svn://svn.mplayerhq.hu/mplayer/trunk ${PACKAGE}

pushd ${PACKAGE} > /dev/null
	# ffmpeg is in git now so no svn external anymore
	rm -rf ffmpeg
	git clone git://source.ffmpeg.org/ffmpeg.git ffmpeg/
        sh "$DUMP_FFMPEG"
	STORE_VERSION=$(LC_ALL=C svn info 2> /dev/null | grep Revision | cut -d' ' -f2)
	printf "$STORE_VERSION" > snapshot_version
popd > /dev/null

find "${PACKAGE}" -type d -name '.svn' -prune -print0 | xargs -0 rm -rf
find "${PACKAGE}" -type d -name '.git' -prune -print0 | xargs -0 rm -rf

tar cJf ${PACKAGE}.tar.xz ${PACKAGE}
rm -rf ${PACKAGE}/

echo "Tarball: \"${PACKAGE}.tar.xz\""

echo "** all done **"
