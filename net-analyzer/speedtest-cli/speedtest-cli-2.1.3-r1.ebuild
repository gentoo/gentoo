# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} )

inherit distutils-r1

DESCRIPTION="Command line interface for testing internet bandwidth using speedtest.net"
HOMEPAGE="https://github.com/sivel/speedtest-cli"
SRC_URI="https://github.com/sivel/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ppc ppc64 x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

DOCS=( CONTRIBUTING.md README.rst )

python_install_all() {
	doman ${PN}.1
	distutils-r1_python_install_all
}

pkg_postinst() {
	ewarn "net-analyzer/speedtest-cli is often times inaccurate, especially on faster"
	ewarn "links, due to its use of the older HTTP-based API. In order to have more"
	ewarn "accurate measurements, please use net-analyzer/speedtest++ instead."
}
