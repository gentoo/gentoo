# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_DESIGNERPLUGIN="true"
ECM_HANDBOOK="optional"
ECM_TEST="true"
EGIT_BRANCH="work/kossebau/kf6"
KFMIN=6.22.0
QTMIN=6.10.1
inherit ecm kde.org optfeature xdg

DESCRIPTION="Hex editor by KDE"
HOMEPAGE="https://apps.kde.org/okteta/"

if [[ ${KDE_BUILD_TYPE} != live ]]; then
	if [[ ${PV} == *_p* ]]; then
		SRC_URI="https://dev.gentoo.org/~asturm/distfiles/kde/${P}.tar.xz"
	elif [[ ${KDE_BUILD_TYPE} == release ]]; then
		SRC_URI="mirror://kde/stable/${PN}/${PV}/src/${P}.tar.xz"
	fi
	KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
fi

LICENSE="GPL-2 handbook? ( FDL-1.2 )"
SLOT="0/4"
IUSE=""

# TODO: re-add whatever JS engine they are going to use instead
# >=dev-qt/qtscript-${QTMIN}:5[scripttools]
DEPEND="
	>=dev-qt/qt5compat-${QTMIN}:6
	>=dev-qt/qtbase-${QTMIN}:6[gui,network,widgets,xml]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=kde-frameworks/kbookmarks-${KFMIN}:6
	>=kde-frameworks/kcolorscheme-${KFMIN}:6
	>=kde-frameworks/kcompletion-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kcrash-${KFMIN}:6
	>=kde-frameworks/kdbusaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kitemviews-${KFMIN}:6
	>=kde-frameworks/kjobwidgets-${KFMIN}:6
	>=kde-frameworks/knewstuff-${KFMIN}:6
	>=kde-frameworks/kparts-${KFMIN}:6
	>=kde-frameworks/kservice-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kxmlgui-${KFMIN}:6
"
RDEPEND="${DEPEND}
	!${CATEGORY}/${PN}:5
"

pkg_setup() {
	einfo "This ebuild is building upstream's work/kossebau/kf6 branch, which:"
	einfo "- contains the complete dump of the \"it builds, starts and does not crash"
	einfo "  on simple usage\" changes"
	einfo "- [is] continuously rebased to master branch, the latest current Qt5/KF5-based"
	einfo "- [has] Structures tool disabled from build, needs QtScript port - so do NOT"
	einfo "  file a bug about that missing."
}

src_configure() {
	local mycmakeargs=(
		-DOMIT_EXAMPLES=ON
	)

	ecm_src_configure
}

src_test() {
	ecm_src_test -j1
}

pkg_postinst() {
	xdg_pkg_postinst
	optfeature "terminal tool" "kde-apps/konsole:6"
}
