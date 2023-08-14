# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{10..11} )

inherit distutils-r1 pypi

DESCRIPTION="Client-side and server-side support for the OpenAPI Specification v3"
HOMEPAGE="
	https://github.com/python-openapi/openapi-core/
	https://pypi.org/project/openapi-core/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"

RDEPEND="
	<dev-python/asgiref-4[${PYTHON_USEDEP}]
	>=dev-python/asgiref-3.6.0[${PYTHON_USEDEP}]
	dev-python/isodate[${PYTHON_USEDEP}]
	<dev-python/jsonschema-5[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-4.17.3[${PYTHON_USEDEP}]
	<dev-python/jsonschema-spec-0.3[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-spec-0.2.3[${PYTHON_USEDEP}]
	dev-python/more-itertools[${PYTHON_USEDEP}]
	dev-python/parse[${PYTHON_USEDEP}]
	<dev-python/openapi-schema-validator-0.7[${PYTHON_USEDEP}]
	>=dev-python/openapi-schema-validator-0.6.0[${PYTHON_USEDEP}]
	<dev-python/openapi-spec-validator-0.7[${PYTHON_USEDEP}]
	>=dev-python/openapi-spec-validator-0.6.0[${PYTHON_USEDEP}]
	dev-python/werkzeug[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		>=dev-python/aiohttp-3.8.4[${PYTHON_USEDEP}]
		dev-python/flask[${PYTHON_USEDEP}]
		>=dev-python/httpx-0.24.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-aiohttp-1.0.4[${PYTHON_USEDEP}]
		dev-python/responses[${PYTHON_USEDEP}]
		>=dev-python/starlette-0.26.1[${PYTHON_USEDEP}]
		dev-python/strict-rfc3339[${PYTHON_USEDEP}]
		dev-python/webob[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

EPYTEST_IGNORE=(
	# falcon is not packaged
	tests/integration/contrib/falcon

	# TODO: these tests fail to collect
	tests/integration/validation/test_security_override.py
	tests/integration/validation/test_read_only_write_only.py

	# unhappy about modern django
	tests/integration/contrib/django/test_django_project.py
	tests/unit/contrib/django/test_django.py
)

src_prepare() {
	sed -i -e '/--cov/d' pyproject.toml || die
	distutils-r1_src_prepare
}
