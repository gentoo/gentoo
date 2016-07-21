# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="Visual binary diff utility"

HOMEPAGE="http://www.cjmweb.net/vbindiff/"
SRC_URI="http://www.cjmweb.net/vbindiff/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86 ~x86-fbsd"
IUSE="debug"

RDEPEND="sys-libs/ncurses"
DEPEND="${RDEPEND}"

src_compile() {
	econf $(use_enable debug)
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc AUTHORS NEWS README README.PuTTY || die
}
