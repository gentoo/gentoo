# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

# https://github.com/racker/rackspace-monitoring-cli/issues/49
RESTRICT="test"

inherit distutils-r1

DESCRIPTION="Command Line Utility for Rackspace Cloud Monitoring (MaaS)"
HOMEPAGE="https://github.com/racker/rackspace-monitoring-cli"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

TEST_DEPENDS="dev-python/pep8[${PYTHON_USEDEP}]"
RDEPEND=">=dev-python/rackspace-monitoring-0.6.5[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
		test? ( ${TEST_DEPENDS} )"

python_test() {
	${EPYTHON} setup.py pep8 || die
}
