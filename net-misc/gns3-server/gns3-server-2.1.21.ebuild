# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{5,6} )

inherit distutils-r1

DESCRIPTION="GNS3 server to asynchronously manage emulators"
HOMEPAGE="http://www.gns3.net/"
SRC_URI="https://github.com/GNS3/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-python/aiohttp-2.3.3[${PYTHON_USEDEP}]
	<dev-python/aiohttp-2.4.0[${PYTHON_USEDEP}]
	>=dev-python/aiohttp-cors-0.6.0[${PYTHON_USEDEP}]
	sys-apps/busybox
	<dev-python/async_timeout-3.0.0[${PYTHON_USEDEP}]
	>=app-emulation/dynamips-0.2.18
	>=dev-python/jinja-2.7.3[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-2.6.0[${PYTHON_USEDEP}]
	dev-python/prompt_toolkit[${PYTHON_USEDEP}]
	>=dev-python/psutil-3.0.0[${PYTHON_USEDEP}]
	>=dev-python/python-zipstream-1.1.4[${PYTHON_USEDEP}]
	>=dev-python/raven-5.23.0[${PYTHON_USEDEP}]
	>=net-misc/ubridge-0.9.14
"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

src_prepare() {
	default

	#Remove Pre-built busybox binary
	rm gns3server/compute/docker/resources/bin/busybox || die
	# Package installs 'tests' package which is forbidden
	rm -rf tests || die
}

python_install() {
	distutils-r1_python_install

	mkdir -p "${D}$(python_get_sitedir)/gns3server/compute/docker/resources/bin" || die
	ln -s /bin/busybox "${D}$(python_get_sitedir)/gns3server/compute/docker/resources/bin/busybox" || die
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
