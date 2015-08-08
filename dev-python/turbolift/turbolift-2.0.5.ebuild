# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

# tests are not distributed with the release tarball
RESTRICT="test"

inherit distutils-r1

DESCRIPTION="Openstack Swift sync/backup utility"
HOMEPAGE="https://github.com/cloudnull/turbolift/wiki"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="dev-python/setuptools
	test? (
		>=dev-python/hacking-0.8.0[${PYTHON_USEDEP}]
		<dev-python/hacking-0.9[${PYTHON_USEDEP}]
		>=dev-python/mock-1.0[${PYTHON_USEDEP}]
		dev-python/unittest2[${PYTHON_USEDEP}]
		dev-python/tox[${PYTHON_USEDEP}]
	)"

RDEPEND=">=dev-python/prettytable-0.7.0[${PYTHON_USEDEP}]
	>=dev-python/requests-2.2.0[${PYTHON_USEDEP}]"

python_test() {
	${PYTHON} -m unit discover turbolift/tests || die "failed testsuite"
}
