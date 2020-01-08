# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

DESCRIPTION="Utility to view Radeon GPU utilization"
HOMEPAGE="https://github.com/clbr/radeontop"
SRC_URI="https://github.com/clbr/radeontop/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
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
	nls? ( sys-devel/gettext )
"
BDEPEND="virtual/pkgconfig"

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
	export LIBDIR=$(get_libdir)
	export nls=$(usex nls 1 0)
	export amdgpu=1
	export xcb=1
	# Do not add -g or -s to CFLAGS
	export plain=1
}
