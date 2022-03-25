# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Django 3rd party (social) account authentication"
HOMEPAGE="
	https://www.intenct.nl/projects/django-allauth/
	https://github.com/pennersr/django-allauth/
	https://pypi.org/project/django-allauth/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/django[${PYTHON_USEDEP}]
	dev-python/pyjwt[${PYTHON_USEDEP}]
	dev-python/python3-openid[${PYTHON_USEDEP}]
	dev-python/requests-oauthlib[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
"
# cryptography via pyjwt[crypto]
RDEPEND+="
	dev-python/cryptography[${PYTHON_USEDEP}]
"
BDEPEND="
	test? ( ${RDEPEND} )
"

DOCS=( README.rst AUTHORS ChangeLog.rst )

src_test() {
	# cern provider tests require Internet
	rm allauth/socialaccount/providers/cern/tests.py || die
	distutils-r1_src_test
}

python_test() {
	local -x DJANGO_SETTINGS_MODULE=test_settings
	local -x PYTHONPATH=.
	django-admin test -v 2 || die "Tests failed with ${EPYTHON}"
}
