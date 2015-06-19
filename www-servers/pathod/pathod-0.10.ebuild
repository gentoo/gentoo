# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-servers/pathod/pathod-0.10.ebuild,v 1.2 2015/04/08 18:30:55 mgorny Exp $

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
	>=dev-python/requests-1.1.0[${PYTHON_USEDEP}]
	dev-python/flask[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? ( >=dev-python/nose-1.3.0[${PYTHON_USEDEP}] )"

python_test() {
	nosetests -v || die "Tests fail with ${EPYTHON}"
}
