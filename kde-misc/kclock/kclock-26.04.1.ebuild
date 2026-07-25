# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KDE_ORG_CATEGORY="utilities"
KFMIN=6.22.0
QTMIN=6.10.1
inherit ecm gear.kde.org xdg

DESCRIPTION="Convergent clock application for Plasma"
HOMEPAGE="https://apps.kde.org/kclock/"

LICENSE="CC0-1.0 CC-BY-4.0 GPL-2+ GPL-3+ LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~x86"
IUSE=""

# slot op: Uses Qt6WaylandClientPrivate
RDEPEND="
	dev-libs/kirigami-addons:6
	dev-libs/wayland
	>=dev-qt/qtbase-${QTMIN}:6=[gui,network,wayland,widgets]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=dev-qt/qtmultimedia-${QTMIN}:6[qml]
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kcrash-${KFMIN}:6
	>=kde-frameworks/kdbusaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kirigami-${KFMIN}:6
	>=kde-frameworks/kjobwidgets-${KFMIN}:6
	>=kde-frameworks/knotifications-${KFMIN}:6
	>=kde-frameworks/kstatusnotifieritem-${KFMIN}:6
	>=kde-frameworks/ksvg-${KFMIN}:6
	>=kde-frameworks/kwindowsystem-${KFMIN}:6[wayland]
	kde-plasma/libplasma:6=
"
DEPEND="${RDEPEND}
	>=dev-libs/plasma-wayland-protocols-1.8
	>=dev-libs/wayland-protocols-1.21
"
BDEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[wayland]
	dev-util/wayland-scanner
"

src_configure() {
	local mycmakeargs=(
		# switching off breaks build, does not save enough deps to be worth it
		-DKCLOCK_BUILD_SHELL_OVERLAY=ON # $(usex lock)
	)

	ecm_src_configure
}
