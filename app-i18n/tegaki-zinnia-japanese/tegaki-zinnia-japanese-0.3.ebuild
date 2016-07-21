# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Handwriting model data of Japanese"
HOMEPAGE="http://tegaki.org/"
SRC_URI="http://www.tegaki.org/releases/${PV}/models/${P}.zip"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_prepare() {
	sed -i -e "/^installpath=/s:local/::" Makefile || die
	sed -i -e "/^installpath=/s:installpath=:installpath=${ED}:" Makefile || die
}

src_compile() {
	:
}
