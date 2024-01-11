# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="fcitx5-skk"

inherit xdg cmake

DESCRIPTION="Japanese SKK input engine for Fcitx5"
HOMEPAGE="https://fcitx-im.org/ https://github.com/fcitx/fcitx5-skk"
SRC_URI="https://download.fcitx-im.org/fcitx5/${MY_PN}/${MY_PN}-${PV}.tar.xz"

LICENSE="GPL-3+"
SLOT="5"
KEYWORDS="~amd64 ~x86"
IUSE="+qt5 qt6"

RDEPEND="
	>=app-i18n/fcitx-5.1.6:5
	app-i18n/fcitx-qt[qt5?,qt6?,-onlyplugin]
	app-i18n/libskk
	app-i18n/skk-jisyo
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5=
		dev-qt/qtwidgets:5
	)
	qt6? (
		dev-qt/qtbase:6[gui,widgets]
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	kde-frameworks/extra-cmake-modules:0
	virtual/pkgconfig
"

S="${WORKDIR}/${MY_PN}-${PV}"

src_configure() {
	local mycmakeargs=(
		-DENABLE_QT=$(usex qt5 ON $(usex qt6))
		-DUSE_QT6=$(usex qt5 OFF $(usex qt6))
	)
	cmake_src_configure
}
