# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Game resources for Freedoom: Phase 1+2"
HOMEPAGE="https://freedoom.github.io"
SRC_URI="https://github.com/freedoom/freedoom/releases/download/v${PV}/freedoom-${PV}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="app-arch/unzip"

S="${WORKDIR}/freedoom-${PV}"

DOOMWADPATH=/usr/share/doom

src_install() {
	insinto ${DOOMWADPATH}
	doins freedoom1.wad
	doins freedoom2.wad
	dodoc CREDITS.txt README.html
}

pkg_postinst() {
	elog "Freedoom WAD files installed into ${DOOMWADPATH} directory."
}
