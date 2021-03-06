# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_HANDBOOK="forceoptional"
ECM_TEST="true"
KDE_ORG_CATEGORY="kdevelop"
KFMIN=5.77.0
QTMIN=5.15.2
VIRTUALDBUS_TEST="true"
VIRTUALX_REQUIRED="test"
inherit ecm kde.org optfeature

DESCRIPTION="Integrated Development Environment, supporting KF5/Qt, C/C++ and much more"
HOMEPAGE="https://kdevelop.org/"

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	KEYWORDS="~amd64 ~arm64 x86"
fi

LICENSE="GPL-2 LGPL-2"
SLOT="5/56" # look at KDEVELOP_SOVERSION inside CMakeLists.txt
IUSE="+gdbui hex +plasma +qmake reviewboard subversion"

# see bug 366471
RESTRICT+=" test"

COMMON_DEPEND="
	dev-libs/grantlee:5
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5[widgets]
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qthelp-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qttest-${QTMIN}:5
	>=dev-qt/qtwebengine-${QTMIN}:5[widgets]
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	>=dev-util/astyle-3.1:=
	kde-apps/libkomparediff2:5
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
	>=sys-devel/clang-6.0:=
	gdbui? ( kde-plasma/libksysguard:5= )
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
"
DEPEND="${COMMON_DEPEND}
	dev-libs/boost
	>=dev-qt/qtconcurrent-${QTMIN}:5
"
RDEPEND="${COMMON_DEPEND}
	>=dev-qt/qdbus-${QTMIN}:5
	>=dev-qt/qtquickcontrols-${QTMIN}:5
	>=dev-qt/qtquickcontrols2-${QTMIN}:5
	dev-util/ninja
	kde-apps/kapptemplate:5
	kde-apps/kio-extras:5
	>=sys-devel/gdb-7.0[python]
	reviewboard? ( kde-apps/ktp-accounts-kcm:5 )
"

src_configure() {
	local clang_version=$(best_version sys-devel/clang)
	local llvm_root="/usr/lib/llvm/$(ver_cut 1 ${clang_version##sys-devel/clang-})"

	local mycmakeargs=(
		-DLLVM_ROOT=${llvm_root}
		$(cmake_use_find_package gdbui KSysGuard)
		-DBUILD_executeplasmoid=$(usex plasma)
		$(cmake_use_find_package plasma KF5Plasma)
		$(cmake_use_find_package hex OktetaKastenControllers)
		$(cmake_use_find_package qmake KDevelop-PG-Qt)
		$(cmake_use_find_package reviewboard KF5Purpose)
		$(cmake_use_find_package subversion SubversionLibrary)
	)

	use gdbui || mycmakeargs+=( -DCMAKE_DISABLE_FIND_PACKAGE_KF5SysGuard=ON )
	use reviewboard || mycmakeargs+=( -DCMAKE_DISABLE_FIND_PACKAGE_KDEExperimentalPurpose=ON )

	ecm_src_configure
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		elog "Optional dependencies:"
		optfeature "konsole view" kde-apps/konsole
		optfeature "static C++ Qt code analysis" dev-util/clazy
		optfeature "static C/C++ code analysis" dev-util/cppcheck
		optfeature "heap memory profiling" dev-util/heaptrack[qt5]
		optfeature "meson project manager plugin" dev-util/meson
		optfeature "formatting configurations via customscript plugin" dev-util/indent
		optfeature "formatting configurations via customscript plugin" dev-util/uncrustify
	fi
	ecm_pkg_postinst
}
