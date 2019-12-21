# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_HANDBOOK="forceoptional"
ECM_TEST="true"
KDE_APPS_MINIMAL=19.04.3
KFMIN=5.60.0
QTMIN=5.12.3
VIRTUALDBUS_TEST="true"
VIRTUALX_REQUIRED="test"
inherit ecm kde.org

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Integrated Development Environment, supporting KF5/Qt, C/C++ and much more"
HOMEPAGE="https://www.kdevelop.org/"

LICENSE="GPL-2 LGPL-2"
SLOT="5/54" # look at KDEVELOP_SOVERSION inside CMakeLists.txt
IUSE="+gdbui hex +plasma +qmake reviewboard subversion webkit"

COMMON_DEPEND="
	>=kde-frameworks/karchive-${KFMIN}:5
	>=kde-frameworks/kbookmarks-${KFMIN}:5
	>=kde-frameworks/kcmutils-${KFMIN}:5
	>=kde-frameworks/kcodecs-${KFMIN}:5
	>=kde-frameworks/kcompletion-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kcrash-${KFMIN}:5
	>=kde-frameworks/kdeclarative-${KFMIN}:5
	>=kde-frameworks/kguiaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kiconthemes-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kitemmodels-${KFMIN}:5
	>=kde-frameworks/kitemviews-${KFMIN}:5
	>=kde-frameworks/kjobwidgets-${KFMIN}:5
	>=kde-frameworks/knewstuff-${KFMIN}:5
	>=kde-frameworks/knotifications-${KFMIN}:5
	>=kde-frameworks/knotifyconfig-${KFMIN}:5
	>=kde-frameworks/kparts-${KFMIN}:5
	>=kde-frameworks/kservice-${KFMIN}:5
	>=kde-frameworks/ktexteditor-${KFMIN}:5
	>=kde-frameworks/ktextwidgets-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kwindowsystem-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	>=kde-frameworks/sonnet-${KFMIN}:5
	>=kde-frameworks/threadweaver-${KFMIN}:5
	>=kde-apps/libkomparediff2-${KDE_APPS_MINIMAL}:5
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5[widgets]
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qthelp-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qttest-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	dev-libs/grantlee:5
	>=dev-util/astyle-3.1:=
	>=sys-devel/clang-3.8.0:=
	gdbui? ( >=kde-plasma/libksysguard-5.16.5:5 )
	hex? ( app-editors/okteta:5 )
	plasma? (
		>=kde-frameworks/krunner-${KFMIN}:5
		>=kde-frameworks/plasma-${KFMIN}:5
	)
	qmake? ( dev-util/kdevelop-pg-qt:5 )
	reviewboard? ( >=kde-frameworks/purpose-${KFMIN}:5 )
	subversion? (
		dev-libs/apr:1
		dev-libs/apr-util:1
		dev-vcs/subversion
	)
	webkit? ( >=dev-qt/qtwebkit-5.212.0_pre20180120:5 )
	!webkit? ( >=dev-qt/qtwebengine-${QTMIN}:5[widgets] )
"
DEPEND="${COMMON_DEPEND}
	dev-libs/boost
	>=dev-qt/qtconcurrent-${QTMIN}:5
"
RDEPEND="${COMMON_DEPEND}
	>=kde-apps/kapptemplate-${KDE_APPS_MINIMAL}:5
	>=kde-apps/kio-extras-${KDE_APPS_MINIMAL}:5
	>=dev-qt/qdbus-${QTMIN}:5
	>=dev-qt/qtquickcontrols-${QTMIN}:5
	>=dev-qt/qtquickcontrols2-${QTMIN}:5
	dev-util/ninja
	>=sys-devel/gdb-7.0[python]
	reviewboard? ( >=kde-apps/ktp-accounts-kcm-${KDE_APPS_MINIMAL}:5 )
	!dev-util/kdevelop-clang-tidy
	!dev-util/kdevplatform
"

RESTRICT+=" test"
# see bug 366471

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package gdbui KF5SysGuard)
		-DBUILD_executeplasmoid=$(usex plasma)
		$(cmake_use_find_package plasma KF5Plasma)
		$(cmake_use_find_package hex OktetaKastenControllers)
		$(cmake_use_find_package qmake KDevelop-PG-Qt)
		$(cmake_use_find_package reviewboard KF5Purpose)
		$(cmake_use_find_package subversion SubversionLibrary)
		$(cmake_use_find_package !webkit Qt5WebEngineWidgets)
	)

	use reviewboard || mycmakeargs+=( -DCMAKE_DISABLE_FIND_PACKAGE_KDEExperimentalPurpose=ON )

	ecm_src_configure
}

pkg_postinst() {
	ecm_pkg_postinst

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
