# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( pypy3 python3_{8..11} )

inherit distutils-r1

DESCRIPTION="OpenAPI 2.0 (aka Swagger) and OpenAPI 3.0 spec validator"
HOMEPAGE="
	https://github.com/p1c2u/openapi-spec-validator/
	https://pypi.org/project/openapi-spec-validator/
"
SRC_URI="
	https://github.com/p1c2u/openapi-spec-validator/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"

RDEPEND="
	>=dev-python/jsonschema-4.0.0[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-spec-0.1.1[${PYTHON_USEDEP}]
	>=dev-python/lazy-object-proxy-1.7.1[${PYTHON_USEDEP}]
	>=dev-python/openapi-schema-validator-0.3.2[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-5.1[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		>=dev-python/importlib_resources-5.8.0[${PYTHON_USEDEP}]
	' 3.8)
"

PATCHES=(
	# https://github.com/p1c2u/openapi-spec-validator/pull/174
	"${FILESDIR}/${PN}-0.5.0-std-importlib.patch"
)

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# Internet
	tests/integration/test_shortcuts.py::TestPetstoreV2Example
	tests/integration/test_shortcuts.py::TestApiV2WithExampe
	tests/integration/test_shortcuts.py::TestPetstoreV2ExpandedExample
	tests/integration/test_shortcuts.py::TestPetstoreExample
	tests/integration/test_shortcuts.py::TestRemoteValidatev2SpecUrl
	tests/integration/test_shortcuts.py::TestRemoteValidatev30SpecUrl
	tests/integration/test_shortcuts.py::TestApiWithExample
	tests/integration/test_shortcuts.py::TestPetstoreExpandedExample
	tests/integration/test_validate.py::TestPetstoreExample
	tests/integration/test_validate.py::TestApiWithExample
	tests/integration/test_validate.py::TestPetstoreExpandedExample
	tests/integration/validation/test_validators.py
)

src_prepare() {
	sed -i -e '/--cov/d' pyproject.toml || die
	distutils-r1_src_prepare
}
