# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Game resources for FreeDM"
HOMEPAGE="https://freedoom.github.io"
SRC_URI="https://github.com/freedoom/freedoom/releases/download/v${PV}/freedm-${PV}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="app-arch/unzip"

S="${WORKDIR}/freedm-${PV}"

DOOMWADPATH=/usr/share/doom

src_install() {
	insinto ${DOOMWADPATH}
	doins freedm.wad
	dodoc CREDITS.txt README.html
}

pkg_postinst() {
	elog "FreeDM WAD file installed into ${DOOMWADPATH} directory."
}
