# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils multilib

DESCRIPTION="Clipboard manager with advanced features"
HOMEPAGE="https://github.com/hluk/CopyQ"
SRC_URI="https://github.com/hluk/CopyQ/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="qt4 +qt5 test webkit"

REQUIRED_USE="|| ( qt4 qt5 )"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXfixes
	x11-libs/libXtst
	qt4? (
		dev-qt/qtcore:4=
		dev-qt/qtgui:4=
		dev-qt/qtscript:4=
		webkit? ( dev-qt/qtwebkit:4= )
	)
	qt5? (
		dev-qt/qtcore:5=
		dev-qt/qtgui:5=
		dev-qt/qtnetwork:5=
		dev-qt/qtscript:5=
		dev-qt/qtwidgets:5=
		webkit? ( dev-qt/qtwebkit:5= )
	)
"
DEPEND="${RDEPEND}"

S="${WORKDIR}"/CopyQ-${PV}

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_with qt5)
		$(cmake-utils_use_with webkit)
		$(cmake-utils_use_with test TESTS)
		-DPLUGIN_INSTALL_PREFIX=/usr/$(get_libdir)/${PN}/plugins/
	)
	cmake-utils_src_configure
}
