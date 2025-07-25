# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="optional"
ECM_TEST="true"
KDE_ORG_CATEGORY="kdevelop"
KFMIN=6.13.0
LLVM_COMPAT=( 15 16 17 18 19 20 )
QTMIN=6.7.2
inherit ecm gear.kde.org llvm-r2 optfeature xdg

DESCRIPTION="Integrated Development Environment, supporting KF6/Qt, C/C++ and much more"
HOMEPAGE="https://kdevelop.org/"

LICENSE="GPL-2 LGPL-2"
SLOT="6/$(ver_cut 1-2)"
KEYWORDS="amd64 ~arm64"
IUSE="gdbui plasma +qmake +share subversion"

# see bug 366471
RESTRICT="test"

CMAKE_QA_COMPAT_SKIP=1 # bug 960669, fixed in >=25.08

# UPSTREAM: not ported yet, check plugins/CMakeLists.txt
# IUSE="hex"
# 	hex? ( app-editors/okteta:6 )
COMMON_DEPEND="
	>=dev-qt/qt5compat-${QTMIN}:6
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,network,widgets,xml]
	>=dev-qt/qtdeclarative-${QTMIN}:6[widgets]
	>=dev-qt/qttools-${QTMIN}:6[assistant]
	>=dev-qt/qtwebengine-${QTMIN}:6[widgets]
	>=dev-util/astyle-3.1:=
	kde-apps/libkomparediff2:6
	>=kde-frameworks/karchive-${KFMIN}:6
	>=kde-frameworks/kbookmarks-${KFMIN}:6
	>=kde-frameworks/kcmutils-${KFMIN}:6
	>=kde-frameworks/kcodecs-${KFMIN}:6
	>=kde-frameworks/kcompletion-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kcrash-${KFMIN}:6
	>=kde-frameworks/kguiaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kiconthemes-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kitemmodels-${KFMIN}:6
	>=kde-frameworks/kitemviews-${KFMIN}:6
	>=kde-frameworks/kjobwidgets-${KFMIN}:6
	>=kde-frameworks/knewstuff-${KFMIN}:6
	>=kde-frameworks/knotifications-${KFMIN}:6
	>=kde-frameworks/knotifyconfig-${KFMIN}:6
	>=kde-frameworks/kparts-${KFMIN}:6
	>=kde-frameworks/kservice-${KFMIN}:6
	>=kde-frameworks/ktexteditor-${KFMIN}:6
	>=kde-frameworks/ktexttemplate-${KFMIN}:6
	>=kde-frameworks/ktextwidgets-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kwindowsystem-${KFMIN}:6
	>=kde-frameworks/kxmlgui-${KFMIN}:6
	>=kde-frameworks/sonnet-${KFMIN}:6
	>=kde-frameworks/threadweaver-${KFMIN}:6
	$(llvm_gen_dep 'llvm-core/clang:${LLVM_SLOT}')
	gdbui? ( kde-plasma/libksysguard:6= )
	plasma? (
		>=kde-frameworks/krunner-${KFMIN}:6
		kde-plasma/libplasma:6
	)
	qmake? ( >=dev-util/kdevelop-pg-qt-2.3.0:0 )
	share? ( >=kde-frameworks/purpose-${KFMIN}:6 )
	subversion? (
		dev-libs/apr:1
		dev-libs/apr-util:1
		dev-vcs/subversion
	)
"
DEPEND="${COMMON_DEPEND}
	dev-libs/boost
	>=dev-qt/qtbase-${QTMIN}:6[concurrent]
"
RDEPEND="${COMMON_DEPEND}
	app-alternatives/ninja
	>=dev-debug/gdb-7.0[python]
	>=dev-qt/qttools-${QTMIN}:6[qdbus]
	kde-apps/kapptemplate:*
	kde-apps/kio-extras:6
"

src_configure() {
	local mycmakeargs=(
		-DLLVM_ROOT="$(get_llvm_prefix)"
		$(cmake_use_find_package gdbui KSysGuard)
		-DBUILD_executeplasmoid=$(usex plasma)
		$(cmake_use_find_package plasma Plasma)
		$(cmake_use_find_package qmake KDevelopPGQt)
		$(cmake_use_find_package share KF6Purpose)
		$(cmake_use_find_package subversion SubversionLibrary)
	)
	if has_version "<dev-util/kdevelop-pg-qt-2.4"; then
		mycmakeargs+=( $(cmake_use_find_package qmake KDevelop-PG-Qt) )
	fi

	ecm_src_configure
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		optfeature "konsole view" "kde-apps/konsole:6"
		optfeature "static C++ Qt code analysis" dev-util/clazy
		optfeature "static C/C++ code analysis" dev-util/cppcheck
		optfeature "heap memory profiling" "dev-util/heaptrack[gui]"
		optfeature "meson project manager plugin" dev-build/meson
		optfeature "formatting configurations via customscript plugin" dev-util/indent
		optfeature "formatting configurations via customscript plugin" dev-util/uncrustify
	fi
	xdg_pkg_postinst
}
