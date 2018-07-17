# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} pypy pypy3 )

inherit distutils-r1 flag-o-matic

DESCRIPTION="Python multiprocessing fork"
HOMEPAGE="https://pypi.org/project/billiard/ https://github.com/celery/billiard"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="doc test"

RDEPEND=""
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		>=dev-python/case-1.3.1[${PYTHON_USEDEP}]
		>=dev-python/pytest-3.0[${PYTHON_USEDEP}]
	)"
# The usual req'd for tests
DISTUTILS_IN_SOURCE_BUILD=1

python_compile() {
	if !  python_is_python3; then
		local CFLAGS=${CFLAGS}
		append-cflags -fno-strict-aliasing
	fi
	distutils-r1_python_compile
}

python_compile_all() {
	use doc && esetup.py build_sphinx --builder="html" --source-dir=Doc/
}

python_test() {
	esetup.py test
}

python_install_all() {
	use doc && local HTML_DOCS=( build/sphinx/html/. )
	distutils-r1_python_install_all
}
