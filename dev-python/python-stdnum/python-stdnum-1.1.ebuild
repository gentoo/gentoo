# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/python-stdnum/python-stdnum-1.1.ebuild,v 1.1 2015/06/09 21:59:10 cedk Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

DESCRIPTION="A module to handle standardized numbers and codes"
HOMEPAGE="http://arthurdejong.org/python-stdnum/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="vies test"

RDEPEND="vies? ( dev-python/suds )"
DEPEND="${DEPEND}
	dev-python/setuptools
	test? ( dev-python/nose )"

DOCS=( ChangeLog NEWS README )

python_test() {
	nosetests || die
}
