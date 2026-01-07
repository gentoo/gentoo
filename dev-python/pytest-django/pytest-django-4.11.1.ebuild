# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1

DESCRIPTION="A Django plugin for pytest"
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
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv ~sparc x86"

RDEPEND="
	>=dev-python/pytest-7.0.0[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/setuptools-scm-1.11.1[${PYTHON_USEDEP}]
	test? (
		dev-python/django[${PYTHON_USEDEP}]
		>=dev-python/django-configurations-2.0[${PYTHON_USEDEP}]
	)
"

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}

EPYTEST_PLUGIN_LOAD_VIA_ENV=1
EPYTEST_PLUGINS=( "${PN}" pytest-xdist )
distutils_enable_tests pytest

python_test() {
	local -x DJANGO_SETTINGS_MODULE
	local -x PYTHONPATH=${PWD}
	for DJANGO_SETTINGS_MODULE in pytest_django_test.settings_sqlite{,_file}; do
		einfo "Testing ${DJANGO_SETTINGS_MODULE}"
		epytest tests
	done
}
