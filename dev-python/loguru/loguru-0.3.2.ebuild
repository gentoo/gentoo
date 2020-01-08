# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

DESCRIPTION="Python logging made (stupidly) simple"
HOMEPAGE="https://github.com/Delgan/loguru"
SRC_URI="https://github.com/Delgan/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND=">=dev-python/colorama-0.3.4[${PYTHON_USEDEP}]"

DEPEND="
	doc? (
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/sphinx_rtd_theme[${PYTHON_USEDEP}]
	)
	test? (
		${RDEPEND}
		>=dev-python/pytest-4.5.0[${PYTHON_USEDEP}]
	)
"

BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

python_compile_all() {
	use doc && esetup.py build_sphinx
}

python_install_all() {
	use doc && HTML_DOCS=( "${BUILD_DIR}"/sphinx/html/. )
	distutils-r1_python_install_all
}

python_test() {
	distutils_install_for_testing
	pytest -vv || die "Tests failed with ${EPYTHON}"
}
