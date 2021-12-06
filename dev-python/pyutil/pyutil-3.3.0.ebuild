# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8,9} )
inherit distutils-r1

DESCRIPTION="A collection of utilities for Python programmers"
HOMEPAGE="https://tahoe-lafs.org/trac/pyutil https://pypi.org/project/pyutil/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="
	dev-python/simplejson[${PYTHON_USEDEP}]
	|| ( dev-python/twisted[${PYTHON_USEDEP}] dev-python/twisted-core[${PYTHON_USEDEP}] )
"

src_install() {
	distutils-r1_src_install
	rm -rf "${ED}"/usr/share/doc/${PN} || die
}
