# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils

DESCRIPTION="menu generator for *box, WindowMaker, and Enlightenment"
HOMEPAGE="http://f00l.de/genmenu/"
SRC_URI="http://f00l.de/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86 ~x86-fbsd"
IUSE=""

RDEPEND="app-shells/bash"

src_prepare() {
	epatch "${FILESDIR}"/genmenu-1.0.2.patch
}

src_install() {
	dobin genmenu
	dodoc ChangeLog README
}
