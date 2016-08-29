# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{3_3,3_4} )
PYTHON_REQ_USE="tk"

inherit distutils-r1

MY_P="Pmw.${PV}"

DESCRIPTION="Toolkit for building high-level compound widgets in Python using the Tkinter module"
HOMEPAGE="http://pmw.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="py3"
KEYWORDS="alpha amd64 ia64 ppc sparc x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE="doc examples test"

DEPEND="!dev-python/pmw:0"
RDEPEND="${DEPEND}"
# https://sourceforge.net/p/pmw/bugs/39/
RESTRICT="test"

S="${WORKDIR}/src"

DOCS="Pmw/README"

python_prepare() {
	distutils-r1_python_prepare
	2to3 Pmw
}

python_test() {
	cd "${BUILD_DIR}/lib/Pmw/Pmw_2_0_0/" || die
	PYTHONPATH=PYTHONPATH=tests:../../
	cp tests/{flagup.bmp,earthris.gif} . || die
	for test in tests/*_test.py; do
		echo "running test "$test
		PYTHONPATH=tests:../../ "${PYTHON}" $test || die
	done
}

python_install_all() {
	local DIR="Pmw/Pmw_2_0_0"

	if use doc; then
		dohtml -a html,gif,py "${DIR}"/doc/*
	fi

	if use examples; then
		insinto "/usr/share/doc/${PF}/examples"
		doins "${DIR}"/demos/*
	fi

	distutils-r1_python_install_all
}
