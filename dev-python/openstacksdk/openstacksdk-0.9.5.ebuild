# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 python3_4 python3_5 )

inherit distutils-r1

DESCRIPTION="A collection of libraries for building applications to work with OpenStack."
HOMEPAGE="https://github.com/openstack/python-openstacksdk"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE=""

CDEPEND=">=dev-python/pbr-1.8[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	${CDEPEND}"
RDEPEND="${CDEPEND}
	>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
	>=dev-python/stevedore-1.16.0[${PYTHON_USEDEP}]
	>=dev-python/os-client-config-1.13.1[${PYTHON_USEDEP}]
	!~dev-python/os-client-config-1.19.0[${PYTHON_USEDEP}]
	!~dev-python/os-client-config-1.19.1[${PYTHON_USEDEP}]
	!~dev-python/os-client-config-1.20.0[${PYTHON_USEDEP}]
	!~dev-python/os-client-config-1.20.1[${PYTHON_USEDEP}]
	!~dev-python/os-client-config-1.21.0[${PYTHON_USEDEP}]
	>=dev-python/keystoneauth-2.10.0[${PYTHON_USEDEP}]"
