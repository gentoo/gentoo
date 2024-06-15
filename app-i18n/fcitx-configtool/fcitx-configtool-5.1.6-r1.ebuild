# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="fcitx5-configtool"

inherit cmake unpacker

DESCRIPTION="Configuration module for Fcitx"
HOMEPAGE="https://fcitx-im.org/ https://github.com/fcitx/fcitx5-configtool"
SRC_URI="https://download.fcitx-im.org/fcitx5/${MY_PN}/${MY_PN}-${PV}.tar.zst -> ${P}.tar.zst"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="GPL-2+"
SLOT="5"
KEYWORDS="~amd64"
IUSE="kcm +config-qt qt6 test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=app-i18n/fcitx-5.1.6:5
	app-text/iso-codes
	sys-devel/gettext
	virtual/libintl
	x11-libs/libX11
	x11-libs/libxkbfile
	x11-misc/xkeyboard-config
	kcm? ( x11-libs/libxkbcommon )
	!qt6? (
		>=app-i18n/fcitx-qt-5.1.4:5[qt5,-onlyplugin]
		dev-qt/qtconcurrent:5
		dev-qt/qtcore:5
		dev-qt/qtdbus:5
		dev-qt/qtgui:5
		dev-qt/qtsvg:5
		dev-qt/qtwidgets:5
		dev-qt/qtx11extras:5
		kde-frameworks/kwidgetsaddons:5
		config-qt? (
			kde-frameworks/kitemviews:5
		)
		kcm? (
			dev-qt/qtquickcontrols2:5
			kde-frameworks/kcoreaddons:5
			kde-frameworks/kdeclarative:5
			kde-frameworks/ki18n:5
			kde-frameworks/kiconthemes:5
			kde-frameworks/kirigami:5
			kde-frameworks/kpackage:5
			kde-plasma/libplasma:5
		)
	)
	qt6? (
		>=app-i18n/fcitx-qt-5.1.4:5[qt6,-onlyplugin]
		dev-qt/qtbase:6[concurrent,dbus,gui,widgets]
		dev-qt/qtsvg:6
		kde-frameworks/kwidgetsaddons:6
		config-qt? (
			kde-frameworks/kitemviews:6
		)
		kcm? (
			dev-qt/qtdeclarative:6
			kde-frameworks/kcoreaddons:6
			kde-frameworks/kdeclarative:6
			kde-frameworks/ki18n:6
			kde-frameworks/kiconthemes:6
			kde-frameworks/kirigami:6
			kde-frameworks/kpackage:6
			kde-frameworks/ksvg:6
			kde-frameworks/kcmutils:6
			kde-plasma/libplasma:6
		)
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	$(unpacker_src_uri_depends)
	kde-frameworks/extra-cmake-modules:0
	sys-devel/gettext
	virtual/pkgconfig
"

src_configure() {
	local mycmakeargs=(
		-DKDE_INSTALL_USE_QT_SYS_PATHS=yes
		-DENABLE_KCM=$(usex kcm)
		-DENABLE_CONFIG_QT=$(usex config-qt)
		-DENABLE_TEST=$(usex test)
		-DUSE_QT6=$(usex qt6)
	)

	cmake_src_configure
}
