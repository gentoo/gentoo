# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="optional"
PVCUT=$(ver_cut 1-3)
KFMIN=6.5.0
QTMIN=6.7.2
inherit ecm flag-o-matic gear.kde.org

DESCRIPTION="MathML-based 2D and 3D graph calculator by KDE"
HOMEPAGE="https://apps.kde.org/kalgebra/"

LICENSE="GPL-2+"
SLOT="6"
KEYWORDS="~amd64 ~arm64"
IUSE="readline"

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[gui,opengl,widgets]
	>=dev-qt/qt5compat-${QTMIN}:6
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=dev-qt/qtsvg-${QTMIN}:6
	>=dev-qt/qtwebengine-${QTMIN}:6[widgets]
	>=kde-apps/analitza-${PVCUT}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kxmlgui-${KFMIN}:6
	kde-plasma/libplasma:6
	readline? ( sys-libs/readline:0= )
"
RDEPEND="${DEPEND}
	>=kde-frameworks/kirigami-${KFMIN}:6
"

src_configure() {
	replace-flags "-Os" "-O2" # bug 829323

	local mycmakeargs=(
		$(cmake_use_find_package readline Readline)
	)

	ecm_src_configure
}
