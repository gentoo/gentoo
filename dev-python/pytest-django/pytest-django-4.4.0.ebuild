# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} )

inherit distutils-r1

DESCRIPTION="A Django plugin for py.test"
HOMEPAGE="
	https://pypi.org/project/pytest-django/
	https://pytest-django.readthedocs.io/
	https://github.com/pytest-dev/pytest-django/"
SRC_URI="
	https://github.com/pytest-dev/pytest-django/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"

LICENSE="BSD"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
SLOT="0"

RDEPEND="
	dev-python/django[${PYTHON_USEDEP}]
	>=dev-python/pytest-5.4[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/setuptools_scm-1.11.1[${PYTHON_USEDEP}]
	test? (
		dev-python/django-configurations[${PYTHON_USEDEP}]
	)
"

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}

distutils_enable_tests --install pytest

python_test() {
	local deselect=(
		# something else may be loading it
		tests/test_django_settings_module.py::test_django_not_loaded_without_settings
	)

	distutils_install_for_testing
	cp -r pytest_django_test "${TEST_DIR}"/lib || die

	local -x DJANGO_SETTINGS_MODULE
	for DJANGO_SETTINGS_MODULE in pytest_django_test.settings_sqlite{,_file}; do
		einfo "Testing ${DJANGO_SETTINGS_MODULE}"
		epytest tests ${deselect[@]/#/--deselect }
	done
}
