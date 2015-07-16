# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-mobilephone/heimdall/heimdall-9999.ebuild,v 1.8 2015/07/16 08:59:06 polynomial-c Exp $

EAPI=5

CMAKE_IN_SOURCE_BUILD="true"

inherit autotools eutils cmake-utils udev

if [[ ${PV} != 9999 ]]; then
	SRC_URI="https://github.com/Benjamin-Dobell/Heimdall/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/Heimdall-${PV}"
else
	inherit git-2
	EGIT_REPO_URI="git://github.com/Benjamin-Dobell/Heimdall.git
		https://github.com/Benjamin-Dobell/Heimdall.git"
fi

DESCRIPTION="Tool suite used to flash firmware onto Samsung Galaxy S devices"
HOMEPAGE="http://www.glassechidna.com.au/products/heimdall/"

LICENSE="MIT"
SLOT="0"
IUSE="qt5 static-libs"

# virtual/libusb is not precise enough
RDEPEND=">=dev-libs/libusb-1.0.18:1=[static-libs=]
	qt5? ( dev-qt/qtwidgets:5= )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	if ! use qt5 ; then
		sed '/heimdall-frontend/d' \
			-i CMakeLists.txt || die
	fi
}

src_configure() {
	cmake-utils_src_configure \
		$(cmake-utils_use_use static-libs STATIC_LIBS)
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	# cmake-utils_src_install doesn't work
	dobin "${S}"/bin/${PN}
	use qt5 && dobin "${S}"/bin/${PN}-frontend

	insinto $(get_udevdir)/rules.d
	doins "${S}"/${PN}/60-${PN}.rules
	dodoc Linux/README
}
