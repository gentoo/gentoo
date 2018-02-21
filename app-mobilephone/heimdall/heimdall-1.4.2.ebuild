# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils udev

if [[ ${PV} != 9999 ]]; then
	SRC_URI="https://github.com/Benjamin-Dobell/Heimdall/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/Heimdall-${PV}"
else
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Benjamin-Dobell/Heimdall.git"
fi

DESCRIPTION="Tool suite used to flash firmware onto Samsung Galaxy S devices"
HOMEPAGE="https://glassechidna.com.au/heimdall/"

LICENSE="MIT"
SLOT="0"
IUSE="qt5"

# virtual/libusb is not precise enough
RDEPEND="
	>=dev-libs/libusb-1.0.18:1=
	qt5? (
		dev-qt/qtcore:5=
		dev-qt/qtgui:5=
		dev-qt/qtwidgets:5=
	)
	sys-libs/zlib
"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	local mycmakeargs=(
		-DDISABLE_FRONTEND="$(usex !qt5)"
	)
	cmake-utils_src_configure
}

src_install() {
	dobin "${BUILD_DIR}"/bin/heimdall
	use qt5 && dobin "${BUILD_DIR}"/bin/heimdall-frontend

	insinto "$(get_udevdir)/rules.d"
	doins heimdall/60-heimdall.rules

	dodoc README.md Linux/README
}
