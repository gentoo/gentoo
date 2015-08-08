# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit python-r1

DESCRIPTION="AnteChamber PYthon Parser interfacE"
HOMEPAGE="http://code.google.com/p/acpype/"
SRC_URI="http://dev.gentoo.org/~jlec/distfiles/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="
	${PYTHON_DEPS}
	sci-chemistry/ambertools"
RDEPEND="${DEPEND}"

src_prepare() {
	sed \
		-e '1s:^:#!/usr/bin/python\n\n:g' \
		-i CcpnToAcpype.py || die
}

src_install() {
	python_parallel_foreach_impl python_newscript ${PN}.py ${PN}
	python_parallel_foreach_impl python_newscript CcpnToAcpype.py CcpnToAcpype
	dodoc NOTE.txt README.txt
	insinto /usr/share/${PN}
	doins -r ffamber_additions test
}
