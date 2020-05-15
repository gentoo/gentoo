# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_HANDBOOK="optional"
PVCUT=$(ver_cut 1-3)
KFMIN=5.70.0
QTMIN=5.12.3
inherit ecm kde.org

DESCRIPTION="MathML-based 2D and 3D graph calculator by KDE"
HOMEPAGE="https://kde.org/applications/education/org.kde.kalgebra
https://edu.kde.org/kalgebra/"

LICENSE="GPL-2" # TODO: CHECK
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="readline"

DEPEND="
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	>=kde-apps/analitza-${PVCUT}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtprintsupport-${QTMIN}:5
	>=dev-qt/qtwebengine-${QTMIN}:5[widgets]
	>=dev-qt/qtwidgets-${QTMIN}:5
	readline? ( sys-libs/readline:0= )
"
RDEPEND="${DEPEND}
	>=kde-frameworks/kirigami-${KFMIN}:5
	>=dev-qt/qtquickcontrols-${QTMIN}:5
"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package readline Readline)
	)

	ecm_src_configure
}
