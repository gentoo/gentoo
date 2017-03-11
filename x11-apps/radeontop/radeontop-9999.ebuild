# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit toolchain-funcs git-r3

DESCRIPTION="Utility to view Radeon GPU utilization"
HOMEPAGE="https://github.com/clbr/radeontop"
LICENSE="GPL-3"
EGIT_REPO_URI="https://github.com/clbr/radeontop.git"

SLOT="0"
KEYWORDS=""
IUSE="nls"

RDEPEND="
	sys-libs/ncurses:0=
	x11-libs/libdrm
	x11-libs/libpciaccess
	x11-libs/libxcb
	nls? (
		sys-libs/ncurses:0=[unicode]
		virtual/libintl
	)
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

src_configure() {
	tc-export CC
	export nls=$(usex nls 1 0)
	export xcb=1
	# Do not add -g or -s to CFLAGS
	export plain=1
}
