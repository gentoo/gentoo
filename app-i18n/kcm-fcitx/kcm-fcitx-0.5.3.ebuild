# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

inherit cmake-utils

if [[ "${PV}" =~ (^|\.)9999$ ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/fcitx/kcm-fcitx"
fi

DESCRIPTION="KDE configuration module for Fcitx"
HOMEPAGE="https://fcitx-im.org/ https://github.com/fcitx/kcm-fcitx"
if [[ "${PV}" =~ (^|\.)9999$ ]]; then
	SRC_URI=""
else
	SRC_URI="https://download.fcitx-im.org/${PN}/${P}.tar.xz"
fi

LICENSE="GPL-2+"
SLOT="5"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=app-i18n/fcitx-4.2.8[dbus]
	app-i18n/fcitx-qt5
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	kde-frameworks/kcmutils:5
	kde-frameworks/kcoreaddons:5
	kde-frameworks/ki18n:5
	kde-frameworks/kio:5
	kde-frameworks/kitemviews:5
	kde-frameworks/knewstuff:5
	kde-frameworks/kwidgetsaddons:5
	virtual/libintl
	!${CATEGORY}/${PN}:4[-minimal(-)]"
DEPEND="${RDEPEND}
	kde-frameworks/extra-cmake-modules:5
	sys-devel/gettext
	virtual/pkgconfig"

src_prepare() {
	# x11-libs/libxkbfile only used by kbd-layout-viewer not ported to Qt 5 / KDE 5.
	sed -e "/find_package(XkbFile REQUIRED)/d" -i CMakeLists.txt

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DKDE_INSTALL_USE_QT_SYS_PATHS=yes
	)

	cmake-utils_src_configure
}
