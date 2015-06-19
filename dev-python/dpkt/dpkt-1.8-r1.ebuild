# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/dpkt/dpkt-1.8-r1.ebuild,v 1.3 2015/03/08 23:45:48 pacho Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Fast, simple packet creation / parsing, with definitions for the basic TCP/IP protocols"
HOMEPAGE="http://code.google.com/p/dpkt/"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="examples"

DEPEND=""
RDEPEND=""

DOCS=( AUTHORS CHANGES HACKING )

python_test() {
	"${PYTHON}" tests/test-perf2.py || die
}

src_install() {
	distutils-r1_src_install

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
