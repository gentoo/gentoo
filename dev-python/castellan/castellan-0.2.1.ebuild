# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 python3_4 )

inherit distutils-r1

DESCRIPTION="Generic Key Manager interface for OpenStack"
HOMEPAGE="https://pypi.python.org/pypi/castellan"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

CDEPEND="
	>=dev-python/pbr-1.6[${PYTHON_USEDEP}]
	<dev-python/pbr-2.0[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	${CDEPEND}"
RDEPEND="
	${CDEPEND}
	>=dev-python/Babel-1.3
	>=dev-python/cryptography-1.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-config-2.3.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-context-0.2.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-log-1.8.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-policy-0.5.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-serialization-1.4.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-2.0.0[${PYTHON_USEDEP}]"
