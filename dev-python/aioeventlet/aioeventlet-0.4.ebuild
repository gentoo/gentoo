# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/aioeventlet/aioeventlet-0.4.ebuild,v 1.3 2015/07/07 15:49:43 zlogene Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 python3_3 python3_4 )

inherit distutils-r1

DESCRIPTION="asyncio event loop scheduling callbacks in eventlet"
HOMEPAGE="http://pypi.python.org/pypi/aioeventlet https://bitbucket.org/haypo/aioeventlet"
SRC_URI="mirror://pypi/a/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

RDEPEND="
	dev-python/eventlet[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '>=dev-python/asyncio-0.4.1[${PYTHON_USEDEP}]' 'python3_3')
	$(python_gen_cond_dep '>=dev-python/trollius-0.3[${PYTHON_USEDEP}]' 'python2_7')"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
