# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{5,6,7} )

inherit distutils-r1

DESCRIPTION="A module to handle standardized numbers and codes"
HOMEPAGE="https://arthurdejong.org/python-stdnum/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="vies test"
RESTRICT="!test? ( test )"

RDEPEND="vies? ( || ( dev-python/zeep dev-python/suds ) )"
DEPEND="${DEPEND}
	dev-python/setuptools
	test? ( dev-python/nose )"

DOCS=( ChangeLog NEWS README )

python_test() {
	nosetests -v || die
}
