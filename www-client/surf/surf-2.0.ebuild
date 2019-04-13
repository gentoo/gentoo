# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit savedconfig toolchain-funcs

DESCRIPTION="a simple web browser based on WebKit/GTK+"
HOMEPAGE="https://surf.suckless.org/"
SRC_URI="
	https://dl.suckless.org/${PN}/${P}.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

COMMON_DEPEND="
	dev-libs/glib:2
	net-libs/libsoup
	net-libs/webkit-gtk:4
	x11-libs/gtk+:3
	x11-libs/libX11
"
DEPEND="
	${COMMON_DEPEND}
	virtual/pkgconfig
"
RDEPEND="
	!sci-chemistry/surf
	${COMMON_DEPEND}
	!savedconfig? (
		net-misc/curl
		x11-apps/xprop
		x11-misc/dmenu
		x11-terms/st
	)
"
PATCHES=(
	"${FILESDIR}"/${PN}-2.0-gentoo.patch
)

pkg_setup() {
	if ! use savedconfig; then
		elog "The default config.h assumes you have"
		elog " net-misc/curl"
		elog " x11-terms/st"
		elog "installed to support the download function."
		elog "Without those, downloads will fail (gracefully)."
		elog "You can fix this by:"
		elog "1) Installing these packages, or"
		elog "2) Setting USE=savedconfig and changing config.h accordingly."
	fi
}

src_prepare() {
	default

	restore_config config.h

	tc-export CC PKG_CONFIG
}

src_install() {
	default

	save_config config.h
}
