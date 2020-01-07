# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_6 )
inherit distutils-r1

DESCRIPTION="Full featured redis cache backend for Django."
HOMEPAGE="https://github.com/niwinz/django-redis"
SRC_URI="mirror://pypi/${PN:0:1}"/${PN}/${P}.tar.gz

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=">=dev-python/django-1.11[${PYTHON_USEDEP}]
	>=dev-python/redis-py-2.10.0[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
