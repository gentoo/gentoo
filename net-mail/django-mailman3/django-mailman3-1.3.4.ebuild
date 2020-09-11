# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="Django-based interfaces interacting with Mailman 3"
HOMEPAGE="https://www.list.org"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="dev-python/django[${PYTHON_USEDEP}]
	net-mail/mailmanclient[${PYTHON_USEDEP}]
	dev-python/django-allauth[${PYTHON_USEDEP}]
	dev-python/django-gravatar2[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
"

DOCS=( README.rst )
