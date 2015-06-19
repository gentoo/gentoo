# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/horizon/horizon-2014.1.3.ebuild,v 1.1 2014/10/11 23:34:40 prometheanfire Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A Django-based project aimed at providing a complete OpenStack Dashboard"
HOMEPAGE="https://launchpad.net/horizon"
SRC_URI="http://launchpad.net/${PN}/icehouse/${PV}/+download/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
		>=dev-python/pbr-0.6.0[${PYTHON_USEDEP}]
		<dev-python/pbr-1.0[${PYTHON_USEDEP}]
	test? ( >=dev-python/hacking-0.8.0[${PYTHON_USEDEP}]
			<dev-python/hacking-0.9[${PYTHON_USEDEP}]
			>=dev-python/coverage-3.6[${PYTHON_USEDEP}]
			dev-python/django-nose[${PYTHON_USEDEP}]
			~dev-python/docutils-0.9.1[${PYTHON_USEDEP}]
			>=dev-python/mox-0.5.3[${PYTHON_USEDEP}]
			dev-python/nose[${PYTHON_USEDEP}]
			dev-python/nose-exclude[${PYTHON_USEDEP}]
			>=dev-python/nosehtmloutput-0.0.3[${PYTHON_USEDEP}]
			dev-python/nosexcover[${PYTHON_USEDEP}]
			>=dev-python/openstack-nose-plugin-0.7[${PYTHON_USEDEP}]
			dev-python/oslo-sphinx[${PYTHON_USEDEP}]
			dev-python/selenium[${PYTHON_USEDEP}]
			>=dev-python/sphinx-1.1.2[${PYTHON_USEDEP}]
			<dev-python/sphinx-1.1.9999[${PYTHON_USEDEP}]
			>=dev-python/testtools-0.9.34[${PYTHON_USEDEP}]
	)"
RDEPEND=">=dev-python/django-1.4[${PYTHON_USEDEP}]
		<dev-python/django-1.7[${PYTHON_USEDEP}]
		>=dev-python/django-compressor-1.3[${PYTHON_USEDEP}]
		>=dev-python/django-openstack-auth-1.1.4[${PYTHON_USEDEP}]
		!~dev-python/django-openstack-auth-1.1.6[${PYTHON_USEDEP}]
		>=dev-python/eventlet-0.13.0[${PYTHON_USEDEP}]
		>=dev-python/httplib2-0.7.5[${PYTHON_USEDEP}]
		>=dev-python/iso8601-0.1.9[${PYTHON_USEDEP}]
		>=dev-python/kombu-2.4.8[${PYTHON_USEDEP}]
		>=dev-python/lesscpy-0.9j[${PYTHON_USEDEP}]
		>=dev-python/lockfile-0.8[${PYTHON_USEDEP}]
		>=dev-python/netaddr-0.7.6[${PYTHON_USEDEP}]
		>=dev-python/python-ceilometerclient-1.0.6[${PYTHON_USEDEP}]
		>=dev-python/python-cinderclient-1.0.6[${PYTHON_USEDEP}]
		>=dev-python/python-glanceclient-0.9.0[${PYTHON_USEDEP}]
		>=dev-python/python-heatclient-0.2.3[${PYTHON_USEDEP}]
		>=dev-python/python-keystoneclient-0.7.0[${PYTHON_USEDEP}]
		>=dev-python/python-neutronclient-2.3.4[${PYTHON_USEDEP}]
		<dev-python/python-neutronclient-3[${PYTHON_USEDEP}]
		>=dev-python/python-novaclient-2.17.0[${PYTHON_USEDEP}]
		>=dev-python/python-swiftclient-1.6[${PYTHON_USEDEP}]
		>=dev-python/python-troveclient-1.0.3[${PYTHON_USEDEP}]
		>=dev-python/pytz-2010h[${PYTHON_USEDEP}]
		>=dev-python/six-1.6.0[${PYTHON_USEDEP}]"

PATCHES=(
)

src_test() {
	./run_tests.sh -N --coverage
}
