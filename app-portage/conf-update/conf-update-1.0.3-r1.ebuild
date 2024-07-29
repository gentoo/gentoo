# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="${PN} is a ncurses-based config management utility"
HOMEPAGE="https://gitweb.gentoo.org/proj/conf-update.git/"
SRC_URI="https://gitweb.gentoo.org/proj/${PN}.git/snapshot/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="colordiff"

RDEPEND="
	dev-libs/glib
	sys-libs/ncurses:0
	colordiff? ( app-misc/colordiff )
	dev-libs/openssl:0=
	"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${P}-fno-common.patch )

src_prepare() {
	default
	sed -i -e "s/\$Rev:.*\\$/${PVR}/" ${PN}.h || die
	if use colordiff ; then
		sed -i -e "s/diff_tool=diff/diff_tool=colordiff/" ${PN}.conf || die
	fi
	tc-export PKG_CONFIG
}

src_compile() {
	emake CC="$(tc-getCC)"
}
