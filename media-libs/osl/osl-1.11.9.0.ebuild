# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit cmake llvm toolchain-funcs

# check this on updates
LLVM_MAX_SLOT=10

DESCRIPTION="Advanced shading language for production GI renderers"
HOMEPAGE="http://opensource.imageworks.com/?p=osl https://github.com/imageworks/OpenShadingLanguage"
SRC_URI="https://github.com/imageworks/OpenShadingLanguage/archive/Release-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/11"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

X86_CPU_FEATURES=(
	sse2:sse2 sse3:sse3 ssse3:ssse3 sse4_1:sse4.1 sse4_2:sse4.2
	avx:avx avx2:avx2 avx512f:avx512f f16c:f16c
)
CPU_FEATURES=( ${X86_CPU_FEATURES[@]/#/cpu_flags_x86_} )

IUSE="doc partio qt5 test ${CPU_FEATURES[@]%:*}"

RDEPEND="
	dev-libs/boost:=
	dev-libs/pugixml
	media-libs/openexr:=
	media-libs/openimageio:=
	<sys-devel/clang-11:=
	sys-libs/zlib
	partio? ( media-libs/partio )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
	)
"

DEPEND="
	${RDEPEND}
	dev-python/pybind11
"

BDEPEND="
	sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig
"

PATCHES=()

CMAKE_REMOVE_MODULES_LIST=()

# Restricting tests as Make file handles them differently
RESTRICT="test"

S="${WORKDIR}/OpenShadingLanguage-Release-${PV}"

llvm_check_deps() {
	has_version -r "sys-devel/clang:${LLVM_SLOT}"
}

src_configure() {
	local cpufeature
	local mysimd=()
	for cpufeature in "${CPU_FEATURES[@]}"; do
		use "${cpufeature%:*}" && mysimd+=("${cpufeature#*:}")
	done

	# If no CPU SIMDs were used, completely disable them
	[[ -z ${mysimd} ]] && mysimd=("0")

	local gcc=$(tc-getCC)
	# LLVM10+ needs CPP14+
	local mycmakeargs=(
		-DCMAKE_CXX_STANDARD=14
		-DCMAKE_INSTALL_DOCDIR="share/doc/${PF}"
		-DINSTALL_DOCS=$(usex doc)
		-DLLVM_STATIC=OFF
		-DLLVM_ROOT="$(get_llvm_prefix ${LLVM_MAX_SLOT})"
		-DOSL_BUILD_TESTS=$(usex test)
		-DOSL_SHADER_INSTALL_DIR="${EPREFIX}/usr/include/${PN^^}/shaders"
		-DOSL_PTX_INSTALL_DIR="${EPREFIX}/usr/include/${PN^^}/ptx"
		-DSTOP_ON_WARNING=OFF
		-DUSE_PARTIO=$(usex partio)
		-DUSE_QT=$(usex qt5)
		-DUSE_SIMD="$(IFS=","; echo "${mysimd[*]}")"
	)

	cmake_src_configure
}
