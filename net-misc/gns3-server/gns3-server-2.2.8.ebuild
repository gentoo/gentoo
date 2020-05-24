# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7,8} )

inherit distutils-r1

DESCRIPTION="GNS3 server to asynchronously manage emulators"
HOMEPAGE="https://www.gns3.net/"
SRC_URI="https://github.com/GNS3/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=app-emulation/dynamips-0.2.18
	>=dev-python/aiofiles-0.4.0[${PYTHON_USEDEP}]
	>=dev-python/aiohttp-3.6.2[${PYTHON_USEDEP}]
	>=dev-python/aiohttp-cors-0.7.0-r1[${PYTHON_USEDEP}]
	>=dev-python/async_generator-1.10[${PYTHON_USEDEP}]
	>=dev-python/async_timeout-3.0.1[${PYTHON_USEDEP}]
	>=dev-python/jinja-2.7.3[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '>=dev-python/jsonschema-3.2.0:=[${PYTHON_USEDEP}]' 'python3_8')
	$(python_gen_cond_dep '<=dev-python/jsonschema-2.6.0:=[${PYTHON_USEDEP}]' 'python3_7')
	>=dev-python/psutil-5.7.0[${PYTHON_USEDEP}]
	dev-python/py-cpuinfo[${PYTHON_USEDEP}]
	>=dev-python/sentry-sdk-0.14.4[${PYTHON_USEDEP}]
	>=dev-python/yarl-1.4.2[${PYTHON_USEDEP}]
	>=net-misc/ubridge-0.9.14
"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

PATCHES=( "${FILESDIR}/gns3-server-rmraven.patch" )

src_prepare() {
	default

	# newer psutils is fine
	sed -i -e '/psutil==5.6.6/d' requirements.txt || die "fixing requirements failed"

	# We don't support <py3.7
	sed -i -e '/aiocontextvars==0.2.2/d' requirements.txt || die "fixing requirements failed"
	sed -i -e '/yarl==1.3.0/d' requirements.txt || die "fixing requirements failed 2"

	#Remove Pre-built busybox binary
	rm gns3server/compute/docker/resources/bin/busybox || die

	# Package installs 'tests' package which is forbidden
	rm -rf tests || die
	eapply_user
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
