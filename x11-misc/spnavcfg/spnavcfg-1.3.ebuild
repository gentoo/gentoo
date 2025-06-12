# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs xdg-utils

DESCRIPTION="Qt-based GUI to configure a space navigator device"
HOMEPAGE="https://spacenav.sourceforge.net/"
SRC_URI="https://github.com/FreeSpacenav/spnavcfg/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

COMMON_DEPEND=">=dev-libs/libspnav-1.2[X]
	dev-qt/qtbase:6[gui,widgets]
	x11-libs/libX11"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig"
RDEPEND="${COMMON_DEPEND}
	>=app-misc/spacenavd-1[X]"

src_configure() {
	# Note: Makefile uses $(add_cflags) inside $(CXXFLAGS)
	CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		econf --disable-debug --disable-opt --qt6
}

src_compile() {
	local args=(
		CC="$(tc-getCC)"
		CXX="$(tc-getCXX)"
		libpath="-L/usr/$(get_libdir)"
	)
	emake "${args[@]}"
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
