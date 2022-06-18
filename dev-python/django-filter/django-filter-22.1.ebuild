# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Django app allowing declarative dynamic QuerySet filtering from URL parameters"
HOMEPAGE="
	https://github.com/carltongibson/django-filter/
	https://pypi.org/project/django-filter/
"
SRC_URI="
	https://github.com/carltongibson/django-filter/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/django-3.2[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		${RDEPEND}
		dev-python/coreapi[${PYTHON_USEDEP}]
		dev-python/djangorestframework[${PYTHON_USEDEP}]
		dev-python/pytz[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}"/${P}-test-skipIf.patch
)

python_test() {
	local -x DJANGO_SETTINGS_MODULE=tests.settings
	"${EPYTHON}" -m django test -v 2 || die
}
