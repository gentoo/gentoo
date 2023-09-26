# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit llvm optfeature qt6-build

DESCRIPTION="Qt Tools Collection"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~x86"
fi

IUSE="
	+assistant clang designer distancefieldgenerator gles2-only
	+linguist opengl pixeltool qdbus qdoc qml qtattributionsscanner
	qtdiag qtplugininfo vulkan +widgets zstd
"
# note that some tools do not *require* widgets but will skip a sub-tool
# if not enabled (e.g. linguist gives lrelease but not the GUI linguist6)
REQUIRED_USE="
	assistant? ( widgets )
	designer? ( qml widgets )
	distancefieldgenerator? ( qml widgets )
	pixeltool? ( widgets )
	qdoc? ( clang qml )
"

# behaves very badly when qttools is not already installed, also
# other more minor issues (clang tests flaky depending on version,
# and 3rdparty/ tries to FetchContent gtest)
RESTRICT="test"

LLVM_MAX_SLOT=17
RDEPEND="
	~dev-qt/qtbase-${PV}:6[network,widgets?]
	assistant? ( ~dev-qt/qtbase-${PV}:6[sql,sqlite] )
	clang? ( <sys-devel/clang-$((LLVM_MAX_SLOT+1)):= )
	designer? (
		app-arch/zstd:=
		~dev-qt/qtbase-${PV}:6[xml,zstd=]
	)
	qdbus? ( ~dev-qt/qtbase-${PV}:6[dbus,xml] )
	qml? ( ~dev-qt/qtdeclarative-${PV}:6[widgets?] )
	qtdiag? ( ~dev-qt/qtbase-${PV}:6[gles2-only=,vulkan=] )
	widgets? ( ~dev-qt/qtbase-${PV}:6[opengl=] )
"
DEPEND="
	${RDEPEND}
	qtdiag? (
		vulkan? ( dev-util/vulkan-headers )
	)
"

pkg_setup() {
	use clang && llvm_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package qml Qt6Qml)
		$(cmake_use_find_package widgets Qt6Widgets)
		$(qt_feature assistant)
		$(qt_feature clang)
		$(qt_feature designer)
		$(qt_feature distancefieldgenerator)
		$(qt_feature linguist)
		$(qt_feature pixeltool)
		$(qt_feature qdbus)
		$(qt_feature qdoc)
		$(qt_feature qtattributionsscanner)
		$(qt_feature qtdiag)
		$(qt_feature qtplugininfo)

		# TODO?: package litehtml, but support for latest releases seem
		# to lag behind and bundled may work out better for now
		# https://github.com/litehtml/litehtml/issues/266
		$(usev assistant -DCMAKE_DISABLE_FIND_PACKAGE_litehtml=ON)
	)

	qt6-build_src_configure
}

pkg_postinst() {
	use assistant &&
		optfeature "Qt documentation viewable in assistant" \
			'dev-qt/qt-docs:6[qch]' #602296
}
