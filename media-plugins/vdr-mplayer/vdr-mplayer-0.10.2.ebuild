# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-mplayer/vdr-mplayer-0.10.2.ebuild,v 1.4 2014/01/08 14:57:18 hd_brummy Exp $

EAPI=5

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: Play video files not supported by VDR with mplayer (divx and more)"
HOMEPAGE="http://www.muempf.de/"
SRC_URI="http://www.muempf.de/down/vdr-mp3-${PV}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=media-video/vdr-1.4.2"

RDEPEND="${DEPEND}
	|| ( media-video/mplay-sh >=media-video/mplayer-sh-0.8.6-r1 )
	virtual/eject"

S=${WORKDIR}/mp3-${PV}

PATCHES=( "${FILESDIR}/${PV}/01_gentoo.diff" )

VDR_RCADDON_FILE=${FILESDIR}/rc-addon-0.9.15.sh
VDR_CONFD_FILE=${FILESDIR}/confd-0.9.15.sh

src_prepare() {
	vdr-plugin-2_src_prepare

	if has_version ">=media-video/vdr-2.1.2"; then
		sed -e "s#VideoDirectory#cVideoDirectory::Name\(\)#" \
		-i decoder.c \
		-i player-mplayer.c
	fi
}

src_install() {
	vdr-plugin-2_src_install

	insinto /etc/vdr/plugins/mplayer
	doins   "${FILESDIR}/mplayersources.conf"

	into /usr/share/vdr/mplayer
	newbin examples/mount.sh.example mount-mplayer.sh

	dodoc HISTORY MANUAL README examples/{image_convert,network}.sh.example
}

pkg_postinst() {
	vdr-plugin-2_pkg_postinst

	echo
	elog "Edit all config's /etc/vdr/plugins/mplayer"
	echo

	if ! has_version "media-plugins/vdr-mp3ng" ; then
		elog "Splitted ebuild!, no support for Audio files"
		elog "To play mp3, ogg and wav files,"
		elog "emerge media-plugins/vdr-mp3ng -pv"
		elog "or"
		elog "emerge media-plugins/vdr-mp3 -pv"
		echo
	fi
}
