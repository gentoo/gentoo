# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="optional"
KFMIN=5.82.0
QTMIN=5.15.5
VIRTUALX_REQUIRED="test"
inherit ecm kde.org

DESCRIPTION="Frontend to diff3 based on KDE Frameworks"
HOMEPAGE="https://apps.kde.org/kdiff3/ https://userbase.kde.org/KDiff3"
SRC_URI="mirror://kde/stable/${PN}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="5"
KEYWORDS="amd64 ~arm64 ~ppc64 x86"
IUSE=""

COMMON_DEPEND="
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtprintsupport-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kcrash-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kparts-${KFMIN}:5
	>=kde-frameworks/ktextwidgets-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
"
DEPEND="${COMMON_DEPEND}
	dev-libs/boost
"
RDEPEND="${COMMON_DEPEND}
	sys-apps/diffutils
"

src_configure() {
	local mycmakeargs=(
		-DBUILD_WITH_QT6=OFF
	)
	ecm_src_configure
}
