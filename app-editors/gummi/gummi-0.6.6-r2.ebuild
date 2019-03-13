# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools xdg-utils

DESCRIPTION="Simple LaTeX editor for GTK+ users"
HOMEPAGE="https://github.com/alexandervdm/gummi"
SRC_URI="https://github.com/alexandervdm/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE=""

RDEPEND="
	app-text/gtkspell:2
	app-text/poppler[cairo]
	dev-libs/glib:2
	dev-texlive/texlive-latex
	dev-texlive/texlive-latexextra
	x11-libs/gtk+:2
	x11-libs/gtksourceview:2.0
	x11-libs/pango"

DEPEND="${RDEPEND}"

src_prepare() {
	default
	eautoreconf
}

pkg_postinst() {
	xdg_desktop_database_update

	elog "Gummi supports spell-checking through gtkspell. Support for"
	elog "additional languages can be added by installing myspell-**-"
	elog "packages for your language of choice."
}

pkg_postrm() {
	xdg_desktop_database_update
}
