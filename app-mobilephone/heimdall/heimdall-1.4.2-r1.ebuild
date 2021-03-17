# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake udev

SRC_URI="https://github.com/Benjamin-Dobell/Heimdall/archive/v${PV}.tar.gz -> ${P}.tar.bz2"
S="${WORKDIR}/Heimdall-v${PV}"

DESCRIPTION="Tool suite used to flash firmware onto Samsung devices"
HOMEPAGE="https://glassechidna.com.au/heimdall/"

LICENSE="MIT"
SLOT="0"
IUSE="gui"
KEYWORDS="~amd64"

RDEPEND="
	virtual/libusb:1=
	sys-libs/zlib
	gui? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
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
	dobin "${BUILD_DIR}"/bin/heimdall
	use gui && dobin "${BUILD_DIR}"/bin/heimdall-frontend
	insinto "$(get_udevdir)/rules.d"
	doins heimdall/60-heimdall.rules
	dodoc README.md Linux/README
}
