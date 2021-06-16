# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8,9} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1 optfeature systemd

DESCRIPTION="GNS3 server to asynchronously manage emulators"
HOMEPAGE="https://www.gns3.com/ https://github.com/GNS3/gns3-server"
SRC_URI="https://github.com/GNS3/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=app-emulation/dynamips-0.2.18
	>=dev-python/aiofiles-0.5.0[${PYTHON_USEDEP}]
	>=dev-python/aiohttp-3.6.2[${PYTHON_USEDEP}]
	>=dev-python/aiohttp-cors-0.7.0[${PYTHON_USEDEP}]
	>=dev-python/async_timeout-3.0.1[${PYTHON_USEDEP}]
	>=dev-python/distro-1.3.0[${PYTHON_USEDEP}]
	>=dev-python/jinja-2.11.3[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-3.2.0[${PYTHON_USEDEP}]
	>=dev-python/psutil-5.7.0[${PYTHON_USEDEP}]
	>=dev-python/py-cpuinfo-7.0.0[${PYTHON_USEDEP}]
	>=dev-python/sentry-sdk-0.14.4[${PYTHON_USEDEP}]
	>=net-misc/ubridge-0.9.14
	sys-apps/busybox
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

	# Remove Pre-built busybox binary
	rm gns3server/compute/docker/resources/bin/busybox || die

	# prevent installing tests directory, see:
	# https://github.com/GNS3/gns3-server/pull/1930
	sed -i 's/"tests"/"tests*"/' setup.py || die
}

python_install() {
	distutils-r1_python_install

	systemd_dounit init/gns3.service.systemd

	mkdir -p "${D}$(python_get_sitedir)/gns3server/compute/docker/resources/bin" || die
	ln -s /bin/busybox "${D}$(python_get_sitedir)/gns3server/compute/docker/resources/bin/busybox" || die
}

pkg_postinst() {
	elog "net-misc/gns3-server has several optional packages that must be merged manually for additional functionality."
	elog ""
	optfeature "QEMU Support" "app-emulation/qemu"
	optfeature "Virtualbox Support" "app-emulation/virtualbox"
	optfeature "Docker Support" "app-emulation/docker"
	optfeature "Wireshark Support" "net-analyzer/wireshark"
	elog ""
	elog "The following packages are currently unsupported:"
	elog "iouyap and vpcs"
}
