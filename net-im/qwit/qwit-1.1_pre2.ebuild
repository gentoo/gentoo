# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit qt4-r2

MY_P=${P/_/-}-src

DESCRIPTION="Qt4 cross-platform client for Twitter"
HOMEPAGE="https://code.google.com/p/qwit/"
SRC_URI="https://${PN}.googlecode.com/files/${MY_P}.tar.bz2"

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
