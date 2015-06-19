# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/tgmochikit/tgmochikit-1.4.2-r1.ebuild,v 1.1 2015/01/10 00:54:45 idella4 Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN="tgMochiKit"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="MochiKit packaged as TurboGears widgets"
HOMEPAGE="http://pypi.python.org/pypi/tgMochiKit"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="|| ( AFL-2.1 MIT )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"
RDEPEND=""

S="${WORKDIR}/${MY_P}"

python_test() {
	nosetests || die "tests failed"
}
