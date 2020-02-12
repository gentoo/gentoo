# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake gnome2-utils

MY_P=CopyQ-${PV}

DESCRIPTION="Clipboard manager with advanced features"
HOMEPAGE="https://github.com/hluk/CopyQ"
SRC_URI="https://github.com/hluk/CopyQ/archive/v${PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test webkit"

RESTRICT="!test? ( test )"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtscript:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	x11-libs/libX11
	x11-libs/libXfixes
	x11-libs/libXtst
	webkit? ( dev-qt/qtwebkit:5 )
"
DEPEND="${RDEPEND}
	dev-qt/linguist-tools:5
	test? ( dev-qt/qttest:5 )
"
S=${WORKDIR}/$MY_P

src_configure() {
	# CMakeLists.txt concatenates INSTALL_PREFIX with INSTALL_MANDIR leading to /usr/usr
	local mycmakeargs=(
		-DPLUGIN_INSTALL_PREFIX="/usr/$(get_libdir)/${PN}/plugins"
		-DWITH_QT5=ON
		-DWITH_TESTS=$(usex test)
		-DWITH_WEBKIT=$(usex webkit)
		-DCMAKE_INSTALL_MANDIR="share/man"
	)
	cmake_src_configure
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
