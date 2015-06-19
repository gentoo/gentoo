# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/dia2code/dia2code-0.8.7.ebuild,v 1.4 2014/09/04 09:32:58 pacho Exp $

EAPI=5
GCONF_DEBUG="no"

inherit gnome2

DESCRIPTION="Convert UML diagrams produced with Dia to various source code flavours"
HOMEPAGE="http://dia2code.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ia64 ~ppc ~sparc x86"
IUSE=""

DEPEND="dev-libs/libxml2"
RDEPEND="${DEPEND}"

src_install() {
	gnome2_src_install
	doman dia2code.1
}
