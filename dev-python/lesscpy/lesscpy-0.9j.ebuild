# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/lesscpy/lesscpy-0.9j.ebuild,v 1.4 2015/03/08 23:52:22 pacho Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A compiler written in Python for the LESS language"
HOMEPAGE="https://pypi.python.org/pypi/lesscpy"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="dev-python/ply[${PYTHON_USEDEP}]"

python_test() {
	${PYTHON} lesscpy/test/__main__.py || die "test failed under ${EPYTHON}"
}
