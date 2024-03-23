# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Command line interface for testing internet bandwidth using speedtest.net"
HOMEPAGE="https://github.com/sivel/speedtest-cli"
SRC_URI="https://github.com/sivel/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc ppc64 x86"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${PN}-2.1.3-json-serverlist.patch" )

python_install_all() {
	doman ${PN}.1
	distutils-r1_python_install_all
}
