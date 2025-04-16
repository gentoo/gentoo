# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KDE_ORG_CATEGORY="utilities"
KDE_ORG_NAME="kate"
ECM_TEST="true"
KFMIN=6.9.0
QTMIN=6.7.2
inherit ecm flag-o-matic gear.kde.org optfeature

DESCRIPTION="Addons used by Kate"
HOMEPAGE="https://kate-editor.org/ https://apps.kde.org/kate/"

LICENSE="LGPL-2 LGPL-2+ MIT"
SLOT="6"
KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="+filebrowser lspclient +projects +snippets sql"

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[concurrent,dbus,gui,network,widgets,xml]
	~kde-apps/kate-lib-${PV}:6
	>=kde-frameworks/kcodecs-${KFMIN}:6
	>=kde-frameworks/kcompletion-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kcrash-${KFMIN}:6
	>=kde-frameworks/kdbusaddons-${KFMIN}:6
	>=kde-frameworks/kguiaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kiconthemes-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kitemviews-${KFMIN}:6
	>=kde-frameworks/kjobwidgets-${KFMIN}:6
	>=kde-frameworks/kparts-${KFMIN}:6
	>=kde-frameworks/kservice-${KFMIN}:6
	>=kde-frameworks/ktexteditor-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kwindowsystem-${KFMIN}:6
	>=kde-frameworks/kxmlgui-${KFMIN}:6
	>=kde-frameworks/syntax-highlighting-${KFMIN}:6
	filebrowser? ( >=kde-frameworks/kbookmarks-${KFMIN}:6 )
	lspclient? ( >=kde-frameworks/kitemmodels-${KFMIN}:6 )
	projects? (
		>=kde-frameworks/knewstuff-${KFMIN}:6
		>=kde-frameworks/threadweaver-${KFMIN}:6
	)
	snippets? ( >=kde-frameworks/knewstuff-${KFMIN}:6 )
	sql? (
		>=dev-libs/qtkeychain-0.14.2:=[qt6(+)]
		>=dev-qt/qtbase-${QTMIN}:6[sql]
		>=kde-frameworks/kwallet-${KFMIN}:6
	)
"
RDEPEND="${DEPEND}
	>=kde-apps/kate-common-${PV}
"

src_prepare() {
	ecm_src_prepare
	ecm_punt_po_install

	# these tests are run in kde-apps/kate-lib
	cmake_run_in apps/lib cmake_comment_add_subdirectory autotests
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_kate=FALSE
		-DBUILD_kwrite=FALSE
		-DCMAKE_DISABLE_FIND_PACKAGE_KF6DocTools=ON # docs in kate/kwrite
		-DBUILD_filebrowser=$(usex filebrowser)
		-DBUILD_lspclient=$(usex lspclient)
		-DBUILD_project=$(usex projects)
		-DBUILD_snippets=$(usex snippets)
		-DBUILD_katesql=$(usex sql)
	)

	# provided by kde-apps/kate-lib
	append-libs -lkateprivate

	ecm_src_configure
}

src_install() {
	ecm_src_install

	# provided by kde-apps/kate-lib
	rm -v "${ED}"/usr/$(get_libdir)/libkateprivate.so.* || die
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		optfeature "Markdown text previews" "kde-misc/markdownpart:${SLOT}"
		optfeature "DOT graph file previews" "media-gfx/kgraphviewer"
	fi
}
