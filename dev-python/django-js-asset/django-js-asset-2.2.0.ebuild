# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Script tag with additional attributes for django.forms.Media"
HOMEPAGE="
	https://github.com/matthiask/django-js-asset/
	https://pypi.org/project/django-js-asset/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/django-3.2[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		${RDEPEND}
	)
"

python_test() {
	cd tests || die
	local -x DJANGO_SETTINGS_MODULE=testapp.settings
	"${EPYTHON}" manage.py test -v 2 || die "Tests failed with ${EPYTHON}"
}
