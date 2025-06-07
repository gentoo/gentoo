# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake udev

DESCRIPTION="Tool suite used to flash firmware onto Samsung devices"
HOMEPAGE="
	https://git.sr.ht/~grimler/Heimdall
	https://glassechidna.com.au/heimdall/
	https://github.com/Benjamin-Dobell/Heimdall
"

if [[ ${PV} != 9999 ]]; then
	SRC_URI="https://git.sr.ht/~grimler/Heimdall/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/Heimdall-v${PV}"

	KEYWORDS="amd64 ~arm64"
else
	inherit git-r3
	EGIT_REPO_URI="https://git.sr.ht/~grimler/Heimdall"
fi

LICENSE="MIT"
SLOT="0"
IUSE="gui"

RDEPEND="
	sys-libs/zlib
	virtual/libusb:1=
	gui? (
		dev-qt/qtbase:6[gui,widgets]
	)"

DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_configure() {
	local mycmakeargs=(
		-DDISABLE_FRONTEND=$(usex !gui)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	udev_dorules heimdall/60-heimdall.rules
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
