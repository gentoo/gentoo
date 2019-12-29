# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{5,6} )
inherit distutils-r1

DESCRIPTION="Data migration utilities"
HOMEPAGE="https://pypi.org/project/into/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="dev-python/datashape[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	>=dev-python/pandas-0.15[${PYTHON_USEDEP}]
	dev-python/toolz[${PYTHON_USEDEP}]
	dev-python/multipledispatch[${PYTHON_USEDEP}]
	dev-python/networkx[${PYTHON_USEDEP}]
	!media-libs/urt" # Bug #552448
