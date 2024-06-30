# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop

DESCRIPTION="An X11 sfcave clone"
HOMEPAGE="https://web.archive.org/web/20070807143750/http://xsfcave.idios.org/"
SRC_URI="https://downloads.sourceforge.net/scrap/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	x11-libs/libXext
	x11-libs/libSM"
RDEPEND="
	media-fonts/font-misc-misc
	${DEPEND}"

src_install() {
	default
	make_desktop_entry "${PN}"
}
