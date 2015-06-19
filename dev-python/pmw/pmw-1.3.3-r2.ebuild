# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pmw/pmw-1.3.3-r2.ebuild,v 1.8 2015/06/02 05:12:02 jmorgan Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="tk"

inherit distutils-r1

MY_P="Pmw.${PV}"

DESCRIPTION="Toolkit for building high-level compound widgets in Python using the Tkinter module"
HOMEPAGE="http://pmw.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="py2"
KEYWORDS="alpha amd64 ia64 ppc sparc x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE="doc examples"

DEPEND="!dev-python/pmw:0"
RDEPEND="${DEPEND}"

S="${WORKDIR}/src"

DOCS="Pmw/README"
# http://sourceforge.net/p/pmw/bugs/39/
RESTRICT="test"

PATCHES=( "${FILESDIR}"/${P}-install-no-docs.patch )

python_test() {
	cd "${BUILD_DIR}/lib/Pmw/Pmw_1_3_3/" || die
	PYTHONPATH=PYTHONPATH=tests:../../
	cp tests/{flagup.bmp,earthris.gif} . || die
	for test in tests/*_test.py; do
		echo "running test "$test
		PYTHONPATH=tests:../../ "${PYTHON}" $test || die
	done
}

python_install_all() {
	local DIR="Pmw/Pmw_1_3_3"

	if use doc; then
		dohtml -a html,gif,py ${DIR}/doc/*
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins ${DIR}/demos/*
	fi

	distutils-r1_python_install_all
}
