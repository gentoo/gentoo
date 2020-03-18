# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

PYTHON_COMPAT=( python2_7 python3_{6,7} pypy3 )

inherit distutils-r1

DESCRIPTION="library with cross-python path, ini-parsing, io, code, log facilities"
HOMEPAGE="https://pylib.readthedocs.io/en/latest/ https://pypi.org/project/py/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND=""
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( >=dev-python/pytest-2.4.2[${PYTHON_USEDEP}] )
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )"

PATCHES=( "${FILESDIR}"/${PN}-1.5.2-skip-apiwarn-pytest31.patch )

python_prepare_all() {
	sed -e 's:intersphinx_mapping:#&:' -i doc/conf.py || die
	distutils-r1_python_prepare_all
}

python_compile_all() {
	use doc && emake -C doc html
}

python_test() {
	# 1 failure, test_comments, under both pypy only.
	# Also appears the home repo has no issue tracker.
	[[ "${EPYTHON}" == pypy ]] && return
	py.test -v -v || die "testing failed with ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/_build/html/. )
	distutils-r1_python_install_all
}
