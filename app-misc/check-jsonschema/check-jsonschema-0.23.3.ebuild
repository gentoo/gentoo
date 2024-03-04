# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} pypy3 )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="A CLI and set of pre-commit hooks for jsonschema validation"
HOMEPAGE="
	https://pypi.org/project/check-jsonschema/
	https://github.com/python-jsonschema/check-jsonschema
"
SRC_URI="https://github.com/python-jsonschema/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~riscv"

RDEPEND="
	dev-python/ruamel-yaml[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-4.5.1[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/click[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		${RDEPEND}
		dev-python/responses[${PYTHON_USEDEP}]
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
	)
"

DOCS=(
	README.md
	CONTRIBUTING.md
	CHANGELOG.rst
)

distutils_enable_tests pytest
distutils_enable_sphinx docs \
		dev-python/sphinx-issues \
		dev-python/furo

python_prepare_all() {
	# relax deps in setup.cfg
	sed -r -e 's:([a-zA-Z.-]+)([<>]|==|[<>]=)+.+:\1: ; /importlib-resources/ d' -i setup.cfg || die

	distutils-r1_python_prepare_all
}
