# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KFMIN=5.60.0
QTMIN=5.12.3
inherit ecm kde.org

DESCRIPTION="Provides interfaces and session daemon to colord"
HOMEPAGE="https://invent.kde.org/graphics/colord-kde"
SRC_URI="mirror://kde/stable/${PN}/${PV}/src/${P}.tar.xz
https://dev.gentoo.org/~asturm/distfiles/${P}-patches.tar.xz"

LICENSE="GPL-2+"
SLOT="5"
KEYWORDS="~amd64 ~x86"
IUSE=""

COMMON_DEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtx11extras-${QTMIN}:5
	>=kde-frameworks/kcmutils-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kdbusaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kservice-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	media-libs/lcms:2
	x11-libs/libxcb
	x11-libs/libX11
	x11-libs/libXrandr
"
DEPEND="${COMMON_DEPEND}
	>=kde-frameworks/kwindowsystem-${KFMIN}:5
"
RDEPEND="${COMMON_DEPEND}
	kde-plasma/kde-cli-tools:5
	x11-misc/colord
"

PATCHES=(
	"${WORKDIR}/${P}-patches"
	"${FILESDIR}/${P}-icon.patch"
)

pkg_postinst() {
	ecm_pkg_postinst
	if ! has_version "gnome-extra/gnome-color-manager"; then
		elog "You may want to install gnome-extra/gnome-color-manager to add support for"
		elog "colorhug calibration devices."
	fi
}
