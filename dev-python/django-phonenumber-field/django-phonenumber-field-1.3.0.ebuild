# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{5,6} )

inherit distutils-r1

DESCRIPTION="Phone number normalisation in Django with python-phonenumbers"
HOMEPAGE="https://github.com/stefanfoulis/django-phonenumber-field"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
		dev-python/Babel[${PYTHON_USEDEP}]
		>=dev-python/phonenumbers-7.0.2[${PYTHON_USEDEP}]
		>=dev-python/django-1.5[${PYTHON_USEDEP}]"
