# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Terminal text editor"
HOMEPAGE="http://lav.yar.ru/programs.html"
SRC_URI="http://lav.yar.ru/download/le/le-${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="sys-libs/ncurses:0="
DEPEND="${RDEPEND}"

src_install() {
	emake DESTDIR="${D}" install
	dodoc ChangeLog FEATURES HISTORY INSTALL NEWS README TODO
}
