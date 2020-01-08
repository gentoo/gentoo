# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_HANDBOOK="forceoptional"
KDE_TEST="true"
VIRTUALDBUS_TEST="true"
VIRTUALX_REQUIRED="test"
inherit kde5

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	KEYWORDS="amd64 x86"
fi

DESCRIPTION="Integrated Development Environment, supporting KF5/Qt, C/C++ and much more"
HOMEPAGE="https://www.kdevelop.org/"

LICENSE="GPL-2 LGPL-2"
SLOT="5/54" # look at KDEVELOP_SOVERSION inside CMakeLists.txt
IUSE="+gdbui hex +plasma +qmake reviewboard subversion webkit"

COMMON_DEPEND="
	$(add_frameworks_dep karchive)
	$(add_frameworks_dep kbookmarks)
	$(add_frameworks_dep kcmutils)
	$(add_frameworks_dep kcodecs)
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kcrash)
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
	$(add_qt_dep qtdeclarative 'widgets')
	$(add_qt_dep qtgui)
	$(add_qt_dep qthelp)
	$(add_qt_dep qtnetwork)
	$(add_qt_dep qttest)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
	dev-libs/grantlee:5
	>=dev-util/astyle-3.1:=
	>=sys-devel/clang-3.8.0:=
	gdbui? ( $(add_plasma_dep libksysguard) )
	hex? ( app-editors/okteta:5 )
	plasma? (
		$(add_frameworks_dep krunner)
		$(add_frameworks_dep plasma)
	)
	qmake? ( dev-util/kdevelop-pg-qt:5 )
	reviewboard? ( $(add_frameworks_dep purpose) )
	subversion? (
		dev-libs/apr:1
		dev-libs/apr-util:1
		dev-vcs/subversion
	)
	webkit? ( >=dev-qt/qtwebkit-5.212.0_pre20180120:5 )
	!webkit? ( $(add_qt_dep qtwebengine 'widgets') )
"
DEPEND="${COMMON_DEPEND}
	dev-libs/boost
	$(add_qt_dep qtconcurrent)
"
RDEPEND="${COMMON_DEPEND}
	$(add_kdeapps_dep kapptemplate)
	$(add_kdeapps_dep kio-extras)
	$(add_qt_dep qdbus)
	$(add_qt_dep qtquickcontrols)
	$(add_qt_dep qtquickcontrols2)
	dev-util/ninja
	>=sys-devel/gdb-7.0[python]
	reviewboard? ( $(add_kdeapps_dep ktp-accounts-kcm) )
	!dev-util/kdevelop-clang-tidy
	!dev-util/kdevplatform
"

RESTRICT+=" test"
# see bug 366471

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package gdbui KF5SysGuard)
		-DBUILD_executeplasmoid=$(usex plasma)
		$(cmake-utils_use_find_package plasma KF5Plasma)
		$(cmake-utils_use_find_package hex OktetaKastenControllers)
		$(cmake-utils_use_find_package qmake KDevelop-PG-Qt)
		$(cmake-utils_use_find_package reviewboard KF5Purpose)
		$(cmake-utils_use_find_package subversion SubversionLibrary)
		$(cmake-utils_use_find_package !webkit Qt5WebEngineWidgets)
	)

	use reviewboard || mycmakeargs+=( -DCMAKE_DISABLE_FIND_PACKAGE_KDEExperimentalPurpose=ON )

	kde5_src_configure
}

pkg_postinst() {
	kde5_pkg_postinst

	if ! has_version "kde-apps/konsole" ; then
		elog "For konsole view, please install kde-apps/konsole"
	fi

	if ! has_version "dev-util/cppcheck" ; then
		elog "For static C/C++ code analysis support, please install dev-util/cppcheck"
	fi

	if ! has_version "dev-util/heaptrack[qt5]" ; then
		elog "For heap memory profiling support, please install dev-util/heaptrack"
	fi

	if ! has_version "dev-util/clazy" ; then
		elog "For static C++ Qt code analysis support, please install dev-util/clazy"
	fi
}
