# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_4} )

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
