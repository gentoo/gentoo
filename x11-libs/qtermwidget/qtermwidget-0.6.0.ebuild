# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit cmake-utils

DESCRIPTION="Qt terminal emulator widget"
HOMEPAGE="https://github.com/qterminal/qtermwidget"
SRC_URI="https://github.com/qterminal/${PN}/releases/download/${PV}/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm ~x86"
IUSE="debug qt4 qt5"
REQUIRED_USE="^^ ( qt4 qt5 )"

DEPEND="
	qt4? ( dev-qt/designer:4
		dev-qt/qtcore:4
		dev-qt/qtgui:4 )
	qt5? ( dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5 )"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_use qt5)
		$(cmake-utils_use_build qt4 DESIGNER_PLUGIN)
	)
	cmake-utils_src_configure
}
