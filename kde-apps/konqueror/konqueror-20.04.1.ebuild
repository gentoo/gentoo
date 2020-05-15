# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_HANDBOOK="forceoptional" # not optional until !kdelibs4support
ECM_TEST="true"
KFMIN=5.70.0
QTMIN=5.12.3
VIRTUALX_REQUIRED="test"
inherit flag-o-matic ecm kde.org

DESCRIPTION="Web browser and file manager based on KDE Frameworks"
HOMEPAGE="https://kde.org/applications/internet/org.kde.konqueror"

LICENSE="GPL-2" # TODO: CHECK
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="activities speech X"

# 4 of 4 tests fail. Last checked for 4.0.3
RESTRICT+=" test"

COMMON_DEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwebengine-${QTMIN}:5[widgets]
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	>=kde-frameworks/karchive-${KFMIN}:5
	>=kde-frameworks/kbookmarks-${KFMIN}:5
	>=kde-frameworks/kcmutils-${KFMIN}:5
	>=kde-frameworks/kcodecs-${KFMIN}:5
	>=kde-frameworks/kcompletion-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kcrash-${KFMIN}:5
	>=kde-frameworks/kdbusaddons-${KFMIN}:5
	>=kde-frameworks/kdelibs4support-${KFMIN}:5
	>=kde-frameworks/kdesu-${KFMIN}:5
	>=kde-frameworks/kguiaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kiconthemes-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kitemviews-${KFMIN}:5
	>=kde-frameworks/kjobwidgets-${KFMIN}:5
	>=kde-frameworks/kparts-${KFMIN}:5
	>=kde-frameworks/kservice-${KFMIN}:5
	>=kde-frameworks/kwallet-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kwindowsystem-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	sys-libs/zlib
	speech? ( >=dev-qt/qtspeech-${QTMIN}:5 )
	X? ( >=dev-qt/qtx11extras-${QTMIN}:5 )
"
DEPEND="${COMMON_DEPEND}
	activities? ( >=kde-frameworks/kactivities-${KFMIN}:5 )
"
RDEPEND="${COMMON_DEPEND}
	kde-apps/kfind:5
	kde-plasma/kde-cli-tools:5
"

src_prepare() {
	[[ ${CHOST} == *-solaris* ]] && append-ldflags -lmalloc

	ecm_src_prepare
}

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package activities KF5Activities)
		$(cmake_use_find_package speech Qt5TextToSpeech)
		$(cmake_use_find_package X X11)
	)
	ecm_src_configure
}

pkg_postinst() {
	ecm_pkg_postinst

	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		if ! has_version kde-apps/keditbookmarks:${SLOT} ; then
			elog "For bookmarks support, install keditbookmarks:"
			elog "kde-apps/keditbookmarks:${SLOT}"
		fi

		if ! has_version kde-apps/dolphin:${SLOT} ; then
			elog "If you want to use konqueror as a filemanager, install the dolphin kpart:"
			elog "kde-apps/dolphin:${SLOT}"
		fi

		if ! has_version kde-apps/svg:${SLOT} ; then
			elog "For konqueror to view SVGs, install the svg kpart:"
			elog "kde-apps/svgpart:${SLOT}"
		fi

		if ! has_version virtual/jre ; then
			elog "To use Java on webpages install virtual/jre."
		fi
	fi
}
