# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PVCUT=$(ver_cut 1-3)
KFMIN=5.63.0
QTMIN=5.12.3
inherit ecm kde.org

DESCRIPTION="KDE Telepathy text chat window"
HOMEPAGE="https://community.kde.org/KTp"

LICENSE="Apache-2.0 || ( AFL-2.1 BSD ) GPL-2+ LGPL-2.1+ MIT"
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="speech"

DEPEND="
	>=kde-frameworks/karchive-${KFMIN}:5
	>=kde-frameworks/kcmutils-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kdbusaddons-${KFMIN}:5
	>=kde-frameworks/kemoticons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kiconthemes-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kitemviews-${KFMIN}:5
	>=kde-frameworks/knotifications-${KFMIN}:5
	>=kde-frameworks/knotifyconfig-${KFMIN}:5
	>=kde-frameworks/kpeople-${KFMIN}:5
	>=kde-frameworks/kservice-${KFMIN}:5
	>=kde-frameworks/ktextwidgets-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kwindowsystem-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	>=kde-frameworks/sonnet-${KFMIN}:5
	>=kde-apps/ktp-common-internals-${PVCUT}:5[otr]
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwebengine-${QTMIN}:5[widgets]
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	net-libs/telepathy-qt[qt5(+)]
	speech? ( >=dev-qt/qtspeech-${QTMIN}:5 )
"
RDEPEND="${DEPEND}
	>=kde-apps/ktp-contact-list-${PVCUT}:5
"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package speech Qt5TextToSpeech)
	)

	ecm_src_configure
}
