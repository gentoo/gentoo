# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/simpleparse/simpleparse-2.1.1-r1.ebuild,v 1.2 2014/08/10 21:22:17 slyfox Exp $

EAPI=5
PYTHON_COMPAT=(python2_7)
inherit distutils-r1

MY_PN="SimpleParse"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A Parser Generator for mxTextTools"
HOMEPAGE="http://simpleparse.sourceforge.net http://pypi.python.org/pypi/SimpleParse"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="eGenixPublic-1.1 HPND"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc examples test"

S="${WORKDIR}/${MY_P}"

# tests segfault, bug #454680
RESTRICT=test

src_prepare() {
	distutils-r1_src_prepare
	rm -f {examples,tests}/__init__.py
}

src_install() {
	distutils-r1_src_install

	if use doc ; then
		dohtml -r doc/*
	fi

	if use examples ; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}

python_test() {
	PYTHONPATH=${BUILD_DIR}/lib python tests/test.py || die
}
