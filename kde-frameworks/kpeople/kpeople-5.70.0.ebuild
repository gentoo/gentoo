# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PVCUT=$(ver_cut 1-2)
QTMIN=5.12.3
VIRTUALX_REQUIRED="test"
inherit ecm kde.org

DESCRIPTION="KDE contact person abstraction library"
HOMEPAGE="https://invent.kde.org/frameworks/kpeople"

LICENSE="LGPL-2.1"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 x86"
IUSE=""

DEPEND="
	=kde-frameworks/kconfig-${PVCUT}*:5
	=kde-frameworks/kcoreaddons-${PVCUT}*:5
	=kde-frameworks/ki18n-${PVCUT}*:5
	=kde-frameworks/kitemviews-${PVCUT}*:5
	=kde-frameworks/kwidgetsaddons-${PVCUT}*:5
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtsql-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
"
RDEPEND="${DEPEND}"

src_test() {
	# personsmodeltest segfaults, bug 668192
	local myctestargs=(
		-j1
		-E "(persondatatest)"
	)

	ecm_src_test
}
