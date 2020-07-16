# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{6,7} )

inherit distutils-r1

DESCRIPTION="Theme and extension support for Sphinx documentation"
HOMEPAGE="https://docs.openstack.org/openstackdocstheme/latest/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm64 ~ia64 ~ppc64 x86"
IUSE=""

DEPEND=">=dev-python/pbr-2.0.0[${PYTHON_USEDEP}]
	!~dev-python/pbr-2.1.0[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	>=dev-python/dulwich-0.15.0[${PYTHON_USEDEP}]"
