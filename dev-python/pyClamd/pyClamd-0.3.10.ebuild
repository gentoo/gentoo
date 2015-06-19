# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyClamd/pyClamd-0.3.10.ebuild,v 1.2 2014/12/04 17:26:26 xarthisius Exp $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

DESCRIPTION="python interface to Clamd (Clamav daemon)"
HOMEPAGE="http://xael.org/norman/python/pyclamd/"
SRC_URI="mirror://pypi/p/${PN}/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -e 's:/etc/clamav/clamd.conf:/etc/clamd.conf:' \
		-i pyclamd/pyclamd.py || die
}
