# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

SDK_PV=1.4.0
SDK_PN=pico-sdk
SDK_P=${SDK_PN}-${SDK_PV}

DESCRIPTION="tool for interacting with rp2040 devices and binaries"
HOMEPAGE="https://github.com/raspberrypi/picotool"
SRC_URI="
	https://github.com/raspberrypi/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/raspberrypi/${SDK_PN}/archive/refs/tags/${SDK_PV}.tar.gz -> ${SDK_P}.tar.gz
"

# picotool (BSD)
# |- clipp (MIT)
# |- pico-sdk (BSD)
LICENSE="BSD MIT"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="virtual/libusb:1"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_configure() {
	local mycmakeargs=(
		-DPICO_SDK_PATH="${WORKDIR}"/${SDK_P}
	)
	cmake_src_configure
}
