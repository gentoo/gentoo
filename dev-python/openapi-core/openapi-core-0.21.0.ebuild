# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYPI_VERIFY_REPO=https://github.com/python-openapi/openapi-core
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Client-side and server-side support for the OpenAPI Specification v3"
HOMEPAGE="
	https://github.com/python-openapi/openapi-core/
	https://pypi.org/project/openapi-core/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~loong ppc64 ~riscv x86"

RDEPEND="
	<dev-python/asgiref-4[${PYTHON_USEDEP}]
	>=dev-python/asgiref-3.6.0[${PYTHON_USEDEP}]
	dev-python/isodate[${PYTHON_USEDEP}]
	<dev-python/jsonschema-5[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-4.23.0[${PYTHON_USEDEP}]
	<dev-python/jsonschema-path-0.4[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-path-0.3.4[${PYTHON_USEDEP}]
	dev-python/more-itertools[${PYTHON_USEDEP}]
	dev-python/parse[${PYTHON_USEDEP}]
	<dev-python/openapi-schema-validator-0.7[${PYTHON_USEDEP}]
	>=dev-python/openapi-schema-validator-0.6.0[${PYTHON_USEDEP}]
	<dev-python/openapi-spec-validator-0.8[${PYTHON_USEDEP}]
	>=dev-python/openapi-spec-validator-0.7.1[${PYTHON_USEDEP}]
	>=dev-python/werkzeug-2.1.0[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		>=dev-python/aiohttp-3.8.4[${PYTHON_USEDEP}]
		>=dev-python/aioitertools-0.11.0[${PYTHON_USEDEP}]
		dev-python/flask[${PYTHON_USEDEP}]
		>=dev-python/httpx-0.24.0[${PYTHON_USEDEP}]
		dev-python/responses[${PYTHON_USEDEP}]
		>=dev-python/starlette-0.26.1[${PYTHON_USEDEP}]
		dev-python/strict-rfc3339[${PYTHON_USEDEP}]
		dev-python/webob[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( pytest-{aiohttp,asyncio} )
distutils_enable_tests pytest

EPYTEST_IGNORE=(
	# missing dependendencies
	tests/integration/contrib/falcon
	tests/integration/contrib/fastapi

	# TODO: these tests fail to collect
	tests/integration/validation/test_security_override.py
	tests/integration/validation/test_read_only_write_only.py

	# unhappy about modern django
	tests/integration/contrib/django/test_django_project.py
	tests/unit/contrib/django/test_django.py
)

src_prepare() {
	distutils-r1_src_prepare

	sed -i -e '/--cov/d' pyproject.toml || die
}
