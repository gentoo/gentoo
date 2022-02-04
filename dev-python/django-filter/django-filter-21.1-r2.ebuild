# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Django app allowing declarative dynamic QuerySet filtering from URL parameters"
HOMEPAGE="https://github.com/carltongibson/django-filter"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=">=dev-python/django-2.2[${PYTHON_USEDEP}]"
BDEPEND="
	test? (
		${RDEPEND}
		dev-python/coreapi[${PYTHON_USEDEP}]
		dev-python/djangorestframework[${PYTHON_USEDEP}]
		dev-python/pytz[${PYTHON_USEDEP}]
	)"

PATCHES=(
	"${FILESDIR}"/${P}-test-skipIf.patch
)

python_test() {
	local -x DJANGO_SETTINGS_MODULE=tests.settings
	django-admin test -v 2 || die
}
