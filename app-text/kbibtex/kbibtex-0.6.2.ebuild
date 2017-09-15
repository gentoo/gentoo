# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit kde4-base

DESCRIPTION="BibTeX editor by KDE to edit bibliographies used with LaTeX"
HOMEPAGE="https://userbase.kde.org/KBibTeX"
SRC_URI="mirror://kde/stable/KBibTeX/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="amd64 x86"
IUSE="debug"

DEPEND="
	app-text/poppler[qt4]
	dev-libs/libxml2
	dev-libs/libxslt
	dev-libs/qoauth:0
	virtual/tex-base
	x11-libs/libqxt
"
RDEPEND="${DEPEND}
	dev-tex/bibtex2html
"

PATCHES=( "${FILESDIR}/${P}-webkit.patch" )

src_configure() {
	local mycmakeargs=(
		-DWITH_QTWEBKIT=OFF
	)

	kde4-base_src_configure
}
