# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{5,6} )

inherit distutils-r1 python-utils-r1 systemd user

DESCRIPTION="A GNS3 server to asynchronously manage emulators"
HOMEPAGE="https://www.gns3.com/ https://github.com/GNS3/gns3-server"
SRC_URI="https://github.com/GNS3/gns3-server/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
IUSE="doc systemd"
KEYWORDS="~amd64 ~x86"

CDEPEND="${PYTHON_DEPS}"
RDEPEND="${CDEPEND}
	>=app-emulation/dynamips-0.2.18
	~dev-python/jsonschema-2.6.0[${PYTHON_USEDEP}]
	dev-python/aiohttp[${PYTHON_USEDEP}]
	>=dev-python/aiohttp-cors-0.7.0[${PYTHON_USEDEP}]
	dev-python/aiofiles[${PYTHON_USEDEP}]
	dev-python/async_generator[${PYTHON_USEDEP}]
	dev-python/distro[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/raven[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	>=dev-python/async_timeout-3.0.1[${PYTHON_USEDEP}]
	>=dev-python/distro-1.3.0[${PYTHON_USEDEP}]
	dev-python/typing-extensions[${PYTHON_USEDEP}]
	dev-python/prompt_toolkit[${PYTHON_USEDEP}]
	dev-python/python-zipstream[${PYTHON_USEDEP}]
	net-misc/ubridge
	sys-apps/busybox"

DEPEND="${CDEPEND}
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	dev-python/setuptools[${PYTHON_USEDEP}]"

pkg_setup() {
	enewgroup gns3
	enewuser gns3 -1 -1 "/var/lib/${PN}" gns3
}

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

	use systemd && systemd_dounit "${FILESDIR}"/gns3.service
	newinitd "${FILESDIR}"/gns3-server.initd gns3-server
	newconfd "${FILESDIR}"/gns3-server.confd gns3-server

	keepdir "/var/lib/${PN}" "/var/log/gns3/" "/etc/gns3-server/"

	insinto "/etc/gns3-server/"
	doins "${FILESDIR}"/gns3_server.conf

	insinto "/etc/logrotate.d/"
	newins "${FILESDIR}"/gns3-server.logrotated gns3-server

	fowners -R gns3:gns3 "/var/lib/${PN}" "/var/log/gns3/" "/etc/gns3-server/"
	fperms 0770 "/var/lib/${PN}" "/var/log/gns3/" "/etc/gns3-server/"

	# help2man gns3server > "${FILESDIR}"/gns3server.1
	doman "${FILESDIR}"/gns3server.1
	if use doc; then
		pushd docs >/dev/null || die
		emake man
		doman _build/man/gns3.1
		popd >/dev/null || die
	fi

	dodoc conf/gns3_server.conf
}

pkg_postinst() {
	einfo "\nnet-misc/gns3-server has several optional packages that must be merged manually for additional functionality."
	einfo "\nThe following is a list of packages that can be added:"
	einfo "app-emulation/qemu, app-emulation/virtualbox, app-emulation/libvirt"
	einfo "app-emulation/docker and net-analyzer/wireshark"
	einfo "\nThe following packages are currently unsupported:"
	einfo "iouyap and vpcs"
	einfo "\nIf you get some errors while starting please try to remove old config files in ~/.config/GNS3/*\n"
}
