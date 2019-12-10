# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# Tests fail with pypy
PYTHON_COMPAT=( pypy3 python{2_7,3_{5,6,7}} )

inherit distutils-r1

MY_PN="${PN/-/.}"
DESCRIPTION="Classes used by other projects by developer jaraco"
HOMEPAGE="https://github.com/jaraco/jaraco.classes"
SRC_URI="mirror://pypi/${PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="
	<dev-python/namespace-jaraco-2[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/setuptools_scm-1.15.0[${PYTHON_USEDEP}]
	doc? (
		>=dev-python/jaraco-packaging-3.2[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/rst-linker[${PYTHON_USEDEP}]
	)
	test? (
		${RDEPEND}
		>=dev-python/pytest-2.8[${PYTHON_USEDEP}]
	)
"

S="${WORKDIR}/${MY_PN}-${PV}"

python_compile_all() {
	if use doc; then
			cd docs || die
			sphinx-build . _build/html || die
			HTML_DOCS=( docs/_build/html/. )
	fi
}

python_test() {
	# Avoid ImportMismatchError, override pytest options to skip flake8
	pytest -vv "${BUILD_DIR}"/lib --override-ini="addopts=--doctest-modules" \
		|| die "tests failed with ${EPYTHON}"
}

python_install_all() {
	distutils-r1_python_install_all
	find "${ED}" -name '*.pth' -delete || die
}
