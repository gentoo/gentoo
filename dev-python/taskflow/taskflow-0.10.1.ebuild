# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/taskflow/taskflow-0.10.1.ebuild,v 1.1 2015/05/08 19:22:03 prometheanfire Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 python3_3 python3_4 )

inherit distutils-r1

DESCRIPTION="A library to do [jobs, tasks, flows] in a HA manner using different backends"
HOMEPAGE="https://github.com/openstack/taskflow"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
		>=dev-python/pbr-0.8[${PYTHON_USEDEP}]
		<dev-python/pbr-1.0[${PYTHON_USEDEP}]
		test? (
			>=dev-python/hacking-0.10.0[${PYTHON_USEDEP}]
			<dev-python/hacking-0.11[${PYTHON_USEDEP}]
			>=dev-python/oslotest-1.5.1[${PYTHON_USEDEP}]
			>=dev-python/mock-1.0[${PYTHON_USEDEP}]
			>=dev-python/testtools-0.9.36[${PYTHON_USEDEP}]
			!~dev-python/testtools-1.2.0[${PYTHON_USEDEP}]
			>=dev-python/testscenarios-0.4[${PYTHON_USEDEP}]
			>=dev-python/kombu-3.0.7[${PYTHON_USEDEP}]
			>=dev-python/zake-0.1.6[${PYTHON_USEDEP}]
			>=dev-python/kazoo-1.3.1[${PYTHON_USEDEP}]
			>=dev-python/alembic-0.7.2[${PYTHON_USEDEP}]
			dev-python/psycopg[${PYTHON_USEDEP}]
			>=dev-python/sphinx-1.1.2[${PYTHON_USEDEP}]
			!~dev-python/sphinx-1.2.0[${PYTHON_USEDEP}]
			<dev-python/sphinx-1.3[${PYTHON_USEDEP}]
			>=dev-python/oslo-sphinx-2.5.0[${PYTHON_USEDEP}]
		)"
RDEPEND="
	>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
	dev-python/enum34[$(python_gen_usedep 'python2_7' 'python3_3')]
	>=dev-python/networkx-1.8[${PYTHON_USEDEP}]
	>=dev-python/stevedore-1.3.0[${PYTHON_USEDEP}]
	virtual/python-futures[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-2.0.0[${PYTHON_USEDEP}]
	<dev-python/jsonschema-3.0.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-1.4.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-serialization-1.4.0[${PYTHON_USEDEP}]"

python_prepare_all() {
	# this is py2.4-6 only so remove it
	sed -i '/ordereddict/d' requirements*
	# only needed by py2.7 and included by the virtual
	sed -i '/futures/d' requirements*
	distutils-r1_python_prepare_all
}

python_test() {
	testr init
	testr run --parallel || die "failed testsuite under python2.7"
}
