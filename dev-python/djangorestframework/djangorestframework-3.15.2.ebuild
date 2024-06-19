# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

MY_P=django-rest-framework-${PV}
DESCRIPTION="Web APIs with django made easy"
HOMEPAGE="
	https://www.django-rest-framework.org/
	https://github.com/encode/django-rest-framework/
	https://pypi.org/project/djangorestframework/
"
SRC_URI="
	https://github.com/encode/django-rest-framework/archive/${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	>=dev-python/django-4.2[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/inflection[${PYTHON_USEDEP}]
		dev-python/pytest-django[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	tests/test_description.py::TestViewNamesAndDescriptions::test_markdown

	# require coreapi (but not skipped properly)
	tests/schemas/test_managementcommand.py::GenerateSchemaTests::test_coreapi_renders_default_schema_with_custom_title_url_and_desc
	tests/schemas/test_managementcommand.py::GenerateSchemaTests::test_coreapi_renders_openapi_json_schema
	tests/schemas/test_managementcommand.py::GenerateSchemaTests::test_renders_corejson_schema

	# upstream is removing pytz, apparently it's not tested anymore
	# https://github.com/encode/django-rest-framework/discussions/9342
	tests/test_fields.py::TestPytzNaiveDayLightSavingTimeTimeZoneDateTimeField::test_invalid_inputs
)
