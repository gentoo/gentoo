# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="xml(+)"

inherit distutils-r1

DESCRIPTION="Yadis service discovery library"
HOMEPAGE="http://www.openidenabled.com/yadis/libraries/python/"
SRC_URI="http://www.openidenabled.com/resources/downloads/python-openid/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="dev-python/elementtree[${PYTHON_USEDEP}]
	dev-python/python-urljr[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? ( >=dev-python/pyflakes-0.2.1[${PYTHON_USEDEP}] )"

# Fix broken test
PATCHES=( "${FILESDIR}/${P}-gentoo-test.patch" )

python_test() {
	./admin/runtests
	einfo "The pyflake output about XML* redefinitions can be safely ignored"
}
