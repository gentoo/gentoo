# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="A helper class for handling configuration defaults of packaged apps gracefully"
HOMEPAGE="https://django-appconf.readthedocs.io/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/django[${PYTHON_USEDEP}]
"

python_test() {
	local -x DJANGO_SETTINGS_MODULE=tests.test_settings
	local -x PYTHONPATH="${S}"
	django-admin test -v 2 || die
}
