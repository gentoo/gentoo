# Copyright 2023-2025 Gentoo Authors
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
IUSE="kcm +config-qt test X"
RESTRICT="!test? ( test )"

RDEPEND="
	>=app-i18n/fcitx-5.1.13:5
	>=app-i18n/fcitx-qt-5.1.4:5[qt6(+),-onlyplugin]
	app-text/iso-codes
	dev-qt/qtbase:6[concurrent,dbus,gui,widgets]
	dev-qt/qtsvg:6
	kde-frameworks/kwidgetsaddons:6
	sys-devel/gettext
	virtual/libintl
	X? (
		x11-libs/libX11
		x11-libs/libxkbfile
		x11-misc/xkeyboard-config
	)
	config-qt? ( kde-frameworks/kitemviews:6 )
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
		x11-libs/libxkbcommon
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	$(unpacker_src_uri_depends)
	kde-frameworks/extra-cmake-modules:0
	sys-devel/gettext
	virtual/pkgconfig
"

PATCHES=( "${FILESDIR}"/${PN}-make-x11-dependencies-optional.patch )

src_configure() {
	local mycmakeargs=(
		-DKDE_INSTALL_USE_QT_SYS_PATHS=yes
		-DENABLE_KCM=$(usex kcm)
		-DENABLE_CONFIG_QT=$(usex config-qt)
		-DENABLE_X11=$(usex X)
		-DENABLE_TEST=$(usex test)
	)

	cmake_src_configure
}
