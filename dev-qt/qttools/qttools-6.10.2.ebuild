# Copyright 2021-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_COMPAT=( {17..21} ) # see .cmake.conf for minimum
LLVM_OPTIONAL=1

# behaves very badly when qttools is not already installed, also
# other issues to handle (clang tests flaky depending on version,
# and 3rdparty/ tries to FetchContent gtest)
QT6_RESTRICT_TESTS=1

inherit llvm-r2 optfeature qt6-build xdg

DESCRIPTION="Qt Tools Collection"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~x86"
fi

IUSE="
	+assistant designer distancefieldgenerator gles2-only +linguist
	opengl pixeltool +qdbus qdoc qml qmlls qtattributionsscanner qtdiag
	qtplugininfo vulkan +widgets zstd
"
# note that some tools do not *require* widgets but will skip a sub-tool
# if not enabled (e.g. linguist gives lrelease but not the GUI linguist6)
REQUIRED_USE="
	assistant? ( widgets )
	designer? ( qml widgets )
	distancefieldgenerator? ( qml widgets )
	pixeltool? ( widgets )
	qdoc? ( qml ${LLVM_REQUIRED_USE} )
	qmlls? ( assistant qml )
"

RDEPEND="
	~dev-qt/qtbase-${PV}:6[widgets?]
	assistant? (
		~dev-qt/qtbase-${PV}:6[concurrent,network,sql,sqlite]
		!dev-qt/assistant:5
	)
	designer? (
		~dev-qt/qtbase-${PV}:6[network,xml,zstd=]
		zstd? ( app-arch/zstd:= )
		!<dev-qt/designer-5.15.18-r1:5
	)
	linguist? (
		widgets? ( !dev-qt/linguist:5 )
	)
	qdbus? (
		~dev-qt/qtbase-${PV}:6[dbus,xml]
		widgets? ( !dev-qt/qdbusviewer:5 )
	)
	qdoc? (
		$(llvm_gen_dep '
			llvm-core/clang:${LLVM_SLOT}=
			llvm-core/llvm:${LLVM_SLOT}=
		')
	)
	qml? ( ~dev-qt/qtdeclarative-${PV}:6[widgets?] )
	qmlls? ( ~dev-qt/qtdeclarative-${PV}:6[qmlls] )
	qtdiag? ( ~dev-qt/qtbase-${PV}:6[network,gles2-only=,vulkan=] )
	widgets? ( ~dev-qt/qtbase-${PV}:6[opengl=] )
"
DEPEND="
	${RDEPEND}
	qtdiag? (
		vulkan? ( dev-util/vulkan-headers )
	)
"

src_prepare() {
	qt6-build_src_prepare

	# qttools is picky about clang versions and ignores LLVM_SLOT
	sed -e '/find_package/s/${\(LLVM_\)*VERSION_CLEAN}//' \
		-i cmake/FindWrapLibClang.cmake || die
}

src_configure() {
	use qdoc && llvm_chost_setup

	local mycmakeargs=(
		# prevent the clang test as it can abort due to bug #916098
		$(cmake_use_find_package qdoc WrapLibClang)
		$(cmake_use_find_package qml Qt6Qml)
		$(cmake_use_find_package widgets Qt6Widgets)
		$(qt_feature assistant)
		$(qt_feature designer)
		$(qt_feature distancefieldgenerator)
		$(qt_feature linguist)
		$(qt_feature pixeltool)
		$(qt_feature qdbus)
		$(qt_feature qdoc)
		$(qt_feature qtattributionsscanner)
		$(qt_feature qtdiag)
		$(qt_feature qtplugininfo)
		$(usev widgets -DQT_INSTALL_XDG_DESKTOP_ENTRIES=ON)

		# USE=qmlls' help plugin may be temporary, upstream has plans to split
		# QtHelp into another package so that qtdeclarative can depend on it
		# without a circular dependency with qttools
		$(cmake_use_find_package qmlls Qt6QmlLSPrivate)
	)

	qt6-build_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst

	use assistant &&
		optfeature "Qt documentation viewable in assistant" \
			'dev-qt/qt-docs:6[qch]' #602296
}
