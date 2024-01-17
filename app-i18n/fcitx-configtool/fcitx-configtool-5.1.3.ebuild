# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="fcitx5-configtool"

inherit cmake

DESCRIPTION="Configuration module for Fcitx"
HOMEPAGE="https://fcitx-im.org/ https://github.com/fcitx/fcitx5-configtool"
SRC_URI="https://download.fcitx-im.org/fcitx5/${MY_PN}/${MY_PN}-${PV}.tar.xz -> ${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~loong ~riscv ~x86"
IUSE="kcm +config-qt test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=app-i18n/fcitx-5.1.6:5
	>=app-i18n/fcitx-qt-5.1.4:5[qt5,-onlyplugin]
	app-text/iso-codes
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	kde-frameworks/kwidgetsaddons:5
	sys-devel/gettext
	virtual/libintl
	x11-libs/libX11
	x11-libs/libxkbfile
	x11-misc/xkeyboard-config
	config-qt? (
		kde-frameworks/kitemviews:5
	)
	kcm? (
		x11-libs/libxkbcommon
		dev-qt/qtquickcontrols2:5
		kde-frameworks/kcoreaddons:5
		kde-frameworks/kdeclarative:5
		kde-frameworks/ki18n:5
		kde-frameworks/kiconthemes:5
		kde-frameworks/kirigami:5
		kde-frameworks/kpackage:5
		kde-plasma/libplasma:5
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	kde-frameworks/extra-cmake-modules:0
	sys-devel/gettext
	virtual/pkgconfig
"

S="${WORKDIR}/${MY_PN}-${PV}"

src_configure() {
	local mycmakeargs=(
		-DKDE_INSTALL_USE_QT_SYS_PATHS=yes
		-DENABLE_KCM=$(usex kcm)
		-DENABLE_CONFIG_QT=$(usex config-qt)
		-DENABLE_TEST=$(usex test)
		# kde-frameworks/kitemviews:6 is not ready.
		-DUSE_QT6=no
	)

	cmake_src_configure
}
