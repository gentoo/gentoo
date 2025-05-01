# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Components used to interact with the YubiHSM 2"
HOMEPAGE="https://developers.yubico.com/yubihsm-shell/"
SRC_URI="https://developers.yubico.com/${PN}/Releases/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test"

DEPEND="
	dev-libs/openssl:=
	net-misc/curl
	dev-libs/libedit
	sys-apps/pcsc-lite
	virtual/libusb:1
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-util/gengetopt
	sys-apps/help2man
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PN}-2.6.0-pcsc-lite-pkgconfig.patch
	"${FILESDIR}"/${PN}-2.6.0-remove-hardcoded-compiler-opts.patch
)

src_configure() {
	local mycmakeargs=(
		# Allow users to set this, don't force it.
		-DDISABLE_LTO=ON
	)

	cmake_src_configure
}
