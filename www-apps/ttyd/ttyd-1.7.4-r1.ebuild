# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake systemd

MY_PV="$(ver_rs 3 '-')"

DESCRIPTION="ttyd, a simple command-line tool for sharing terminal over the web"
HOMEPAGE="https://github.com/tsl0922/ttyd"

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/tsl0922/ttyd.git"
	inherit git-r3
else
	SRC_URI="https://github.com/tsl0922/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64"
fi

S="${WORKDIR}/${PN}-${MY_PV}"
LICENSE="MIT"
SLOT="0"
IUSE="mbedtls"
DEPEND="
	dev-libs/json-c:=
	dev-libs/libuv:=
	net-libs/libwebsockets:=[libuv,mbedtls=,ssl]
	sys-libs/zlib:=
	!mbedtls? ( dev-libs/openssl:= )
"
RDEPEND="${DEPEND}"

src_install() {
	cmake_src_install

	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
	systemd_dounit "${FILESDIR}"/${PN}.service
}
