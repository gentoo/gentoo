# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit udev xdg cmake

DESCRIPTION="Graphical program used to map keyboard buttons and mouse controls to a gamepad"
HOMEPAGE="https://github.com/AntiMicroX/antimicrox/"
SRC_URI="https://github.com/AntiMicroX/${PN}/archive/${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"
# Tests fail to build
# https://github.com/AntiMicroX/antimicrox/issues/530
RESTRICT="test"

RDEPEND="
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	media-libs/libsdl2[X,joystick]
	virtual/udev
	x11-libs/libX11
	x11-libs/libXi
	x11-libs/libXtst
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-qt/linguist-tools:5
	kde-frameworks/extra-cmake-modules
	doc? ( app-doc/doxygen[dot] )
"

PATCHES=( "${FILESDIR}"/${PN}-man_gz.patch )
DOCS=( CHANGELOG.md README.md )

src_configure() {
	local mycmakeargs=(
		-DAPPDATA=OFF
		-DCHECK_FOR_UPDATES=OFF
		-DINSTALL_UINPUT_UDEV_RULES=OFF  # Install in src_install
		-DWITH_TESTS=OFF
		-DWITH_UINPUT=ON
		-DWITH_X11=ON
		-DWITH_XTEST=ON
		-DBUILD_DOCS=$(usex doc ON OFF)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	rm -r "${ED}"/usr/share/doc/${PN} || die

	udev_dorules "${S}"/other/60-${PN}-uinput.rules

	use doc && dodoc -r "${S}"/docs/{html,latex}
}

pkg_postinst() {
	udev_reload
	xdg_pkg_postinst
}

pkg_postrm() {
	udev_reload
	xdg_pkg_postrm
}
