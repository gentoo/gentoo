# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=standalone
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Meson PEP 517 Python build backend"
HOMEPAGE="
	https://pypi.org/project/meson-python/
	https://github.com/mesonbuild/meson-python/
"
SRC_URI="
	https://github.com/mesonbuild/meson-python/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ia64 ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="
	>=dev-python/pyproject-metadata-0.6.1[${PYTHON_USEDEP}]
	>=dev-util/meson-0.63.0[${PYTHON_USEDEP}]
	dev-util/patchelf
	$(python_gen_cond_dep '
		dev-python/typing-extensions[${PYTHON_USEDEP}]
	' 3.8 3.9)
	$(python_gen_cond_dep '
		>=dev-python/tomli-1.0.0[${PYTHON_USEDEP}]
	' 3.8 3.9 3.10)
"
BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	test? (
		dev-python/GitPython[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.11.0-defaults.patch
)

distutils_enable_sphinx docs \
	dev-python/furo \
	dev-python/sphinx-autodoc-typehints
distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# requires network access
	tests/test_pep518.py::test_pep518
)

python_test() {
	local EPYTEST_DESELECT=(
		# requires network access
		tests/test_pep518.py::test_pep518
	)
	unset NINJA

	epytest

	rm -rf docs/examples/spam/build/ || die # remove artifacts
}
