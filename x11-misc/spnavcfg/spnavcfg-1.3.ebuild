# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs xdg-utils

DESCRIPTION="Qt-based GUI to configure a space navigator device"
HOMEPAGE="https://spacenav.sourceforge.net/"
SRC_URI="https://github.com/FreeSpacenav/spnavcfg/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"

COMMON_DEPEND=">=dev-libs/libspnav-1.2[X]
	dev-qt/qtbase:6[gui,widgets]
	x11-libs/libX11"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig"
RDEPEND="${COMMON_DEPEND}
	>=app-misc/spacenavd-1[X]"

src_configure() {
	# Workaround for bug #957962 (and bug #957446#c16). Building via
	# autotools requires a macro like bitcoin or gpgme used in the past
	# to ensure that -mno-direct-extern-access is used if Qt itself was
	# built with it. The flag isn't in Qt's .pc files. It's easiest
	# to just workaround this with -fPIC, but in future, we might
	# either have an eclass helper for this, or just encourage people
	# to use the m4 macro.
	append-flags -fPIC
	append-ldflags -fPIC

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
