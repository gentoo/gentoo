# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="A helper for organizing Django settings"
HOMEPAGE="
	https://pypi.org/project/django-configurations/
	https://github.com/jazzband/django-configurations/
	https://django-configurations.readthedocs.io/"
SRC_URI="
	https://github.com/jazzband/django-configurations/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/django[${PYTHON_USEDEP}]"
BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	test? (
		dev-python/django-cache-url[${PYTHON_USEDEP}]
		dev-python/dj-database-url[${PYTHON_USEDEP}]
		dev-python/dj-email-url[${PYTHON_USEDEP}]
		dev-python/dj-search-url[${PYTHON_USEDEP}]
	)"

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}

python_test() {
	local -x DJANGO_SETTINGS_MODULE=tests.settings.main
	local -x DJANGO_CONFIGURATION=Test
	distutils_install_for_testing
	django-cadmin test -v2 || die "Tests failed with ${EPYTHON}"
}
