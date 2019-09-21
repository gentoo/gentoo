# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_6 )
inherit distutils-r1

DESCRIPTION="ORM cache with automatic granular event-driven invalidation for Django"
HOMEPAGE="https://github.com/Suor/django-cacheops"
SRC_URI="mirror://pypi/${PN:0:1}"/${PN}/${P}.tar.gz

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=">=dev-python/django-1.8[${PYTHON_USEDEP}]
	>=dev-python/redis-py-2.9.1[${PYTHON_USEDEP}]
	>=dev-python/funcy-1.8[${PYTHON_USEDEP}]
	>=dev-python/six-1.4.0[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
