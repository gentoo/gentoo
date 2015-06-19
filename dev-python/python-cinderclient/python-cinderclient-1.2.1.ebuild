# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/python-cinderclient/python-cinderclient-1.2.1.ebuild,v 1.1 2015/05/30 01:32:45 prometheanfire Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A client for the OpenStack Cinder API"
HOMEPAGE="https://launchpad.net/python-cinderclient"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
		>=dev-python/pbr-0.8[${PYTHON_USEDEP}]
		<dev-python/pbr-1.0[${PYTHON_USEDEP}]
		test? ( >=dev-python/hacking-0.8[${PYTHON_USEDEP}]
				<dev-python/hacking-0.9[${PYTHON_USEDEP}]
				>=dev-python/coverage-3.6[${PYTHON_USEDEP}]
				>=dev-python/fixtures-0.3.14[${PYTHON_USEDEP}]
				>=dev-python/mock-1.0[${PYTHON_USEDEP}]
				>=dev-python/oslo-sphinx-2.5.0[${PYTHON_USEDEP}]
				>=dev-python/subunit-0.0.18[${PYTHON_USEDEP}]
				>=dev-python/requests-mock-0.6.0[${PYTHON_USEDEP}]
				>=dev-python/sphinx-1.1.2[${PYTHON_USEDEP}]
				!~dev-python/sphinx-1.2.0[${PYTHON_USEDEP}]
				<dev-python/sphinx-1.3[${PYTHON_USEDEP}]
				>=dev-python/tempest-lib-0.5.0[${PYTHON_USEDEP}]
				>=dev-python/testtools-0.9.36[${PYTHON_USEDEP}]
				>=dev-python/testrepository-0.0.18[${PYTHON_USEDEP}]
		)"
RDEPEND=">=dev-python/prettytable-0.7[${PYTHON_USEDEP}]
		<dev-python/prettytable-0.8[${PYTHON_USEDEP}]
		>=dev-python/python-keystoneclient-1.3.0[${PYTHON_USEDEP}]
		>=dev-python/requests-2.5.2[${PYTHON_USEDEP}]
		>=dev-python/simplejson-2.2.0[${PYTHON_USEDEP}]
		>=dev-python/Babel-1.3[${PYTHON_USEDEP}]
		>=dev-python/six-1.9.0[${PYTHON_USEDEP}]"

python_test() {
	testr init
	testr run --parallel || die "tests failed under python2.7"
	flake8 cinderclient/tests || die "run by flake8 over tests folder yielded error"
}
