# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/rackspace-monitoring/rackspace-monitoring-0.6.5.ebuild,v 1.1 2015/01/14 01:52:05 prometheanfire Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Client library for Rackspace Cloud Monitoring"
HOMEPAGE="https://github.com/racker/rackspace-monitoring"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

TEST_DEPENDS="dev-python/pep8[${PYTHON_USEDEP}]"
RDEPEND="
	>=dev-python/libcloud-0.14.0[${PYTHON_USEDEP}]
	<dev-python/libcloud-0.16.0[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		${TEST_DEPENDS}
		${RDEPEND}
	)
"

python_test() {
	${EPYTHON} setup.py test || die
}
