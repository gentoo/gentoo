# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..10} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1 optfeature systemd

DESCRIPTION="GNS3 server to asynchronously manage emulators"
HOMEPAGE="https://www.gns3.com/ https://github.com/GNS3/gns3-server"
SRC_URI="https://github.com/GNS3/gns3-server/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	acct-group/gns3
	acct-user/gns3
	app-emulation/dynamips
	>=dev-python/aiofiles-0.7.0[${PYTHON_USEDEP}]
	>=dev-python/aiohttp-3.8.1[${PYTHON_USEDEP}]
	>=dev-python/aiohttp-cors-0.7.0[${PYTHON_USEDEP}]
	>=dev-python/async-timeout-4.0.2[${PYTHON_USEDEP}]
	>=dev-python/distro-1.7.0[${PYTHON_USEDEP}]
	>=dev-python/jinja-3.0.3[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-3.2.0[${PYTHON_USEDEP}]
	>=dev-python/psutil-5.9.1[${PYTHON_USEDEP}]
	>=dev-python/py-cpuinfo-8.0.0[${PYTHON_USEDEP}]
	>=dev-python/sentry-sdk-1.9.5[${PYTHON_USEDEP}]
	net-misc/ubridge
	sys-apps/busybox
"
BDEPEND="
	test? (
		dev-python/pytest-aiohttp[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-2.2.33.1-openrc-posix-complaint.patch"
	)

distutils_enable_tests pytest

src_prepare() {
	default

	# newer python packages are fine
	sed -i -e 's/[<>=].*//' requirements.txt || die

	# Remove Pre-built busybox binary
	rm gns3server/compute/docker/resources/bin/busybox || die
}

python_install() {
	distutils-r1_python_install

	systemd_dounit init/gns3.service.systemd
	newinitd init/gns3.service.openrc gns3server

	mkdir -p "${D}$(python_get_sitedir)/gns3server/compute/docker/resources/bin" || die
	ln -s /bin/busybox "${D}$(python_get_sitedir)/gns3server/compute/docker/resources/bin/busybox" || die
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
