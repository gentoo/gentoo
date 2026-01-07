# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KDE_ORG_COMMIT=d5035b2540e16d4c94aff601bbceb3f94a82d8cd
ECM_DESIGNERPLUGIN="true"
ECM_HANDBOOK="forceoptional"
ECM_TEST="true"
EGIT_BRANCH="work/kossebau/kf6"
KFMIN=6.21.0
QTMIN=6.8.1
inherit ecm kde.org optfeature xdg

DESCRIPTION="Hex editor by KDE"
HOMEPAGE="https://apps.kde.org/okteta/"
SRC_URI="https://dev.gentoo.org/~asturm/distfiles/kde/${KDE_ORG_NAME}-${PV}-${KDE_ORG_COMMIT:0:8}.tar.gz
https://dev.gentoo.org/~asturm/distfiles/kde/${KDE_ORG_NAME}-0.26.60-ecm-6.21.patch.xz"

LICENSE="GPL-2 handbook? ( FDL-1.2 )"
SLOT="0/4"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE=""

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

PATCHES=(
	"${WORKDIR}/${PN}-0.26.60-ecm-6.21.patch" # part-revert
	"${FILESDIR}/${PN}-0.26.60-doctools-optional.patch" # downstream
)

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
