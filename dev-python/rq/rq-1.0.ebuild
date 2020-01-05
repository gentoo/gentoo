# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_6 )
inherit distutils-r1

DESCRIPTION="simple, lightweight library for creating and processing background jobs"
HOMEPAGE="https://github.com/rq/rq"
SRC_URI="mirror://pypi/${PN:0:1}"/${PN}/${P}.tar.gz

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=" >=dev-python/click-5.0[${PYTHON_USEDEP}]
	>=dev-python/redis-py-3.0.0[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
