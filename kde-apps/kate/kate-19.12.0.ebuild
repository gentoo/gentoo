# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_HANDBOOK="optional"
ECM_TEST="true"
KFMIN=5.63.0
QTMIN=5.12.3
VIRTUALX_REQUIRED="test"
inherit ecm kde.org

DESCRIPTION="Multi-document editor with network transparency, Plasma integration and more"
HOMEPAGE="https://kate-editor.org/
https://kde.org/applications/utilities/org.kde.kate"

LICENSE="GPL-2" # TODO: CHECK
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="activities +filebrowser lspclient +projects plasma +snippets sql"

DEPEND="
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
	>=kde-frameworks/ktextwidgets-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kwindowsystem-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	activities? ( >=kde-frameworks/kactivities-${KFMIN}:5 )
	filebrowser? ( >=kde-frameworks/kbookmarks-${KFMIN}:5 )
	lspclient? ( >=kde-frameworks/kitemmodels-${KFMIN}:5 )
	plasma? ( >=kde-frameworks/plasma-${KFMIN}:5 )
	projects? (
		>=kde-frameworks/knewstuff-${KFMIN}:5
		>=kde-frameworks/threadweaver-${KFMIN}:5
	)
	snippets? ( >=kde-frameworks/knewstuff-${KFMIN}:5 )
	sql? (
		>=kde-frameworks/kwallet-${KFMIN}:5
		>=dev-qt/qtsql-${QTMIN}:5
	)
"
RDEPEND="${DEPEND}
	!kde-misc/ktexteditorpreviewplugin
"

src_prepare() {
	ecm_src_prepare

	# delete colliding kwrite translations
	if [[ ${KDE_BUILD_TYPE} = release ]]; then
		find po -type f -name "*po" -and -name "kwrite*" -delete || die
		rm -rf po/*/docs/kwrite || die
	fi
}

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package activities KF5Activities)
		-DBUILD_filebrowser=$(usex filebrowser)
		-DBUILD_lspclient=$(usex lspclient)
		-DBUILD_sessionapplet=$(usex plasma)
		-DBUILD_project=$(usex projects)
		-DBUILD_snippets=$(usex snippets)
		-DBUILD_katesql=$(usex sql)
		-DBUILD_kwrite=FALSE
	)

	ecm_src_configure
}

src_test() {
	# tests hang
	local myctestargs=(
		-E "(session_manager_test|sessions_action_test)"
	)

	ecm_src_test
}

pkg_postinst() {
	ecm_pkg_postinst

	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		elog "The functionality of ktexteditorpreview plugin can be extended with:"
		elog "  kde-misc/kmarkdownwebview"
		elog "  media-gfx/kgraphviewer"
	fi
}
