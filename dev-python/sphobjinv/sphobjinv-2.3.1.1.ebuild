# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

DESCRIPTION="Sphinx objects.inv Inspection/Manipulation Tool"
HOMEPAGE="
	https://github.com/bskinn/sphobjinv/
	https://pypi.org/project/sphobjinv/
"
SRC_URI="
	https://github.com/bskinn/${PN}/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	>=dev-python/attrs-19.2[${PYTHON_USEDEP}]
	dev-python/certifi[${PYTHON_USEDEP}]
	dev-python/fuzzywuzzy[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-3.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/dictdiffer[${PYTHON_USEDEP}]
		dev-python/pytest-check[${PYTHON_USEDEP}]
		dev-python/pytest-ordering[${PYTHON_USEDEP}]
		dev-python/pytest-timeout[${PYTHON_USEDEP}]
		>=dev-python/stdio-mgr-1.0.1[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/timeout-decorator[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# Internet
	README.rst::README.rst
	tests/test_readme.py::test_readme_shell_cmds
)

src_prepare() {
	sed -e '/CLI_TEST_TIMEOUT/s/2/20/' -i tests/test_cli.py || die

	# remove bundled deps
	rm -r src/sphobjinv/_vendored || die
	sed -i -e 's:sphobjinv[.]_vendored[.]::' src/sphobjinv/*.py || die

	distutils-r1_src_prepare
}
