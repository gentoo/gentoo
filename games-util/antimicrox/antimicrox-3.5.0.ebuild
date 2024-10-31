# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit udev xdg cmake

DESCRIPTION="Graphical program used to map keyboard buttons and mouse controls to a gamepad"
HOMEPAGE="https://github.com/AntiMicroX/antimicrox/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/AntiMicroX/${PN}.git"
else
	SRC_URI="https://github.com/AntiMicroX/${PN}/archive/${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"
IUSE="doc"
# Tests fail to build
# https://github.com/AntiMicroX/antimicrox/issues/530
RESTRICT="test"

RDEPEND="
	dev-qt/qtbase:6[concurrent,gui,network,widgets]
	media-libs/libsdl2[X,joystick]
	virtual/udev
	x11-libs/libX11
	x11-libs/libXi
	x11-libs/libXtst
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	dev-qt/qttools:6[linguist]
	kde-frameworks/extra-cmake-modules
	doc? (
		app-text/doxygen[dot]
	)
"

PATCHES=( "${FILESDIR}/${PN}-man_gz.patch" )

DOCS=( CHANGELOG.md README.md )

src_configure() {
	local -a mycmakeargs=(
		-DAPPDATA=OFF
		-DCHECK_FOR_UPDATES=OFF
		-DINSTALL_UINPUT_UDEV_RULES=OFF  # Install in src_install
		-DUSE_QT6_BY_DEFAULT=ON
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
	udev_dorules "${S}/other/60-${PN}-uinput.rules"

	use doc && dodoc -r "${S}/docs"/{html,latex}

	rm -r "${ED}/usr/share/doc/${PN}" || die
}

pkg_postinst() {
	udev_reload
	xdg_pkg_postinst
}

pkg_postrm() {
	udev_reload
	xdg_pkg_postrm
}
