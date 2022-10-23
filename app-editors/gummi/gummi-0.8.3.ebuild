# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg-utils

DESCRIPTION="Simple LaTeX editor for GTK+ users"
HOMEPAGE="https://github.com/alexandervdm/gummi"
SRC_URI="https://github.com/alexandervdm/${PN}/releases/download/${PV}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~riscv x86"

RDEPEND="
	app-text/gtkspell:3
	app-text/poppler[cairo]
	dev-libs/glib:2
	dev-texlive/texlive-latex
	dev-texlive/texlive-latexextra
	x11-libs/gtk+:3
	x11-libs/gtksourceview:3.0
	x11-libs/pango
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
"

pkg_postinst() {
	xdg_desktop_database_update

	elog "Gummi supports spell-checking through gtkspell. Support for"
	elog "additional languages can be added by installing myspell-**-"
	elog "packages for your language of choice."
}

pkg_postrm() {
	xdg_desktop_database_update
}
