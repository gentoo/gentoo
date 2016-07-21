# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

# Note: greenlet is built-in in pypy
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1 flag-o-matic

DESCRIPTION="Lightweight in-process concurrent programming"
HOMEPAGE="https://pypi.python.org/pypi/greenlet/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm -hppa ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc"

DEPEND="app-arch/unzip
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )"
DISTUTILS_IN_SOURCE_BUILD=1

python_compile() {
	if [[ ${EPYTHON} == python2.7 ]]; then
		local CFLAGS=${CFLAGS} CXXFLAGS=${CXXFLAGS}
		append-flags -fno-strict-aliasing
	fi

	distutils-r1_python_compile
}

python_compile_all() {
	use doc && emake -C doc html
}

python_test() {
	"${PYTHON}" run-tests.py -n || die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/_build/html/. )
	distutils-r1_python_install_all
}
