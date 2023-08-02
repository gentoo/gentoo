# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KDE_ORG_CATEGORY="utilities"
KDE_ORG_NAME="kate"
ECM_TEST="true"
KFMIN=5.106.0
QTMIN=5.15.9
inherit ecm flag-o-matic gear.kde.org optfeature

DESCRIPTION="Addons used by Kate"
HOMEPAGE="https://kate-editor.org/ https://apps.kde.org/kate/"
SRC_URI+=" https://dev.gentoo.org/~asturm/distfiles/${KDE_ORG_NAME}-23.04.1-cmake.patch.xz"

LICENSE="LGPL-2 LGPL-2+ MIT"
SLOT="5"
KEYWORDS="amd64 arm64 ~loong ~ppc64 ~riscv x86"
IUSE="+filebrowser lspclient +projects +snippets sql"

DEPEND="
	>=dev-qt/qtconcurrent-${QTMIN}:5
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	~kde-apps/kate-lib-${PV}:5
	>=kde-frameworks/kcodecs-${KFMIN}:5
	>=kde-frameworks/kcompletion-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kcrash-${KFMIN}:5
	>=kde-frameworks/kdbusaddons-${KFMIN}:5
	>=kde-frameworks/kguiaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kiconthemes-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kitemviews-${KFMIN}:5
	>=kde-frameworks/kjobwidgets-${KFMIN}:5
	>=kde-frameworks/kparts-${KFMIN}:5
	>=kde-frameworks/kservice-${KFMIN}:5
	>=kde-frameworks/ktexteditor-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kwindowsystem-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	>=kde-frameworks/syntax-highlighting-${KFMIN}:5
	filebrowser? ( >=kde-frameworks/kbookmarks-${KFMIN}:5 )
	lspclient? ( >=kde-frameworks/kitemmodels-${KFMIN}:5 )
	projects? (
		>=kde-frameworks/knewstuff-${KFMIN}:5
		>=kde-frameworks/threadweaver-${KFMIN}:5
	)
	snippets? ( >=kde-frameworks/knewstuff-${KFMIN}:5 )
	sql? (
		>=dev-qt/qtsql-${QTMIN}:5
		>=kde-frameworks/kwallet-${KFMIN}:5
	)
"
RDEPEND="${DEPEND}
	!<kde-apps/kate-22.08.0:5
"

PATCHES=( "${WORKDIR}/${KDE_ORG_NAME}-23.04.1-cmake.patch" ) # KDE-bug 905709

src_prepare() {
	ecm_src_prepare

	# these tests are run in kde-apps/kate-lib
	cmake_run_in apps/lib cmake_comment_add_subdirectory autotests

	# delete colliding libkate/kwrite translations
	find po -type f -name "*po" -and \( -name "kwrite*" -or -name "kate.po" \) -delete || die
	rm -rf po/*/docs || die
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_kate=FALSE
		-DBUILD_kwrite=FALSE
		-DCMAKE_DISABLE_FIND_PACKAGE_KF5DocTools=ON # docs in kate/kwrite
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
	ecm_pkg_postinst
}
