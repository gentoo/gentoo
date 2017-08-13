# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils udev

DESCRIPTION="Cross platform personalization tool for the Nitrokey"
HOMEPAGE="https://github.com/Nitrokey/nitrokey-app"
SRC_URI="
	https://github.com/Nitrokey/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/Nitrokey/libnitrokey/archive/06c0deb7935a9390a67bc02d6c323e64c785a026.tar.gz -> ${P}-libnitrokey.tar.gz
	https://github.com/tplgy/cppcodec/archive/61d9b044d6644293f99fb87dfadc15dcab951bd9.tar.gz -> ${P}-cppcodec.tar.gz
"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	dev-libs/hidapi
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/0001-cmake-CXX-not-found.patch"
)

mycmakeargs=( -DHAVE_LIBAPPINDICATOR=NO )

src_unpack() {
	unpack ${A}
	rmdir "${S}/libnitrokey" "${S}/3rdparty/cppcodec" || die "directory libnitrokey not empty"
	mv "${WORKDIR}"/libnitrokey-* "${S}/libnitrokey" || die "Unable to move libnitrokey directory"
	mv "${WORKDIR}"/cppcodec-* "${S}/3rdparty/cppcodec" || die "Unable to move cppcodec directory"
}

src_prepare() {
	cmake-utils_src_prepare
	sed -i "s:DESTINATION lib/udev/rules.d:DESTINATION $(get_udevdir)/rules.d:" \
		CMakeLists.txt || die
}

pkg_postinst() {
	udev_reload
}
