# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{4,5} pypy)

inherit distutils-r1

MY_PN="h2"

DESCRIPTION="HTTP/2 State-Machine based protocol implementation"
HOMEPAGE="http://python-hyper.org/h2 https://pypi.python.org/pypi/h2"
SRC_URI="mirror://pypi/${P:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	>=dev-python/hyperframe-4.0.1[${PYTHON_USEDEP}]
	<dev-python/hyperframe-5.0.0[${PYTHON_USEDEP}]
	>=dev-python/hpack-2.2.0[${PYTHON_USEDEP}]
	<dev-python/hpack-3.0.0[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '>=dev-python/enum34-1.0.4[${PYTHON_USEDEP}]' python2_7)
	$(python_gen_cond_dep '<dev-python/enum34-2.0.0[${PYTHON_USEDEP}]' python2_7)
"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_PN}-${PV}
