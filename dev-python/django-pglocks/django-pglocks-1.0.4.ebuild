# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS="no"
PYTHON_COMPAT=( python3_{7..9} )
inherit distutils-r1

DESCRIPTION="PostgreSQL locking context managers and functions for Django"
HOMEPAGE="https://github.com/Xof/django-pglocks"
SRC_URI="mirror://pypi/${PN:0:1}"/${PN}/${P}.tar.gz

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=">=dev-python/six-1.0.0[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
