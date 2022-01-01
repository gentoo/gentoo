# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PVCUT=$(ver_cut 1-3)
KFMIN=5.74.0
QTMIN=5.15.1
inherit ecm kde.org

DESCRIPTION="KDE Telepathy audio/video conferencing UI"
HOMEPAGE="https://community.kde.org/KTp"

LICENSE="GPL-2"
SLOT="5"
KEYWORDS="amd64 ~arm64 ~x86"
IUSE=""

RDEPEND="
	dev-libs/glib:2
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-apps/ktp-common-internals-${PVCUT}:5
	>=kde-frameworks/kcompletion-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kdeclarative-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kiconthemes-${KFMIN}:5
	>=kde-frameworks/knotifications-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	>=media-libs/phonon-4.11.0
	>=media-libs/qt-gstreamer-1.2.0-r4
	net-libs/farstream:0.2
	net-libs/telepathy-farstream
	>=net-libs/telepathy-qt-0.9.8[farstream]
"
# TODO: dep leak suspect
DEPEND="${RDEPEND}
	>=kde-frameworks/kcmutils-${KFMIN}:5
"
