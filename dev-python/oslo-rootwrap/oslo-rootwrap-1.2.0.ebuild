# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/oslo-rootwrap/oslo-rootwrap-1.2.0.ebuild,v 1.3 2014/08/10 21:14:56 slyfox Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="The Oslo Rootwrap allows fine filtering of shell commands to run as root from OpenStack services"
HOMEPAGE="https://pypi.python.org/pypi/oslo.config"
SRC_URI="mirror://pypi/${PN:0:1}/oslo.rootwrap/oslo.rootwrap-${PV}.tar.gz"
S="${WORKDIR}/oslo.rootwrap-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
		>=dev-python/pbr-0.6[${PYTHON_USEDEP}]
		<dev-python/pbr-1.0[${PYTHON_USEDEP}]
	test? ( >=dev-python/hacking-0.8.0[${PYTHON_USEDEP}]
		<dev-python/hacking-0.9[${PYTHON_USEDEP}]
		>=dev-python/fixtures-0.3.14[${PYTHON_USEDEP}]
		dev-python/subunit[${PYTHON_USEDEP}]
		>=dev-python/testrepository-0.0.17[${PYTHON_USEDEP}]
		>=dev-python/testscenarios-0.4[${PYTHON_USEDEP}]
		>=dev-python/testtools-0.9.32[${PYTHON_USEDEP}]
		>=dev-python/coverage-3.6[${PYTHON_USEDEP}]
		>=dev-python/mock-1.0[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}] )"
RDEPEND=">=dev-python/six-1.4.1[${PYTHON_USEDEP}]"

# This time half the doc files are missing; Do you want them?

python_test() {
	sed -i 's/sbin\/ip/bin\/ip/g' tests/test_rootwrap.py
	nosetests tests/ || die "test failed under ${EPYTHON}"
}
