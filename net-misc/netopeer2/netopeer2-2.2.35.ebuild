# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Server for implementing NETCONF configuration management"
HOMEPAGE="https://github.com/CESNET/netopeer2"
SRC_URI="https://github.com/CESNET/netopeer2/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	app-misc/c_rehash
	dev-libs/openssl:=
	net-misc/curl:=
	>=net-misc/sysrepo-3.3.10
	>=net-libs/libnetconf2-3.5.4
	net-libs/libssh:=
	>=net-libs/libyang-3.7.8"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_configure() {
	local mycmakeargs=(
		-DSYSREPO_SETUP=OFF
		-DENABLE_TESTS=OFF
		-DENABLE_VALGRIND_TESTS=OFF
		-DCMAKE_INSTALL_SYSCONFDIR="${EPREFIX}/etc"
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	insinto /etc/netopeer2
	doins -r scripts/.
}

pkg_postinst() {
	elog "In order to do initial server setup please"
	elog "run setup scripts located in /etc/netopeer2"
}
