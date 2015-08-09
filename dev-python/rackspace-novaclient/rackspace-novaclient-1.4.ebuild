# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A client for the OpenStack Nova API"
HOMEPAGE="https://github.com/rackerlabs/rackspace-novaclient"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=">=dev-python/python-novaclient-2.17.0[${PYTHON_USEDEP}]
		>=dev-python/rackspace-auth-openstack-1.3[${PYTHON_USEDEP}]
		>=dev-python/os-diskconfig-python-novaclient-ext-0.1.2[${PYTHON_USEDEP}]
		!dev-python/rax-backup-schedule-python-novaclient-ext[${PYTHON_USEDEP}]
		>=dev-python/os-networksv2-python-novaclient-ext-0.21[${PYTHON_USEDEP}]
		>=dev-python/os-virtual-interfacesv2-python-novaclient-ext-0.15[${PYTHON_USEDEP}]
		>=dev-python/rax-default-network-flags-python-novaclient-ext-0.2.4[${PYTHON_USEDEP}]"

python_prepare() {
	mkdir "${BUILD_DIR}" || die
}
