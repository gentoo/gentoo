# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Terminal text editor"
HOMEPAGE="http://lav.yar.ru/programs.html"
SRC_URI="http://lav.yar.ru/download/le/le-${PV}.tar.gz"

DOCS="AUTHORS ChangeLog FEATURES HISTORY INSTALL NEWS README THANKS TODO"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ppc x86"

RDEPEND="sys-libs/ncurses:0="
DEPEND="${RDEPEND}"

src_install() {
	emake DESTDIR="${D}" install
	einstalldocs
}
