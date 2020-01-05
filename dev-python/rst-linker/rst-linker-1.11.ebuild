# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy3 python{2_7,3_{6,7}} )

inherit distutils-r1

MY_PN="${PN/-/.}"
DESCRIPTION="Sphinx plugin to add links and timestamps to the changelog"
HOMEPAGE="https://github.com/jaraco/rst.linker"
SRC_URI="mirror://pypi/${PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/importlib_metadata[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/setuptools_scm-1.15.0[${PYTHON_USEDEP}]
	doc? (
		>=dev-python/jaraco-packaging-3.2[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
	)
	test? (
		${RDEPEND}
		dev-python/path-py[${PYTHON_USEDEP}]
		>=dev-python/pytest-3.4[${PYTHON_USEDEP}]
	)
"

S="${WORKDIR}/${MY_PN}-${PV}"

python_compile_all() {
	if use doc; then
		sphinx-build docs docs/_build/html || die
		HTML_DOCS=( docs/_build/html/. )
	fi
}

python_test() {
	# Ignore the module from ${S}, use the one from ${BUILD_DIR}
	# Otherwise, ImportMismatchError may occur
	# https://github.com/gentoo/gentoo/pull/1622#issuecomment-224482396
	# Override pytest options to skip flake8
	py.test -v --ignore=rst --override-ini="addopts=--doctest-modules" \
		|| die "tests failed with ${EPYTHON}"
}
