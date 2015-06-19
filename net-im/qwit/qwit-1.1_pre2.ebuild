# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/qwit/qwit-1.1_pre2.ebuild,v 1.5 2014/08/05 18:34:13 mrueg Exp $

EAPI="2"

inherit qt4-r2

MY_P=${P/_/-}-src

DESCRIPTION="Qt4 cross-platform client for Twitter"
HOMEPAGE="http://code.google.com/p/qwit/"
SRC_URI="http://${PN}.googlecode.com/files/${MY_P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DOCS="AUTHORS"

DEPEND="dev-qt/qtgui:4"
RDEPEND="${DEPEND}
	dev-libs/qoauth"

S=${WORKDIR}/${MY_P}

src_configure() {
	eqmake4 ${PN}.pro PREFIX=/usr
}
