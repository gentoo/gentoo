# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/netaddr/netaddr-0.7.15.ebuild,v 1.1 2015/07/02 08:16:10 jlec Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4} )

inherit distutils-r1

DESCRIPTION="Network address representation and manipulation library"
HOMEPAGE="https://github.com/drkjam/netaddr http://pypi.python.org/pypi/netaddr"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="cli test"

RDEPEND="cli? ( >=dev-python/ipython-0.13.1-r1[${PYTHON_USEDEP}] )"
DEPEND="
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		${RDEPEND}
	)"

# test subdir not included in the tarball
# https://github.com/drkjam/netaddr/issues/102
RESTRICT="test"

python_test() {
	esetup.py test
}
