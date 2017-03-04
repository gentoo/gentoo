# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGIT_BRANCH="5.0"
KDEBASE="kdevelop"
KDE_TEST="forceoptional-recursive"
VIRTUALDBUS_TEST="true"
VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="KDE development support libraries and apps"
IUSE="cvs reviewboard subversion +welcomepage"
[[ ${KDE_BUILD_TYPE} = release ]] && KEYWORDS="~amd64 ~x86"

COMMON_DEPEND="
	$(add_frameworks_dep karchive)
	$(add_frameworks_dep kbookmarks)
	$(add_frameworks_dep kcmutils)
	$(add_frameworks_dep kcodecs)
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdeclarative)
	$(add_frameworks_dep kguiaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kitemmodels)
	$(add_frameworks_dep kitemviews)
	$(add_frameworks_dep kjobwidgets)
	$(add_frameworks_dep knewstuff)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep knotifyconfig)
	$(add_frameworks_dep kparts)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep ktexteditor)
	$(add_frameworks_dep ktextwidgets)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kwindowsystem)
	$(add_frameworks_dep kxmlgui)
	$(add_frameworks_dep sonnet)
	$(add_frameworks_dep threadweaver)
	$(add_kdeapps_dep libkomparediff2)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
	$(add_qt_dep qttest)
	$(add_qt_dep qtwebkit)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
	dev-libs/grantlee:5
	reviewboard? ( dev-libs/purpose )
	subversion? (
		dev-libs/apr:1
		dev-libs/apr-util:1
		dev-vcs/subversion
	)
	welcomepage? ( $(add_qt_dep qtdeclarative 'widgets') )
"
DEPEND="${COMMON_DEPEND}
	dev-libs/boost
	$(add_qt_dep qtconcurrent)
"
RDEPEND="${COMMON_DEPEND}
	cvs? ( dev-vcs/cvs )
	!dev-util/kdevelop:4
	!dev-util/kdevplatform:4
"

REQUIRED_USE="test? ( welcomepage )"

RESTRICT+=" test"

PATCHES=(
	"${FILESDIR}/${PN}-5.0.1-unused-deps.patch"
)

src_prepare() {
	kde5_src_prepare
	# root tests subdirectory actually does not contain tests, installs stuff
	if ! use test; then
		sed -i -e "/add_subdirectory(tests)/ s/#DONOTCOMPILE //" \
			CMakeLists.txt || die "Failed to fix CMakeLists.txt"
		sed -i -e '1s/^/find_package(Qt5Test \$\{QT_MIN_VERSION\})\n/' \
			tests/CMakeLists.txt || die "Failed to fix tests/CMakeLists.txt"
	fi
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_cvs=$(usex cvs)
		$(cmake-utils_use_find_package reviewboard KDEExperimentalPurpose)
		$(cmake-utils_use_find_package subversion SubversionLibrary)
		$(cmake-utils_use_find_package welcomepage Qt5QuickWidgets)
	)

	kde5_src_configure
}

pkg_postinst() {
	kde5_pkg_postinst

	if ! has_version "kde-apps/konsole" ; then
		echo
		elog "For konsole view, please install kde-apps/konsole"
		echo
	fi
}
