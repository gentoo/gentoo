# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs git-r3

DESCRIPTION="Utility to view Radeon GPU utilization"
HOMEPAGE="https://github.com/clbr/radeontop"
EGIT_REPO_URI="https://github.com/clbr/radeontop.git"

LICENSE="GPL-3"
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
	nls? ( sys-devel/gettext )
"
BDEPEND="virtual/pkgconfig"

src_configure() {
	tc-export CC
	export LIBDIR=$(get_libdir)
	export nls=$(usex nls 1 0)
	export amdgpu=1
	export xcb=1
	# Do not add -g or -s to CFLAGS
	export plain=1
}
