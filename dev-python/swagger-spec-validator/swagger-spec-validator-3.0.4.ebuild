# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

MY_P=swagger_spec_validator-${PV}
DESCRIPTION="Validate Swagger specs against Swagger 1.1 or 2.0 specification"
HOMEPAGE="
	https://github.com/Yelp/swagger_spec_validator/
	https://pypi.org/project/swagger-spec-validator/
"
SRC_URI="
	https://github.com/Yelp/swagger_spec_validator/archive/v${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	dev-python/jsonschema[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/typing-extensions[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}/${PN}-3.0.4-fix-importlib.patch"
)

distutils_enable_tests pytest
distutils_enable_sphinx docs/source \
	dev-python/sphinx-rtd-theme

EPYTEST_DESELECT=(
	# network (resolver)
	tests/util/validate_spec_url_test.py::test_raise_SwaggerValidationError_on_urlopen_error
	tests/validator12/validate_spec_url_test.py::test_raise_SwaggerValidationError_on_urlopen_error
	tests/validator20/validate_spec_url_test.py::test_raise_SwaggerValidationError_on_urlopen_error
)
