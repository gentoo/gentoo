# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Components used to interact with the YubiHSM 2"
HOMEPAGE="https://developers.yubico.com/yubihsm-shell/"
SRC_URI="https://developers.yubico.com/${PN}/Releases/${P}.tar.gz"
PATCHES=( "${FILESDIR}"/${P}-remove-hardcoded-compiler-opts.patch )

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test"

DEPEND="
	dev-libs/openssl:=
	net-misc/curl
	dev-libs/libedit
	virtual/libusb:1
	sys-apps/pcsc-lite
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-util/gengetopt
	virtual/pkgconfig
"
