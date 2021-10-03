# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="script tag with additional attributes for django.forms.Media"
HOMEPAGE="https://github.com/matthiask/django-js-asset"
SRC_URI="
	https://github.com/matthiask/django-js-asset/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=">=dev-python/django-1.17[${PYTHON_USEDEP}]"
BDEPEND="test? ( ${RDEPEND} )"

PATCHES=(
	"${FILESDIR}/${P}-fix-django3.patch"
)

python_test() {
	cd tests || die
	local -x DJANGO_SETTINGS_MODULE=testapp.settings
	django-admin test -v 2 || die
}
