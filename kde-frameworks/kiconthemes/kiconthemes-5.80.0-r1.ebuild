# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_DESIGNERPLUGIN="true"
PVCUT=$(ver_cut 1-2)
QTMIN=5.15.2
VIRTUALX_REQUIRED="test"
inherit ecm kde.org

DESCRIPTION="Framework for icon theming and configuration"
LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 x86"
IUSE=""

RESTRICT+=" test" # bug 574770

DEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtsvg-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	=kde-frameworks/karchive-${PVCUT}*:5
	=kde-frameworks/kconfig-${PVCUT}*:5
	=kde-frameworks/kconfigwidgets-${PVCUT}*:5
	=kde-frameworks/kcoreaddons-${PVCUT}*:5
	=kde-frameworks/ki18n-${PVCUT}*:5
	=kde-frameworks/kitemviews-${PVCUT}*:5
	=kde-frameworks/kwidgetsaddons-${PVCUT}*:5
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-fix-svg-icons.patch" # bug 779079
	"${FILESDIR}/${P}-revert-private-header-to-avoid-extern.patch"
	"${FILESDIR}/${P}-revert-avoid-plugin-load-racecondition.patch"
)
