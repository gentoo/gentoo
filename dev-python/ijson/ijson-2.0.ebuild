# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

DESCRIPTION="Iterative JSON parser with a Pythonic interface"
HOMEPAGE="https://github.com/isagalaev/ijson https://pypi.python.org/pypi/ijson/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="dev-libs/yajl"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"
