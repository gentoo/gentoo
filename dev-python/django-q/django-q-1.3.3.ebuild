# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8,9} )

inherit distutils-r1

DESCRIPTION="A multiprocessing distributed task queue for Django"
HOMEPAGE="https://django-q.readthedocs.org"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="dev-python/django[${PYTHON_USEDEP}]
	dev-python/django-picklefield[${PYTHON_USEDEP}]
	dev-python/blessed[${PYTHON_USEDEP}]
	dev-python/arrow[${PYTHON_USEDEP}]"

DOCS=( README.rst )
