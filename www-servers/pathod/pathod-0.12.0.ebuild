# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-servers/pathod/pathod-0.12.0.ebuild,v 1.1 2015/06/01 04:03:42 patrick Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A collection of pathological tools for testing and torturing HTTP clients and servers"
HOMEPAGE="http://pathod.net/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND=">=dev-python/netlib-${PV}[${PYTHON_USEDEP}]
	>=dev-python/requests-2.4.1[${PYTHON_USEDEP}]
	>=dev-python/flask-0.10.1[${PYTHON_USEDEP}]
	dev-python/pyparsing[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? ( >=dev-python/nose-1.3.0[${PYTHON_USEDEP}] )"

python_prepare_all() {
	distutils-r1_python_prepare_all

	# remove unnecessary pip dep
	sed -i '/pip/d' setup.py || die
}

python_test() {
	nosetests -v || die "Tests fail with ${EPYTHON}"
}
