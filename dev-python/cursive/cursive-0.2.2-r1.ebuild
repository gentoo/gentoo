# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7,8} )

inherit distutils-r1

DESCRIPTION="Cursive implements OpenStack-specific validation of digital signatures."
HOMEPAGE="https://github.com/openstack/cursive"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND=">=dev-python/pbr-1.8[${PYTHON_USEDEP}]"
RDEPEND="
	>=dev-python/pbr-1.8[${PYTHON_USEDEP}]
	>=dev-python/cryptography-1.1.0[${PYTHON_USEDEP}]
	>=dev-python/cryptography-1.3.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-serialization-1.10.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-3.16.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-i18n-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-log-1.14.0[${PYTHON_USEDEP}]
	>=dev-python/castellan-0.4.0[${PYTHON_USEDEP}]
"
