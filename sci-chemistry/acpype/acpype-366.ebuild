# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3

inherit eutils python
PYTHON_DEPEND="2:2.5"

DESCRIPTION="AnteChamber PYthon Parser interfacE"
HOMEPAGE="http://code.google.com/p/acpype/"
SRC_URI="mirror://gentoo/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux"
IUSE=""

DEPEND="sci-chemistry/ambertools"
RDEPEND="${DEPEND}"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	epatch "${FILESDIR}/${PN}.patch"
	python_convert_shebangs -r 2 .
}

src_install() {
	newbin ${PN}.py ${PN}
	newbin CcpnToAcpype.py CcpnToAcpype
	dodoc NOTE.txt README.txt
	insinto /usr/share/${PN}
	doins -r ffamber_additions test
}
