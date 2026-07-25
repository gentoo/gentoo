# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson-multilib

DESCRIPTION="Library for DVD navigation tools"
HOMEPAGE="https://www.videolan.org/developers/libdvdnav.html"
if [[ ${PV} = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://code.videolan.org/videolan/libdvdnav.git"
else
	SRC_URI="https://downloads.videolan.org/pub/videolan/libdvdnav/${PV}/${P}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~x64-macos"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="static-libs"

RDEPEND=">=media-libs/libdvdread-6.0.0:=[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"

src_prepare() {
	sed -i -e "s/'COPYING', //" -e "s/doc\/${PN}/doc\/${P}/" meson.build || die

	default
}

multilib_src_configure() {
	local emesonargs=(
		-Ddefault_library=$(usex static-libs both shared)
	)

	meson_src_configure
}
