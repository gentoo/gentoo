# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit optfeature vdr-plugin-2

DESCRIPTION="VDR Plugin: Play video files not supported by VDR with mplayer (divx and more)"
HOMEPAGE="https://www.muempf.de/"
SRC_URI="https://www.muempf.de/down/vdr-mp3-${PV}.tar.gz"
S=${WORKDIR}/mp3-${PV}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="media-video/vdr"
RDEPEND="${DEPEND}
	media-video/mplay-sh
	sys-apps/util-linux"

PATCHES=( "${FILESDIR}/${PV}/01_gentoo.diff" )

VDR_RCADDON_FILE="${FILESDIR}/rc-addon-0.9.15.sh"
VDR_CONFD_FILE="${FILESDIR}/confd-0.9.15.sh"

src_prepare() {
	vdr-plugin-2_src_prepare

	if has_version ">=media-video/vdr-2.1.2"; then
		sed -e "s#VideoDirectory#cVideoDirectory::Name\(\)#" \
		-i decoder.c \
		-i player-mplayer.c || die
	fi

	# bug 787557
	eapply "${FILESDIR}/${P}_tc-directly.patch"
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
	elog "Edit all config files in /etc/vdr/plugins/mplayer"
	echo
	optfeature "playing mp3, ogg and wav files" media-plugins/vdr-mp3ng
}
