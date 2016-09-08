# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

SUB_VER=0.15
MY_TAR=napi_v${PV}_subotage_${SUB_VER}

DESCRIPTION="Napiprojekt.pl subtitle downloader in bash"
HOMEPAGE="https://sourceforge.net/projects/bashnapi/"
SRC_URI="mirror://sourceforge/${PN}/${MY_TAR}.tgz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S=${WORKDIR}/napi

src_install() {
	default # for docs

	dobin napi.sh
}

pkg_postinst() {
	elog "Optional runtime dependencies:"
	elog
	elog "   \033[1mmedia-video/subotage\033[0m for subtitle format conversion"
	elog
	elog "   \033[1mmedia-video/mediainfo\033[0m"
	elog "or \033[1mmedia-video/mplayer\033[0m for FPS detection (for conversion)"
}
