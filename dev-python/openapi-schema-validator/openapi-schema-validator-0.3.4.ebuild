# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( pypy3 python3_{8..11} )

inherit distutils-r1

DESCRIPTION="OpenAPI schema validation for Python"
HOMEPAGE="
	https://github.com/p1c2u/openapi-schema-validator/
	https://pypi.org/project/openapi-schema-validator/
"
SRC_URI="
	https://github.com/p1c2u/openapi-schema-validator/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"

RDEPEND="
	>=dev-python/attrs-19.2.0[${PYTHON_USEDEP}]
	dev-python/isodate[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-4.0.0[${PYTHON_USEDEP}]
	dev-python/rfc3339-validator[${PYTHON_USEDEP}]
	dev-python/strict-rfc3339[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

src_prepare() {
	sed -e '/--cov/d' -i pyproject.toml || die
	distutils-r1_src_prepare
}
