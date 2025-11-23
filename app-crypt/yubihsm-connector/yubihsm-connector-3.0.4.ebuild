# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module systemd udev

DESCRIPTION="Server to expose YubiHSM 2 to network"
HOMEPAGE="https://developers.yubico.com/yubihsm-connector/"
SRC_URI="
	https://developers.yubico.com/${PN}/Releases/${P}.tar.gz
	https://dev.gentoo.org/~zx2c4/distfiles/${P}-vendor.tar.xz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
RESTRICT="test"

DEPEND=""
RDEPEND="
	virtual/libusb:1
	virtual/udev
	acct-user/yubihsm-connector
	acct-group/yubihsm-connector
"
BDEPEND=""

src_compile() {
	ego generate
	ego build ${GOFLAGS}
}

src_install() {
	dobin yubihsm-connector
	systemd_dounit deb/yubihsm-connector.service
	udev_dorules deb/70-yubihsm-connector.rules
	insinto /etc
	doins deb/yubihsm-connector.yaml
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
