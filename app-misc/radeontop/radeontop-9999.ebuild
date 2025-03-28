# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs git-r3

DESCRIPTION="Utility to view Radeon GPU utilization"
HOMEPAGE="https://github.com/clbr/radeontop"
EGIT_REPO_URI="https://github.com/clbr/radeontop.git"

LICENSE="GPL-3"
SLOT="0"
IUSE="nls video_cards_amdgpu video_cards_radeon"
REQUIRED_USE="|| ( video_cards_amdgpu video_cards_radeon )"

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
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

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
