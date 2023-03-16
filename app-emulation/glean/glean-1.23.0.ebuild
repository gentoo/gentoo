# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{9,10} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1 pypi

DESCRIPTION="Simple program to write static config from config-drive"
HOMEPAGE="https://opendev.org/opendev/glean"

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
