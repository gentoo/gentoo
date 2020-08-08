# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KFMIN=5.71.0
PVCUT=$(ver_cut 1-3)
QTMIN=5.14.2
inherit ecm kde.org

DESCRIPTION="Backend implementation for xdg-desktop-portal that is using Qt/KDE Frameworks"

LICENSE="LGPL-2+"
SLOT="5"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE="screencast"

COMMON_DEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtprintsupport-${QTMIN}:5[cups]
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kdeclarative-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kirigami-${KFMIN}:5
	>=kde-frameworks/knotifications-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/plasma-${KFMIN}:5
	screencast? (
		media-libs/libepoxy
		media-libs/mesa[gbm]
		media-video/pipewire:=
	)
"
DEPEND="${COMMON_DEPEND}
	>=dev-qt/qtconcurrent-${QTMIN}:5
	>=kde-frameworks/kwayland-${KFMIN}:5
"
RDEPEND="${COMMON_DEPEND}
	sys-apps/xdg-desktop-portal[screencast?]
"

src_configure() {
	local mycmakeargs=(
		-DENABLE_PIPEWIRE=$(usex screencast)
	)
	ecm_src_configure
}
