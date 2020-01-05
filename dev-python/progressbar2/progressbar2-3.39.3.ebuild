# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 python3_{6,7} pypy3)

inherit distutils-r1

DESCRIPTION="Text progressbar library for python"
HOMEPAGE="https://pypi.org/project/progressbar2/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

CDEPEND="!dev-python/progressbar[${PYTHON_USEDEP}]
	dev-python/python-utils[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="${CDEPEND}"
BDEPEND="${CDEPEND}"
