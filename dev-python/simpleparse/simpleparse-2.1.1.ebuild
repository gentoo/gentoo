# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* *-jython 2.7-pypy-*"

inherit distutils

MY_PN="SimpleParse"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A Parser Generator for mxTextTools"
HOMEPAGE="http://simpleparse.sourceforge.net https://pypi.python.org/pypi/SimpleParse"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="eGenixPublic-1.1 HPND"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="doc examples"

DEPEND=""
RDEPEND=""

S="${WORKDIR}/${MY_P}"

PYTHON_CFLAGS=("2.* + -fno-strict-aliasing")

src_prepare() {
	distutils_src_prepare
	rm -f {examples,tests}/__init__.py
}

src_test() {
	testing() {
		PYTHONPATH="$(ls -d build-${PYTHON_ABI}/lib.*):." "$(PYTHON)" tests/test.py
	}
	python_execute_function testing
}

src_install() {
	distutils_src_install

	if use doc ; then
		dohtml -r doc/*
	fi

	if use examples ; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
