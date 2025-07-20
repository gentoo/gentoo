# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QT6_HAS_STATIC_LIBS=1
inherit qt6-build

DESCRIPTION="Qt module and API for defining 3D content in Qt QuickTools"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
elif [[ ${QT6_BUILD_TYPE} == live ]]; then
	EGIT_SUBMODULES=() # skip qtquick3d-assimp
fi

IUSE="opengl vulkan"

# <assimp-6: https://bugreports.qt.io/browse/QTBUG-137996 (same as qt3d)
RDEPEND="
	~dev-qt/qtbase-${PV}:6[concurrent,gui,opengl=,vulkan=,widgets]
	~dev-qt/qtdeclarative-${PV}:6
	~dev-qt/qtquicktimeline-${PV}:6
	~dev-qt/qtshadertools-${PV}:6
	<media-libs/assimp-6:=
	sys-libs/zlib:=
"
DEPEND="
	${RDEPEND}
	test? ( ~dev-qt/qtbase-${PV}:6[network] )
	vulkan? ( dev-util/vulkan-headers )
"
BDEPEND="
	~dev-qt/qtshadertools-${PV}:6
"

PATCHES=(
	"${FILESDIR}"/${PN}-6.6.2-gcc14.patch
	"${FILESDIR}"/${PN}-6.6.2-x32abi.patch
)

CMAKE_SKIP_TESTS=(
	# needs off-by-default assimp[collada] that is masked on some profiles,
	# not worth the extra trouble
	tst_qquick3dassetimport
)

src_configure() {
	local mycmakeargs=(
		# TODO: if someone wants it, openxr should likely have its own
		# USE and be packaged rather than use the bundled copy (if use
		# bundled, note need to setup python-any-r1)
		-DQT_FEATURE_quick3dxr_openxr=OFF
	)

	qt6-build_src_configure
}
