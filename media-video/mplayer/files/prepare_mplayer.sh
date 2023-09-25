#!/usr/bin/env bash
. /lib/gentoo/functions.sh || { echo "Failed to source gentoo-functions!" ; exit 1 ; }
VERSION=$(date +%Y%m%d)
PACKAGE="mplayer-1.5_p${VERSION}"
DUMP_FFMPEG="$(realpath $(dirname $0)/dump_ffmpeg.sh)"

ebegin "Fetching mplayer from svn"
svn checkout svn://svn.mplayerhq.hu/mplayer/trunk ${PACKAGE}
eend $?

pushd ${PACKAGE} > /dev/null || { eerror "Moving to ${PACKAGE} dir failed!" ; exit 1 ; }
        # ffmpeg is in git now so no svn external anymore
        rm -rf ffmpeg

        ebegin "Cloning ffmpeg from git"
        git clone https://git.ffmpeg.org/ffmpeg.git
        eend $?

        einfo "Extracting version"
        # This should be fatal but it hasn't been fatal in the live ebuild
        # for years and it needs fixing, so...
        bash "${DUMP_FFMPEG}" || ewarn "Dumping ffmpeg failed!"
        STORE_VERSION=$(LC_ALL=C svn info 2> /dev/null | grep Revision | cut -d' ' -f2)
	printf "${STORE_VERSION}" > snapshot_version
        einfo "Got version ${STORE_VERSION}"
popd > /dev/null || { eerror "Returning to previous dir failed!" ; exit 1 ; }

find "${PACKAGE}" -type d -name '.svn' -prune -print0 | xargs -0 rm -rf
find "${PACKAGE}" -type d -name '.git' -prune -print0 | xargs -0 rm -rf

tar --exclude-vcs -cJf ${PACKAGE}.tar.xz ${PACKAGE} || { eerror "Tar creation failed! Error: $?" ; exit 1 ; }
rm -rf ${PACKAGE}/ || { eerror "Removal of ${PACKAGE}? failed! Error: $?" ; exit 1 ; }

einfo "Tarball: \"${PACKAGE}.tar.xz\""
einfo "** all done **"
