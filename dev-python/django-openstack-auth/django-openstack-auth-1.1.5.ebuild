# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/django-openstack-auth/django-openstack-auth-1.1.5.ebuild,v 1.3 2015/03/08 23:44:57 pacho Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A Django authentication backend for use with the OpenStack Keystone
Identity backend."
HOMEPAGE="http://django_openstack_auth.readthedocs.org/"
SRC_URI="mirror://pypi/${PN:0:1}/django_openstack_auth/django_openstack_auth-${PV}.tar.gz"
S="${WORKDIR}/django_openstack_auth-${PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
		>=dev-python/pbr-0.6.0[${PYTHON_USEDEP}]
		<dev-python/pbr-1.0[${PYTHON_USEDEP}]
		test? (	>=dev-python/hacking-0.8.0[${PYTHON_USEDEP}]
				<dev-python/hacking-0.9[${PYTHON_USEDEP}]
				>=dev-python/Babel-1.3[${PYTHON_USEDEP}]
				>=dev-python/coverage-3.6[${PYTHON_USEDEP}]
				>=dev-python/mox-0.5.3[${PYTHON_USEDEP}]
				>=dev-python/sphinx-1.1.2[${PYTHON_USEDEP}]
				<dev-python/sphinx-1.2[${PYTHON_USEDEP}]
				dev-python/oslo-sphinx[${PYTHON_USEDEP}] )"
RDEPEND=">=dev-python/python-keystoneclient-0.7.0[${PYTHON_USEDEP}]
		>=dev-python/django-1.4[${PYTHON_USEDEP}]
		<dev-python/django-1.7[${PYTHON_USEDEP}]
		>=dev-python/six-1.5.2[${PYTHON_USEDEP}]"

python_test() {
	"${PYTHON}" -m openstack_auth.tests.run_tests || die "Testsuite failed"
}
