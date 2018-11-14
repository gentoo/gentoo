# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils multilib

DESCRIPTION="Clipboard manager with advanced features"
HOMEPAGE="https://github.com/hluk/CopyQ"
SRC_URI="https://github.com/hluk/CopyQ/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test webkit"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtscript:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	x11-libs/libX11
	x11-libs/libXfixes
	x11-libs/libXtst
	webkit? ( dev-qt/qtwebkit:5 )
"
DEPEND="${RDEPEND}
	dev-qt/linguist-tools:5
	test? ( dev-qt/qttest:5 )
"

S=${WORKDIR}/CopyQ-${PV}

src_configure() {
	local mycmakeargs=(
		-DPLUGIN_INSTALL_PREFIX="/usr/$(get_libdir)/${PN}/plugins"
		-DWITH_QT5=ON
		-DWITH_TESTS=$(usex test)
		-DWITH_WEBKIT=$(usex webkit)
	)
	cmake-utils_src_configure
}
