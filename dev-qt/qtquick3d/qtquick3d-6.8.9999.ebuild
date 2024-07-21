# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qt6-build

DESCRIPTION="Qt module and API for defining 3D content in Qt QuickTools"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
elif [[ ${QT6_BUILD_TYPE} == live ]]; then
	EGIT_SUBMODULES=() # skip qtquick3d-assimp
fi

IUSE="opengl vulkan"

RDEPEND="
	~dev-qt/qtbase-${PV}:6[concurrent,gui,opengl=,vulkan=,widgets]
	~dev-qt/qtdeclarative-${PV}:6
	~dev-qt/qtquicktimeline-${PV}:6
	~dev-qt/qtshadertools-${PV}:6
	media-libs/assimp:=
	sys-libs/zlib:=
"
DEPEND="
	${RDEPEND}
	test? ( ~dev-qt/qtbase-${PV}:6[network] )
	vulkan? ( dev-util/vulkan-headers )
"

PATCHES=(
	"${FILESDIR}"/${PN}-6.6.2-gcc14.patch
	"${FILESDIR}"/${PN}-6.6.2-x32abi.patch
	"${FILESDIR}"/${PN}-6.7.2-gcc15.patch
)

CMAKE_SKIP_TESTS=(
	# collada support is disabled in system media-libs/assimp (bug #891787)
	tst_qquick3dassetimport
)

src_configure() {
	local mycmakeargs=(
		# using bundled OpenXR failed when last tried, and either way
		# it would be better to package it if someone needs this
		-DQT_FEATURE_quick3dxr_openxr=OFF
		-DQT_FEATURE_system_assimp=ON
		-DQT_FEATURE_system_openxr=ON
	)

	qt6-build_src_configure
}
