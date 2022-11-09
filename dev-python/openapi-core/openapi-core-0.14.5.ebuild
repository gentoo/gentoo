# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="Client-side and server-side support for the OpenAPI Specification v3"
HOMEPAGE="
	https://github.com/p1c2u/openapi-core/
	https://pypi.org/project/openapi-core/
"
SRC_URI="
	https://github.com/p1c2u/openapi-core/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/isodate[${PYTHON_USEDEP}]
	dev-python/dictpath[${PYTHON_USEDEP}]
	<dev-python/openapi-schema-validator-0.3[${PYTHON_USEDEP}]
	<dev-python/openapi-spec-validator-0.5[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/lazy-object-proxy[${PYTHON_USEDEP}]
	dev-python/attrs[${PYTHON_USEDEP}]
	dev-python/werkzeug[${PYTHON_USEDEP}]
	dev-python/parse[${PYTHON_USEDEP}]
	dev-python/more-itertools[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		dev-python/flask[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/responses[${PYTHON_USEDEP}]
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
	tests/integration/contrib/test_django.py
	tests/integration/contrib/django
)

EPYTEST_DESELECT=(
	# too new pytest?
	tests/unit/unmarshalling/test_unmarshal.py::TestSchemaUnmarshallerCall::test_string_format_invalid_value
)

src_prepare() {
	sed -i -e '/addopts/d' setup.cfg || die
	distutils-r1_src_prepare
}
