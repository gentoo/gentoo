# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( pypy3 python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="OpenAPI schema validation for Python"
HOMEPAGE="
	https://github.com/python-openapi/openapi-schema-validator/
	https://pypi.org/project/openapi-schema-validator/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"

RDEPEND="
	<dev-python/jsonschema-4.18[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-4.0.0[${PYTHON_USEDEP}]
	dev-python/rfc3339-validator[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

src_prepare() {
	sed -e '/--cov/d' -i pyproject.toml || die
	distutils-r1_src_prepare
}
