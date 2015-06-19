# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/testresources/testresources-0.2.7.ebuild,v 1.6 2015/04/08 08:05:01 mgorny Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Testresources, a pyunit extension for managing expensive test resources"
HOMEPAGE="https://launchpad.net/testresources"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="test"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
		test? ( dev-python/nose[${PYTHON_USEDEP}]
				dev-python/testtools[${PYTHON_USEDEP}]
				dev-python/fixtures[${PYTHON_USEDEP}] )"
RDEPEND=""

python_test() {
	nosetests || die "Tests failed under ${EPYTHON}"
}
