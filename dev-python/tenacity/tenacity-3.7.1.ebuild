# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5} )

inherit distutils-r1

DESCRIPTION="General-purpose retrying library"
HOMEPAGE="https://github.com/rholder/retrying"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE=""

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
"
RDEPEND="
	>=dev-python/six-1.7.0[${PYTHON_USEDEP}]
	virtual/python-futures[${PYTHON_USEDEP}]
	>=dev-python/monotonic-0.6[${PYTHON_USEDEP}]
	dev-python/debtcollector[${PYTHON_USEDEP}]
"
