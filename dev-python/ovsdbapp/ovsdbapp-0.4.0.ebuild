# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_4 python3_5 )
inherit distutils-r1

DESCRIPTION="A library for creating OVSDB applications"
HOMEPAGE="http://bugs.launchpad.net/ovsdbapp"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE=""

CDEPEND=">=dev-python/pbr-2.0.0[${PYTHON_USEDEP}]
	!~dev-python/pbr-2.1.0"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
		${CDEPEND}"
RDEPEND="${CDEPEND}
	>=dev-python/fixtures-3.0.0[${PYTHON_USEDEP}]
	>=dev-python/ovs-2.7.0[${PYTHON_USEDEP}]"
