# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

DESCRIPTION="Utility to view Radeon GPU utilization"
HOMEPAGE="https://github.com/clbr/radeontop"
SRC_URI="https://github.com/clbr/radeontop/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls video_cards_amdgpu video_cards_radeon"
REQUIRED_USE="
	|| ( video_cards_amdgpu video_cards_radeon )
"

RDEPEND="
	sys-libs/ncurses:=
	x11-libs/libdrm[video_cards_amdgpu?,video_cards_radeon?]
	x11-libs/libpciaccess
	x11-libs/libxcb
	nls? (
		sys-libs/ncurses:=[unicode(+)]
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
	export amdgpu=$(usex video_cards_amdgpu 1 0)
	export xcb=1
	# Do not add -g or -s to CFLAGS
	export plain=1
	export PREFIX="${EPREFIX}"/usr
}
