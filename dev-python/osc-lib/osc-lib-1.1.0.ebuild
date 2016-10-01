# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 python3_4 python3_5 )

inherit distutils-r1

DESCRIPTION="A package of common support modules for writing OSC plugins."
HOMEPAGE="https://github.com/openstack/osc-lib"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

CDEPEND=">=dev-python/pbr-1.8[${PYTHON_USEDEP}]"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	${CDEPEND}"
RDEPEND="
	${CDEPEND}
	>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
	>=dev-python/Babel-2.3.4[${PYTHON_USEDEP}]
	>=dev-python/cliff-1.15.0[${PYTHON_USEDEP}]
	!~dev-python/cliff-1.16.0[${PYTHON_USEDEP}]
	!~dev-python/cliff-1.17.0[${PYTHON_USEDEP}]
	>=dev-python/os-client-config-1.13.1[${PYTHON_USEDEP}]
	!~dev-python/os-client-config-1.19.0[${PYTHON_USEDEP}]
	!~dev-python/os-client-config-1.19.1[${PYTHON_USEDEP}]
	!~dev-python/os-client-config-1.20.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-i18n-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-3.16.0[${PYTHON_USEDEP}]
	>=dev-python/simplejson-2.2.0[${PYTHON_USEDEP}]
	>=dev-python/stevedore-1.16.0[${PYTHON_USEDEP}]"
