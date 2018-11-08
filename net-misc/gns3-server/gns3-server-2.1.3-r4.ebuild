# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_{4,5,6} )

inherit distutils-r1 eutils

DESCRIPTION="GNS3 server to asynchronously manage emulators"
HOMEPAGE="http://www.gns3.net/"
SRC_URI="https://github.com/GNS3/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="test"

RDEPEND="
	>=app-emulation/dynamips-0.2.12
	>=dev-python/aiohttp-2.2.0[${PYTHON_USEDEP}]
	<dev-python/aiohttp-cors-0.6[${PYTHON_USEDEP}]
	>=dev-python/aiohttp-cors-0.5.3[${PYTHON_USEDEP}]
	>=dev-python/docker-py-1.4.0[${PYTHON_USEDEP}]
	>=dev-python/netifaces-0.8-r2[${PYTHON_USEDEP}]
	>=dev-python/jinja-2.7.3[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-2.4.0[${PYTHON_USEDEP}]
	>=dev-python/libcloud-0.14.1[${PYTHON_USEDEP}]
	>=dev-python/raven-5.23.0[${PYTHON_USEDEP}]
	dev-python/prompt_toolkit[${PYTHON_USEDEP}]
	>=dev-python/psutil-3.0.0[${PYTHON_USEDEP}]
	>=dev-python/pyzmq-14.3.1[${PYTHON_USEDEP}]
	>=dev-python/python-zipstream-1.1.4[${PYTHON_USEDEP}]
	>=net-misc/ubridge-0.9.14
	>=www-servers/tornado-3.1.1[${PYTHON_USEDEP}]
	virtual/python-typing[${PYTHON_USEDEP}]
	>=dev-python/yarl-0.11[${PYTHON_USEDEP}]
"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

# https://github.com/GNS3/gns3-server/pull/1368
PATCHES=( "${FILESDIR}/${P}-typing.patch" )

src_prepare() {
	default

	# Package installs 'tests' package which is forbidden
	rm -rf tests || die
}

pkg_postinst() {
	elog "net-misc/gns3-server has several optional packages that must be merged manually for additional functionality."
	elog ""
	elog "The following is a list of packages that can be added:"
	elog "app-emulation/qemu, app-emulation/virtualbox"
	elog "app-emulation/docker and net-analyzer/wireshark"
	elog ""
	elog "The following packages are currently unsupported:"
	elog "iouyap and vpcs"
}
