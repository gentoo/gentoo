# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="A cross-platform library for USB video devices, built atop libusb"
HOMEPAGE="https://int80k.com/libuvc/"
SRC_URI="https://github.com/ktossell/libuvc/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	media-libs/libjpeg-turbo
	virtual/libusb:1
	virtual/udev"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

DOCS=( changelog.txt README.md )

src_configure() {
	local mycmakeargs=(
		-DCMAKE_BUILD_TARGET=Shared
	)
	cmake_src_configure
}
