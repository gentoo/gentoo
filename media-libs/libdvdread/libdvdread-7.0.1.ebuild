# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson-multilib

DESCRIPTION="Library for DVD navigation tools"
HOMEPAGE="https://www.videolan.org/developers/libdvdnav.html"
if [[ ${PV} = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://code.videolan.org/videolan/libdvdread.git"
else
	SRC_URI="https://downloads.videolan.org/pub/videolan/libdvdread/${PV}/${P}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~x64-macos"
fi

# See https://code.videolan.org/videolan/libdvdread/-/commit/0e020921726ee812e633959d9ad6315ff58b902b
LICENSE="GPL-2 GPL-3"
SLOT="0/8" # libdvdread.so.VERSION
IUSE="+css static-libs"

RDEPEND="css? ( >=media-libs/libdvdcss-1.3.0[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	sed -i -e "s/'COPYING', //" -e "s/doc\/${PN}/doc\/${P}/" meson.build || die

	default
}

multilib_src_configure() {
	local emesonargs=(
		-Ddefault_library=$(usex static-libs both shared)

		$(meson_feature css libdvdcss)
	)

	meson_src_configure
}
