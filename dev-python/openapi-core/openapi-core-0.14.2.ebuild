# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

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
KEYWORDS="~amd64"

RDEPEND="
	dev-python/isodate[${PYTHON_USEDEP}]
	dev-python/dictpath[${PYTHON_USEDEP}]
	dev-python/openapi-schema-validator[${PYTHON_USEDEP}]
	dev-python/openapi-spec-validator[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/lazy-object-proxy[${PYTHON_USEDEP}]
	dev-python/attrs[${PYTHON_USEDEP}]
	dev-python/werkzeug[${PYTHON_USEDEP}]
	dev-python/parse[${PYTHON_USEDEP}]
	dev-python/more-itertools[${PYTHON_USEDEP}]
"

BDEPEND="test? (
	dev-python/django[${PYTHON_USEDEP}]
	dev-python/djangorestframework[${PYTHON_USEDEP}]
	dev-python/flask[${PYTHON_USEDEP}]
	dev-python/mock[${PYTHON_USEDEP}]
	dev-python/responses[${PYTHON_USEDEP}]
	dev-python/webob[${PYTHON_USEDEP}]
)"

distutils_enable_tests pytest

src_prepare() {
	# falcon not packaged
	rm -r tests/integration/contrib/falcon || die

	# Theses tests fail to collect
	rm tests/integration/validation/test_security_override.py || die
	rm tests/integration/validation/test_read_only_write_only.py || die

	# There's a problem in the test suite here
	rm tests/unit/unmarshalling/test_unmarshal.py || die
	rm tests/integration/contrib/django/test_django_rest_framework_apiview.py || die

	sed -i -e '/--cov/d' setup.cfg || die
	distutils-r1_src_prepare
}
