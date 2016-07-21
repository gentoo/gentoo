# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4} )

inherit distutils-r1

DESCRIPTION="asyncio event loop scheduling callbacks in eventlet"
HOMEPAGE="https://pypi.python.org/pypi/aioeventlet https://bitbucket.org/haypo/aioeventlet"
SRC_URI="mirror://pypi/a/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	dev-python/eventlet[${PYTHON_USEDEP}]
	$(python_gen_cond_dep 'virtual/python-asyncio[${PYTHON_USEDEP}]' 'python3*')
	$(python_gen_cond_dep '>=dev-python/trollius-0.3[${PYTHON_USEDEP}]' 'python2_7')"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
