# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="A Django plugin for py.test"
HOMEPAGE="
	https://pypi.org/project/pytest-django/
	https://pytest-django.readthedocs.io/
	https://github.com/pytest-dev/pytest-django/
"
SRC_URI="
	https://github.com/pytest-dev/pytest-django/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~sparc ~x86"
SLOT="0"

RDEPEND="
	dev-python/django[${PYTHON_USEDEP}]
	>=dev-python/pytest-5.4[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/setuptools-scm-1.11.1[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}"/${P}-pytest-7.patch
)

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}

distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# something else may be loading it
		tests/test_django_settings_module.py::test_django_not_loaded_without_settings
	)

	local -x DJANGO_SETTINGS_MODULE
	local -x PYTHONPATH=${PWD}
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	local -x PYTEST_PLUGINS=pytest_django.plugin,xdist.plugin
	for DJANGO_SETTINGS_MODULE in pytest_django_test.settings_sqlite{,_file}; do
		einfo "Testing ${DJANGO_SETTINGS_MODULE}"
		epytest tests
	done
}
