# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake udev

if [[ ${PV} != 9999 ]]; then
	SRC_URI="https://git.sr.ht/~grimler/Heimdall/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~arm64"
	S="${WORKDIR}/Heimdall-v${PV}"
else
	inherit git-r3
	EGIT_REPO_URI="https://git.sr.ht/~grimler/Heimdall"
fi

DESCRIPTION="Tool suite used to flash firmware onto Samsung devices"
HOMEPAGE="https://git.sr.ht/~grimler/Heimdall https://glassechidna.com.au/heimdall/ https://github.com/Benjamin-Dobell/Heimdall"

LICENSE="MIT"
SLOT="0"
IUSE="gui"

RDEPEND="
	sys-libs/zlib
	virtual/libusb:1=
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
	udev_dorules heimdall/60-heimdall.rules
	dodoc README.md Linux/README
}
