# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
inherit cmake flag-o-matic llvm python-any-r1 readme.gentoo-r1 xdg

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI=(
		"https://code.qt.io/qt-creator/qt-creator.git"
		"https://github.com/qt-creator/qt-creator.git"
	)
	EGIT_SUBMODULES=(
		perfparser
		src/libs/qlitehtml
		src/libs/qlitehtml/src/3rdparty/litehtml
	)
else
	QTC_PV=${PV/_/-}
	QTC_P=${PN}-opensource-src-${QTC_PV}
	[[ ${QTC_PV} == ${PV} ]] && QTC_REL=official || QTC_REL=development
	SRC_URI="https://download.qt.io/${QTC_REL}_releases/qtcreator/$(ver_cut 1-2)/${PV/_/-}/${QTC_P}.tar.xz"
	S=${WORKDIR}/${QTC_P}
	KEYWORDS="~amd64"
fi

DESCRIPTION="Lightweight IDE for C++/QML development centering around Qt"
HOMEPAGE="https://www.qt.io/product/development-tools"

LICENSE="GPL-3"
SLOT="0"
IUSE="
	+clang +designer doc +help qmldesigner serialterminal
	+svg test +tracing webengine
"
RESTRICT="!test? ( test )"

LLVM_MAX_SLOT=17
QT_PV=6.2.0:6 # IDE_QT_VERSION_MIN

# := is used where Qt's private APIs are used for safety
COMMON_DEPEND="
	>=dev-qt/qt5compat-${QT_PV}
	>=dev-qt/qtbase-${QT_PV}=[concurrent,gui,network,widgets,xml]
	>=dev-qt/qtdeclarative-${QT_PV}=
	clang? (
		dev-cpp/yaml-cpp:=
		<sys-devel/clang-$((LLVM_MAX_SLOT+1)):=
	)
	designer? ( >=dev-qt/qttools-${QT_PV}[designer] )
	help? (
		>=dev-qt/qttools-${QT_PV}[assistant]
		webengine? ( >=dev-qt/qtwebengine-${QT_PV} )
	)
	qmldesigner? (
		>=dev-qt/qtquick3d-${QT_PV}=
		>=dev-qt/qtsvg-${QT_PV}
	)
	serialterminal? ( >=dev-qt/qtserialport-${QT_PV} )
	svg? ( >=dev-qt/qtsvg-${QT_PV} )
	tracing? (
		app-arch/zstd:=
		dev-libs/elfutils
		>=dev-qt/qtshadertools-${QT_PV}
	)
"
# qtimageformats for .webp in examples, semi-optfeature but useful in general
RDEPEND="
	${COMMON_DEPEND}
	help? ( >=dev-qt/qtimageformats-${QT_PV} )
	qmldesigner? ( >=dev-qt/qtquicktimeline-${QT_PV} )
"
DEPEND="${COMMON_DEPEND}"
BDEPEND="
	${PYTHON_DEPS}
	>=dev-qt/qttools-${QT_PV}[linguist]
	doc? ( >=dev-qt/qttools-${QT_PV}[qdoc] )
"

PATCHES=(
	"${FILESDIR}"/${PN}-11.0.2-musl-no-execinfo.patch
	"${FILESDIR}"/${PN}-11.0.2-musl-no-malloc-trim.patch
	"${FILESDIR}"/${PN}-11.0.2-qt653.patch
)

pkg_setup() {
	python-any-r1_pkg_setup
	use clang && llvm_pkg_setup
}

src_prepare() {
	cmake_src_prepare

	# needed for finding docs at runtime in PF
	sed -e "/_IDE_DOC_PATH/s/qtcreator/${PF}/" \
		-i cmake/QtCreatorAPIInternal.cmake || die
}

src_configure() {
	# -Werror=lto-type-mismatch issues, needs looking into
	filter-lto

	# temporary workaround for musl-1.2.4 (bug #903611), this ideally
	# needs fixing in qtbase as *64 usage comes from its headers' macros
	use elibc_musl && append-lfs-flags

	local mycmakeargs=(
		-DBUILD_WITH_PCH=no
		-DWITH_DOCS=$(usex doc)
		-DBUILD_DEVELOPER_DOCS=$(usex doc)
		-DWITH_TESTS=$(usex test)

		# TODO?: try to unbundle with =no when syntax-highlighting:6 exists
		-DBUILD_LIBRARY_KSYNTAXHIGHLIGHTING=yes

		# Much can be optional, but do not want to flood users (or maintainers)
		# with too many flags. Not to mention that many plugins are merely
		# wrappers around still optional tools (e.g. cvs) and any unwanted
		# plugins can be disabled at runtime. So optional flags are limited
		# to plugins with additional build-time dependencies.
		-DBUILD_LIBRARY_TRACING=$(usex tracing) # qml+perfprofiler,ctfvisual
		-DBUILD_EXECUTABLE_PERFPARSER=$(usex tracing)

		-DBUILD_PLUGIN_CLANGCODEMODEL=$(usex clang)
		-DBUILD_PLUGIN_CLANGFORMAT=$(usex clang)
		-DBUILD_PLUGIN_CLANGTOOLS=$(usex clang)
		-DCLANGTOOLING_LINK_CLANG_DYLIB=yes

		-DBUILD_PLUGIN_DESIGNER=$(usex designer)

		-DBUILD_PLUGIN_HELP=$(usex help)
		-DBUILD_HELPVIEWERBACKEND_QTWEBENGINE=$(usex webengine)
		-DBUILD_LIBRARY_QLITEHTML=$(usex help $(usex !webengine))
		# TODO?: package litehtml, but support for latest releases seem
		# to lag behind and bundled may work out better for now
		# https://bugreports.qt.io/browse/QTCREATORBUG-29169
		$(use help && usev !webengine -DCMAKE_DISABLE_FIND_PACKAGE_litehtml=yes)

		-DBUILD_PLUGIN_SERIALTERMINAL=$(usex serialterminal)

		-DENABLE_SVG_SUPPORT=$(usex svg)

		-DWITH_QMLDESIGNER=$(usex qmldesigner)

		-Djournald=no # not really useful unless match qtbase (needs systemd)

		# not packaged, but allow using if found
		#-DCMAKE_DISABLE_FIND_PACKAGE_LibDDemangle=yes
		#-DCMAKE_DISABLE_FIND_PACKAGE_LibRustcDemangle=yes
	)

	cmake_src_configure
}

src_test() {
	local -x QT_QPA_PLATFORM=offscreen

	local CMAKE_SKIP_TESTS=(
		# skipping same tests+label as upstream's CI by default
		# `grep ctest .github/workflows/build_cmake.yml`
		tst_perfdata
	)

	cmake_src_test --label-exclude exclude_from_precheck
}

src_compile() {
	cmake_src_compile

	use doc && cmake_build {qch,html}_docs
}

src_install() {
	cmake_src_install

	if use doc; then
		dodoc -r "${BUILD_DIR}"/doc/html
		dodoc "${BUILD_DIR}"/share/doc/${PF}/qtcreator{,-dev}.qch
		docompress -x /usr/share/doc/${PF}/qtcreator{,-dev}.qch
	fi

	local DISABLE_AUTOFORMATTING=yes
	local DOC_CONTENTS="\
Some plugins (if used) may need optional extra dependencies/USE.

This list provides associations with Gentoo's packages (if exists)
ordered as in Qt Creator's Help -> About Plugins (not exhaustive).

dev-qt/qt-docs:6 with USE=\"examples qch\" is notably recommended, or
else the example tab will be empty alongside missing documentation.

Build Systems:
- CMakeProjectManager (dev-util/cmake)
- MesonProjectManager (dev-util/meson)
- QbsProjectManager (dev-util/qbs)

C++:
- Beautifier (dev-util/astyle and/or dev-util/uncrustify)
- ClangCodeModel (USE=clang, dev-util/clazy to understand Qt semantics)
- ClangFormat (USE=clang)

Code Analyzer:
- ClangTools (USE=clang)
- Cppcheck (dev-util/cppcheck)
- CtfVisualizer (USE=tracing)
- PerfProfiler (USE=tracing)
- Valgrind (dev-util/valgrind)

Core:
- Help (USE=help + dev-qt/qt-docs:6 with USE=\"examples qch\")

Device Support:
- Android (dev-util/android-sdk-update-manager)

Other Languages:
- Nim (dev-lang/nim)
- Python (dev-lang/python)

Qt Creator:
- Designer (USE=designer)

Qt Quick:
- Insight (USE=qmldesigner)
- QmlDesigner (USE=qmldesigner)
- QmlProfiler (USE=tracing)

Utilities:
- Autotest (dev-cpp/catch, dev-cpp/gtest, or dev-libs/boost if used)
- Conan (dev-util/conan)
- Docker (app-containers/docker)
- Haskell (dev-lang/ghc)
- SerialTerminal (USE=serialterminal)
- SilverSearcher (sys-apps/the_silver_searcher)
- StudioWelcome (USE=qmldesigner)

Version Control:
- CVS (dev-vcs/cvs)
- Fossil (dev-vcs/fossil)
- Git (dev-vcs/git)
- Mercurial (dev-vcs/mercurial)
- Subversion (dev-vcs/subversion)"
	readme.gentoo_create_doc
}

pkg_postinst() {
	xdg_pkg_postinst
	readme.gentoo_print_elog
}
