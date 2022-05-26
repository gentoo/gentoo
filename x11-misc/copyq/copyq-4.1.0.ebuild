# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake xdg-utils

DESCRIPTION="Clipboard manager with advanced features"
HOMEPAGE="https://github.com/hluk/CopyQ"
SRC_URI="https://github.com/hluk/CopyQ/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/wayland
	dev-qt/qtcore:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtsvg:5
	dev-qt/qtwayland:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	kde-frameworks/knotifications:5
	x11-libs/libX11
	x11-libs/libXtst
"
DEPEND="${RDEPEND}
	test? ( dev-qt/qttest:5 )"
BDEPEND="
	dev-qt/linguist-tools:5
"

S="${WORKDIR}/CopyQ-${PV}"

PATCHES=( "${FILESDIR}/${P}-bash-completion.patch" )

src_configure() {
	local mycmakeargs=(
		-DCMAKE_BUILD_TYPE=Release
		-DPLUGIN_INSTALL_PREFIX="/usr/$(get_libdir)/${PN}/plugins"
		-DWITH_TESTS=$(usex test)
	)
	cmake_src_configure
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
