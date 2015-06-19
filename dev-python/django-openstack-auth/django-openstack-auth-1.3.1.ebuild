# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/django-openstack-auth/django-openstack-auth-1.3.1.ebuild,v 1.1 2015/06/13 08:39:02 idella4 Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 python3_3 )

inherit distutils-r1

DESCRIPTION="Django authentication backend for use with OpenStack Keystone Identity backend"
HOMEPAGE="http://django_openstack_auth.readthedocs.org/"
SRC_URI="mirror://pypi/${PN:0:1}/django_openstack_auth/django_openstack_auth-${PV}.tar.gz"
S="${WORKDIR}/django_openstack_auth-${PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"

CDEPEND=">=dev-python/sphinx-1.1.2[${PYTHON_USEDEP}]
		!~dev-python/sphinx-1.2.0[${PYTHON_USEDEP}]
		>=dev-python/oslo-sphinx-2.5.0[${PYTHON_USEDEP}]
		<dev-python/oslo-sphinx-2.6.0[${PYTHON_USEDEP}]
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
		>=dev-python/pbr-0.11[${PYTHON_USEDEP}]
		<dev-python/pbr-2.0[${PYTHON_USEDEP}]
		test? (
			>=dev-python/hacking-0.10.0[${PYTHON_USEDEP}]
			<dev-python/hacking-0.11[${PYTHON_USEDEP}]
			>=dev-python/Babel-1.3[${PYTHON_USEDEP}]
			>=dev-python/coverage-3.6[${PYTHON_USEDEP}]
			>=dev-python/mock-1.0[${PYTHON_USEDEP}]
			>=dev-python/mox3-0.7.0[${PYTHON_USEDEP}]
			>=dev-python/testscenarios-0.4[${PYTHON_USEDEP}] )
			${CDEPEND}
		doc? ( ${CDEPEND} )"
RDEPEND="
	>=dev-python/django-1.4.2[${PYTHON_USEDEP}]
	<dev-python/django-1.8[${PYTHON_USEDEP}]
	>=dev-python/oslo-config-1.11.0[${PYTHON_USEDEP}]
	<dev-python/oslo-config-1.10.0[${PYTHON_USEDEP}]
	>=dev-python/python-keystoneclient-1.3.0[${PYTHON_USEDEP}]
	>=dev-python/six-1.9.0[${PYTHON_USEDEP}]"

python_prepare_all() {
	# Avoid warning in doc build due to missed file
	if use doc; then
		mkdir doc/source/_static || die
	fi
	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc; then
		sphinx-build -b html -c doc/source/ doc/source/ doc/source/html || die
	fi
}

python_test() {
	"${PYTHON}" -m openstack_auth.tests.run_tests || die "Testsuite failed"
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/source/html/. )
	distutils-r1_python_install_all
}
