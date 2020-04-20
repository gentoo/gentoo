# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6..8} )

inherit distutils-r1 eutils

DESCRIPTION="GNS3 server to asynchronously manage emulators"
HOMEPAGE="https://www.gns3.com/"
SRC_URI="https://github.com/GNS3/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	~dev-python/aiohttp-3.6.2[${PYTHON_USEDEP}]
	~dev-python/aiohttp-cors-0.7.0[${PYTHON_USEDEP}]
	~dev-python/aiofiles-0.4.0[${PYTHON_USEDEP}]
	>=dev-python/async_generator-1.1.0[${PYTHON_USEDEP}]
	~dev-python/async_timeout-3.0.1[${PYTHON_USEDEP}]
	sys-apps/busybox
	>=dev-python/distro-1.3.0[${PYTHON_USEDEP}]
	>=app-emulation/dynamips-0.2.18
	>=dev-python/jinja-2.7.3[${PYTHON_USEDEP}]
	python_targets_python3_6? ( ~dev-python/jsonschema-2.6.0[${PYTHON_USEDEP}] )
	python_targets_python3_7? ( ~dev-python/jsonschema-2.6.0[${PYTHON_USEDEP}] )
	python_targets_python3_8? ( ~dev-python/jsonschema-3.2.0[${PYTHON_USEDEP}] )
	~dev-python/psutil-5.7.0[${PYTHON_USEDEP}]
	~dev-python/py-cpuinfo-5.0.0[${PYTHON_USEDEP}]
	>=dev-python/raven-5.23.0[${PYTHON_USEDEP}]
	>=net-misc/ubridge-0.9.14
"

src_prepare() {
	default

	sed -i 's/psutil==5.6.6/psutil==5.7.0/' requirements.txt

	#Remove Pre-built busybox binary
	rm gns3server/compute/docker/resources/bin/busybox || die
	# Package installs 'tests' package which is forbidden
	rm -r tests || die
}

python_install() {
	distutils-r1_python_install

	mkdir -p "${D}$(python_get_sitedir)/gns3server/compute/docker/resources/bin" || die
	ln -s /bin/busybox "${D}$(python_get_sitedir)/gns3server/compute/docker/resources/bin/busybox" || die
}

pkg_postinst() {
	optfeature "Virtualization KVM Support" app-emulation/qemu app-emulation/virtualbox
	optfeature "Docker Support" app-emulation/docker
	optfeature "Packet Sniffer" net-analyzer/wireshark
	elog "The following packages are currently unsupported:"
	elog "iouyap and vpcs"
}
