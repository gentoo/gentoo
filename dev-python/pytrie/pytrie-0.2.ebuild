# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{4,5} )

inherit distutils-r1

MY_PN="PyTrie"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A pure Python implementation of the trie data structure."
HOMEPAGE="http://bitbucket.org/gsakkis/pytrie/ https://pypi.python.org/pypi/PyTrie"
SRC_URI="mirror://pypi/${MY_P:0:1}/${MY_PN}/${MY_P}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}
