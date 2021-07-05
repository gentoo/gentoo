# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..9} )

inherit distutils-r1

DESCRIPTION="Theme and extension support for Sphinx documentation"
HOMEPAGE="https://docs.openstack.org/openstackdocstheme/latest"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	>=dev-python/pbr-2.0.0[${PYTHON_USEDEP}]
	!~dev-python/pbr-2.1.0[${PYTHON_USEDEP}]
"
RDEPEND="
	${DEPEND}
	>=dev-python/dulwich-0.15.0[${PYTHON_USEDEP}]
"

distutils_enable_sphinx doc/source \
	">=dev-python/os-api-ref-1.4.0" \
	">=dev-python/reno-3.1.0"
