# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

SDK_PV=2.0.0
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
KEYWORDS="~amd64"

RDEPEND="virtual/libusb:1"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${PN}-1.1.2-musl.patch )

# Binary that runs on-chip.
QA_PREBUILT="usr/share/picotool/xip_ram_perms.elf"

src_prepare() {
	mv "${WORKDIR}"/${SDK_P} "${S}"/pico-sdk || die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DPICO_SDK_PATH="${S}"/pico-sdk
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	dostrip -x /usr/share/picotool/xip_ram_perms.elf
}
