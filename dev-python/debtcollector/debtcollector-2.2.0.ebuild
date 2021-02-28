# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
inherit distutils-r1

DESCRIPTION="Python deprecation patterns and strategies that collect technical debt"
HOMEPAGE="https://www.openstack.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86"

DEPEND=">=dev-python/pbr-2.0.0[${PYTHON_USEDEP}]
	!~dev-python/pbr-2.1.0[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	>=dev-python/six-1.10.0[${PYTHON_USEDEP}]
	>=dev-python/wrapt-1.7.0[${PYTHON_USEDEP}]"
