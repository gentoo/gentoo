# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/keystonemiddleware/keystonemiddleware-1.5.2.ebuild,v 1.1 2015/06/29 16:47:57 prometheanfire Exp $

EAPI=5
#PYTHON_COMPAT=( python2_7 python3_3 python3_4 )
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A middleware for the OpenStack Keystone API"
HOMEPAGE="https://github.com/openstack/keystonemiddleware"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples test"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
		>=dev-python/pbr-0.8[${PYTHON_USEDEP}]
		<dev-python/pbr-1.0[${PYTHON_USEDEP}]
		test? (
			>=dev-python/hacking-0.10[${PYTHON_USEDEP}]
			<dev-python/hacking-0.11[${PYTHON_USEDEP}]
			>=dev-python/coverage-3.6[${PYTHON_USEDEP}]
			>=dev-python/fixtures-0.3.14[${PYTHON_USEDEP}]
			>=dev-python/mock-1.0[${PYTHON_USEDEP}]
			>=dev-python/pycrypto-2.6[${PYTHON_USEDEP}]
			>=dev-python/oslo-sphinx-2.5.0[${PYTHON_USEDEP}]
			<dev-python/oslo-sphinx-2.6.0[${PYTHON_USEDEP}]
			>=dev-python/oslotest-1.5.1[${PYTHON_USEDEP}]
			<dev-python/oslotest-1.6.0[${PYTHON_USEDEP}]
			>=dev-python/oslo-messaging-1.8.0[${PYTHON_USEDEP}]
			<dev-python/oslo-messaging-1.9.0[${PYTHON_USEDEP}]
			>=dev-python/requests-mock-0.6.0[${PYTHON_USEDEP}]
			>=dev-python/sphinx-1.1.2[${PYTHON_USEDEP}]
			!~dev-python/sphinx-1.2.0[${PYTHON_USEDEP}]
			<dev-python/sphinx-1.3[${PYTHON_USEDEP}]
			>=dev-python/testrepository-0.0.18[${PYTHON_USEDEP}]
			>=dev-python/testresources-0.2.4[${PYTHON_USEDEP}]
			>=dev-python/testtools-0.9.36[${PYTHON_USEDEP}]
			!~dev-python/testtools-1.2.0[${PYTHON_USEDEP}]
			>=dev-python/python-memcached-1.48[$(python_gen_usedep 'python2*')]
		)"

RDEPEND=">=dev-python/Babel-1.3[${PYTHON_USEDEP}]
		>=dev-python/iso8601-0.1.9[${PYTHON_USEDEP}]
		>=dev-python/oslo-config-1.9.0[${PYTHON_USEDEP}]
		<dev-python/oslo-config-1.10.0[${PYTHON_USEDEP}]
		>=dev-python/oslo-context-0.2.0[${PYTHON_USEDEP}]
		<dev-python/oslo-context-0.3.0[${PYTHON_USEDEP}]
		>=dev-python/oslo-i18n-1.5.0[${PYTHON_USEDEP}]
		<dev-python/oslo-i18n-1.6.0[${PYTHON_USEDEP}]
		>=dev-python/oslo-serialization-1.4.0[${PYTHON_USEDEP}]
		<dev-python/oslo-serialization-1.5.0[${PYTHON_USEDEP}]
		>=dev-python/oslo-utils-1.4.0[${PYTHON_USEDEP}]
		<dev-python/oslo-utils-1.5.0[${PYTHON_USEDEP}]
		>=dev-python/pycadf-0.8.0[${PYTHON_USEDEP}]
		<dev-python/pycadf-0.9.0[${PYTHON_USEDEP}]
		>=dev-python/python-keystoneclient-1.1.0[${PYTHON_USEDEP}]
		<dev-python/python-keystoneclient-1.4.0[${PYTHON_USEDEP}]
		>=dev-python/requests-2.2.0[${PYTHON_USEDEP}]
		!~dev-python/requests-2.4.0[${PYTHON_USEDEP}]
		>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
		>=dev-python/webob-1.2.3[${PYTHON_USEDEP}]"

PATCHES=(
"${FILESDIR}/cve-2015-1852-master-keystonemiddleware.patch"
)

python_compile_all() {
	use doc && emake -C doc html
}

python_test() {
	testr init
	testr run || die "testsuite failed under python2.7"
	flake8 ${PN/python-/}/tests || die "run over tests folder by flake8 drew error"
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/build/html/. )
	use examples && local EXAMPLES=( examples/.)
	distutils-r1_python_install_all
}
