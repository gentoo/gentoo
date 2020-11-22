# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit git-r3 savedconfig toolchain-funcs

DESCRIPTION="a simple web browser based on WebKit/GTK+"
HOMEPAGE="https://surf.suckless.org/"
EGIT_REPO_URI="https://git.suckless.org/surf"
EGIT_BRANCH="surf-webkit2"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""

COMMON_DEPEND="
	app-crypt/gcr[gtk]
	dev-libs/glib:2
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
		>=x11-misc/dmenu-4.7
		net-misc/curl
		x11-apps/xprop
		x11-terms/st
	)
"
PATCHES=(
	"${FILESDIR}"/${PN}-9999-gentoo.patch
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
