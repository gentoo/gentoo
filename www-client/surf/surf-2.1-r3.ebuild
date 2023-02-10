# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop savedconfig toolchain-funcs xdg

DESCRIPTION="A simple web browser based on WebKit/GTK+"
HOMEPAGE="https://surf.suckless.org/"

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://git.suckless.org/surf"
	EGIT_BRANCH="surf-webkit2"
else
	SRC_URI="https://dl.suckless.org/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~riscv ~x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE="tabbed"

DEPEND="
	app-crypt/gcr:0=[gtk]
	dev-libs/glib:2
	net-libs/webkit-gtk:4.1=
	x11-libs/gtk+:3
	x11-libs/libX11
"
RDEPEND="${DEPEND}
	!sci-chemistry/surf
	!savedconfig? (
		net-misc/curl
		x11-apps/xprop
		x11-misc/dmenu
		x11-terms/st
	)
	tabbed? ( x11-misc/tabbed )
"
BDEPEND="
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/${P}-gentoo-webkit-4.1.patch"
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

	if use tabbed; then
		dobin surf-open.sh
	fi

	save_config config.h

	newicon "${S}/${PN}.png" "${PN}.png"

	local mime_types="text/html;text/xml;application/xhtml+xml;"
	mime_types+="x-scheme-handler/http;x-scheme-handler/https;"
	make_desktop_entry \
		"surf %u" \
		"Surf" \
		"surf" \
		"Network;WebBrowser" \
		"MimeType=${mime_types}\nStartupWMClass=surf"
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
