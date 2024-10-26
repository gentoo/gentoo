# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..12} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 optfeature systemd

DESCRIPTION="GNS3 server to asynchronously manage emulators"
HOMEPAGE="https://www.gns3.com https://github.com/GNS3/gns3-server"
SRC_URI="https://github.com/GNS3/gns3-server/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	acct-group/gns3
	acct-user/gns3
	app-emulation/dynamips
	>=dev-python/aiofiles-24.1.0[${PYTHON_USEDEP}]
	>=dev-python/aiohttp-3.10.3[${PYTHON_USEDEP}]
	>=dev-python/aiohttp-cors-0.7.0[${PYTHON_USEDEP}]
	>=dev-python/async-timeout-4.0.3[${PYTHON_USEDEP}]
	>=dev-python/distro-1.9.0[${PYTHON_USEDEP}]
	>=dev-python/jinja-3.1.4[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-4.23.0[${PYTHON_USEDEP}]
	>=dev-python/platformdirs-2.4.0[${PYTHON_USEDEP}]
	>=dev-python/psutil-6.0.0[${PYTHON_USEDEP}]
	>=dev-python/py-cpuinfo-9.0.0[${PYTHON_USEDEP}]
	>=dev-python/truststore-0.9.1[${PYTHON_USEDEP}]
	net-misc/ubridge
	sys-apps/busybox[static]
"
BDEPEND="
	test? (
		dev-python/pytest-aiohttp[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_prepare() {
	default

	# newer python packages are fine
	sed -i -e 's/[<>=].*//' requirements.txt || die
}

python_install() {
	distutils-r1_python_install

	systemd_dounit init/gns3.service.systemd
	newinitd init/gns3.service.openrc gns3server
}

pkg_postinst() {
	elog "net-misc/gns3-server has several optional packages that must be merged manually for additional functionality."
	elog ""
	optfeature "QEMU Support" "app-emulation/qemu"
	optfeature "Virtualbox Support" "app-emulation/virtualbox"
	optfeature "Docker Support" "app-containers/docker"
	optfeature "Wireshark Support" "net-analyzer/wireshark"
	elog ""
	elog "The following packages are currently unsupported:"
	elog "iouyap and vpcs"
}
