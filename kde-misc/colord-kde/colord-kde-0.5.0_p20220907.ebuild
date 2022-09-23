# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KDE_ORG_CATEGORY=graphics
KDE_ORG_COMMIT=077644b5abf2992828bcc37c2598bc8810a24e9c
KFMIN=5.96.0
QTMIN=5.15.5
inherit ecm kde.org

DESCRIPTION="Provides interfaces and session daemon to colord"
HOMEPAGE="https://invent.kde.org/graphics/colord-kde"

LICENSE="GPL-2+"
SLOT="5"
KEYWORDS="~amd64 ~x86"
IUSE="X"

COMMON_DEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-frameworks/kcmutils-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kdbusaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kservice-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	media-libs/lcms:2
	X? (
		>=dev-qt/qtx11extras-${QTMIN}:5
		x11-libs/libX11
		x11-libs/libxcb
	)
"
DEPEND="${COMMON_DEPEND}
	>=kde-frameworks/kwindowsystem-${KFMIN}:5
"
RDEPEND="${COMMON_DEPEND}
	kde-plasma/kde-cli-tools:5
	x11-misc/colord
"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package X X11)
	)
	ecm_src_configure
}

pkg_postinst() {
	ecm_pkg_postinst
	if ! has_version "gnome-extra/gnome-color-manager"; then
		elog "You may want to install gnome-extra/gnome-color-manager to add support for"
		elog "colorhug calibration devices."
	fi
}
