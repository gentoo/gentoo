# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7,8} )

inherit distutils-r1

DESCRIPTION="A list of standardized resource classes for OpenStack."
HOMEPAGE="https://github.com/openstack/os-resource-classes"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

DEPEND=">=dev-python/pbr-5.0.0[${PYTHON_USEDEP}]"
RDEPEND="
	>=dev-python/pbr-5.0.0[${PYTHON_USEDEP}]
	>=dev-python/six-1.10.0[${PYTHON_USEDEP}]
"
