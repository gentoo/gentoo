# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib-minimal

DESCRIPTION="D3D12 to Vulkan translation library"
HOMEPAGE="https://gitlab.winehq.org/wine/vkd3d/"
SRC_URI="https://dl.winehq.org/vkd3d/source/${P}.tar.xz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="ncurses spirv-tools"
RESTRICT="test" #838655

RDEPEND="
	media-libs/vulkan-loader[${MULTILIB_USEDEP}]
	ncurses? ( sys-libs/ncurses:= )
	spirv-tools? ( dev-util/spirv-tools[${MULTILIB_USEDEP}] )
"
DEPEND="
	${RDEPEND}
	dev-util/spirv-headers
	dev-util/vulkan-headers
"
BDEPEND="
	sys-devel/flex
	sys-devel/bison
	virtual/pkgconfig
"

multilib_src_configure() {
	local conf=(
		$(multilib_native_use_with ncurses)
		$(use_with spirv-tools)
		--disable-doxygen-pdf
		--without-xcb
		# let users' flags control lto (bug #933178)
		vkd3d_cv_cflags__flto_auto=
	)

	ECONF_SOURCE=${S} econf "${conf[@]}"
}

multilib_src_install_all() {
	einstalldocs

	find "${ED}" -type f -name '*.la' -delete || die
}
