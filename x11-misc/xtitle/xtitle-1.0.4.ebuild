# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Set window title and icon name for an X11 terminal window"
HOMEPAGE="https://kinzler.com/me/xtitle/"
SRC_URI="https://kinzler.com/me/${PN}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="x11-misc/imake"
RDEPEND=""

HTML_DOCS=( xtitle.html )

src_compile() {
	xmkmf || die
	emake
}

src_install() {
	default
	newman "${PN}.man" "${PN}.1"
	einstalldocs
}
