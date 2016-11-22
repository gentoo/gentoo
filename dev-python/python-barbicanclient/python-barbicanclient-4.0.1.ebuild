# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 python3_4 python3_5 )

inherit distutils-r1

DESCRIPTION="Client library for Barbican API."
HOMEPAGE="https://github.com/openstack/barbican"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE=""

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/pbr-1.6.0[${PYTHON_USEDEP}]
"
RDEPEND="
	>=dev-python/requests-2.10.0[${PYTHON_USEDEP}]
	>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
	>=dev-python/python-keystoneclient-2.0.0[${PYTHON_USEDEP}]
	!~dev-python/python-keystoneclient-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/cliff-1.15.0[${PYTHON_USEDEP}]
	!~dev-python/cliff-1.16.0[${PYTHON_USEDEP}]
	!~dev-python/cliff-1.17.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-i18n-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-serialization-1.10.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-3.5.0[${PYTHON_USEDEP}]
"
