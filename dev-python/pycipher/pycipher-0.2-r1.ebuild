# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit python-r1

DESCRIPTION="A Python module that implements several well-known classical cipher algorithms"
HOMEPAGE="http://pycipher.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.py"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=""
RDEPEND=""

src_unpack() {
	mkdir "${S}" || die
	cp "${DISTDIR}/${A}" "${S}/${PN}.py" || die
}

src_install() {
	python_foreach_impl python_domodule ${PN}.py
}
