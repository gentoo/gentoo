# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit toolchain-funcs

DESCRIPTION="Utility to view Radeon GPU utilization"
HOMEPAGE="https://github.com/clbr/radeontop"
LICENSE="GPL-3"
SRC_URI="https://github.com/clbr/radeontop/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~x86"
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

src_prepare() {
	default

	cat > include/version.h <<-EOF || die
	#ifndef VER_H
	#define VER_H

	#define VERSION "${PV}"

	#endif
	EOF
	>getver.sh || die
	touch .git || die
}

src_configure() {
	tc-export CC
	export nls=$(usex nls 1 0)
	export xcb=1
	# Do not add -g or -s to CFLAGS
	export plain=1
}
