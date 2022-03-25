# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Sphinx objects.inv Inspection/Manipulation Tool"
HOMEPAGE="
	https://github.com/bskinn/sphobjinv/
	https://pypi.org/project/sphobjinv/
"
SRC_URI="
	https://github.com/bskinn/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
"

LICENSE="MIT"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
SLOT="0"

RDEPEND="
	>=dev-python/attrs-19.2[${PYTHON_USEDEP}]
	dev-python/certifi[${PYTHON_USEDEP}]
	dev-python/fuzzywuzzy[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-3.0[${PYTHON_USEDEP}]"
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
distutils_enable_sphinx doc/source \
	dev-python/sphinx_rtd_theme \
	dev-python/sphinx-issues \
	dev-python/sphinxcontrib-programoutput

src_prepare() {
	# --strict option is deprecated in pytest>6
	sed -i -e '/addopts/d' tox.ini || die
	sed -e '/CLI_TEST_TIMEOUT/s/2/20/' -i tests/test_cli.py || die

	# remove bundled deps
	rm -r src/sphobjinv/_vendored || die
	sed -i -e 's:sphobjinv[.]_vendored[.]::' src/sphobjinv/*.py || die

	distutils-r1_src_prepare
}
