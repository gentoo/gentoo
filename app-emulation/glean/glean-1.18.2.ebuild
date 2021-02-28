# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_7 python3_8 python3_9 )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="Simple program to write static config from config-drive"
HOMEPAGE="https://opendev.org/opendev/glean"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/pbr[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

src_install() {
	distutils-r1_src_install
	newinitd "${FILESDIR}/${PN}.initd" ${PN}
}
