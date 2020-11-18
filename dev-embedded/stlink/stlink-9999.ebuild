# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit udev xdg cmake

DESCRIPTION="stm32 discovery line linux programmer"
HOMEPAGE="https://github.com/texane/stlink"
if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/texane/stlink.git"
	inherit git-r3
else
	SRC_URI="https://github.com/texane/stlink/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="BSD"
SLOT="0"

RDEPEND="virtual/libusb:1
	>=dev-libs/glib-2.32.0:2
	x11-libs/gtk+:3"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_configure() {
	local mycmakeargs=(
		-DSTLINK_UDEV_RULES_DIR="$(get_udevdir)"/rules.d
		-DSTLINK_MODPROBED_DIR="${EPREFIX}/etc/modprobe.d"
		-DSTLINK_STATIC_LIB=OFF
		-DLIB_INSTALL_DIR:PATH="$(get_libdir)"
	)

	cmake_src_configure
}
