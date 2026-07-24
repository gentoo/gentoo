# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KFMIN=6.26.0
QTMIN=6.10.1
inherit ecm plasma.kde.org xdg

DESCRIPTION="Plasma shell for TVs"
HOMEPAGE="https://plasma-bigscreen.org/"

LICENSE="Apache-2.0 GPL-2"
SLOT="6"
KEYWORDS="~amd64"
IUSE=""

# TODO: libcec automagic
COMMON_DEPEND="
	>=dev-libs/qcoro-0.7.0[qml]
	>=dev-libs/libcec-6:=
	dev-libs/wayland
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,network]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=dev-qt/qtmultimedia-${QTMIN}:6
	>=dev-qt/qtwebengine-${QTMIN}:6[qml]
	>=kde-frameworks/bluez-qt-${KFMIN}:6
	>=kde-frameworks/kcmutils-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kdeclarative-${KFMIN}:6
	>=kde-frameworks/kdbusaddons-${KFMIN}:6
	>=kde-frameworks/kglobalaccel-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kiconthemes-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kirigami-${KFMIN}:6
	>=kde-frameworks/knotifications-${KFMIN}:6
	>=kde-frameworks/kservice-${KFMIN}:6
	>=kde-frameworks/ksvg-${KFMIN}:6
	>=kde-frameworks/kwindowsystem-${KFMIN}:6
	>=kde-plasma/kwayland-${KDE_CATV}:6
	>=kde-plasma/libkscreen-${KDE_CATV}:6=
	>=kde-plasma/libplasma-${KDE_CATV}:6=
	>=kde-plasma/plasma-activities-${KDE_CATV}:6=
	>=kde-plasma/plasma-activities-stats-${KDE_CATV}:6
	>=kde-plasma/plasma-workspace-${KDE_CATV}:6
	media-libs/libsdl3
"
DEPEND="${COMMON_DEPEND}
	dev-libs/plasma-wayland-protocols
"
RDEPEND="${COMMON_DEPEND}
	>=kde-plasma/kwin-${KDE_CATV}:6
	>=kde-plasma/milou-${KDE_CATV}:6
	>=kde-plasma/plasma-nano-${KDE_CATV}:6
	>=kde-plasma/plasma-nm-${KDE_CATV}:6
	>=kde-plasma/plasma-pa-${KDE_CATV}:6
	>=dev-qt/qtsvg-${QTMIN}:6
	>=dev-qt/qtvirtualkeyboard-${QTMIN}:6
"
BDEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[wayland]
	dev-util/wayland-scanner
"
