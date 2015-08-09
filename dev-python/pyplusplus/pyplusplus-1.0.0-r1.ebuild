# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Object-oriented framework for creating a code generator for Boost.Python library"
HOMEPAGE="http://www.language-binding.net/"
SRC_URI="mirror://sourceforge/pygccxml/${P}.zip"

LICENSE="freedist Boost-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples +indexing"

DEPEND="app-arch/unzip"
RDEPEND="=dev-python/pygccxml-1.0.0[${PYTHON_USEDEP}]"

S=${WORKDIR}/Py++-${PV}

python_test() {
	"${PYTHON}" unittests/test_all.py || die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/documentation/apidocs/. )
	use examples && local EXAMPLES=( examples/. )

	if use indexing; then
		insinto /usr/include/boost/python/suite/indexing
		doins indexing_suite_v2/indexing/*.hpp
	fi

	distutils-r1_python_install_all
}
