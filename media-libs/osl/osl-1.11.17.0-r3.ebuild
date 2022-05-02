# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8,9,10} )

# check this on updates
LLVM_MAX_SLOT=14

CMAKE_REMOVE_MODULES_LIST=()

inherit cmake llvm toolchain-funcs python-single-r1

DESCRIPTION="Advanced shading language for production GI renderers"
HOMEPAGE="http://opensource.imageworks.com/?p=osl https://github.com/imageworks/OpenShadingLanguage"
SRC_URI="https://github.com/imageworks/OpenShadingLanguage/archive/Release-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
# TODO: drop .1 on next SONAME change (probably 1.11 -> 1.12), we needed
# a nudge to force rebuilds due to openexr 2 -> openexr 3 change.
SLOT="0/$(ver_cut 2).1"
KEYWORDS="amd64 ~arm ~arm64 ~x86"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

X86_CPU_FEATURES=(
	sse2:sse2 sse3:sse3 ssse3:ssse3 sse4_1:sse4.1 sse4_2:sse4.2
	avx:avx avx2:avx2 avx512f:avx512f f16c:f16c
)
CPU_FEATURES=( ${X86_CPU_FEATURES[@]/#/cpu_flags_x86_} )

IUSE="doc partio qt5 test ${CPU_FEATURES[@]%:*} python"

RDEPEND="
	dev-libs/boost:=
	dev-libs/pugixml
	>=media-libs/openexr-3:0=
	>=dev-libs/imath-3.1.4-r2:=
	>=media-libs/openimageio-2.3.12.0:=
	<sys-devel/clang-$((${LLVM_MAX_SLOT} + 1)):=
	sys-libs/zlib
	partio? ( media-libs/partio )
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-python/pybind11[${PYTHON_USEDEP}]
		')
	)
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig
"

# Restricting tests as Makefile handles them differently
RESTRICT="test"

S="${WORKDIR}/OpenShadingLanguage-Release-${PV}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.11.17.0-llvm14.patch
)

llvm_check_deps() {
	has_version -r "sys-devel/clang:${LLVM_SLOT}"
}

pkg_setup() {
	use python && python-single-r1_pkg_setup
	llvm_pkg_setup
}

src_configure() {
	local cpufeature
	local mysimd=()
	for cpufeature in "${CPU_FEATURES[@]}"; do
		use "${cpufeature%:*}" && mysimd+=("${cpufeature#*:}")
	done

	# If no CPU SIMDs were used, completely disable them
	[[ -z ${mysimd} ]] && mysimd=("0")

	local gcc="$(tc-getCC)"

	local mycmakeargs=(
		# LLVM 10+ needs C++14
		-DCMAKE_CXX_STANDARD=14
		-DCMAKE_INSTALL_DOCDIR="share/doc/${PF}"
		-DINSTALL_DOCS=$(usex doc)
		-DUSE_CCACHE=OFF
		-DLLVM_STATIC=OFF
		-DLLVM_ROOT="$(get_llvm_prefix ${LLVM_MAX_SLOT})"
		# Breaks build for now: bug #827949
		#-DOSL_BUILD_TESTS=$(usex test)
		-DOSL_SHADER_INSTALL_DIR="${EPREFIX}/usr/include/${PN^^}/shaders"
		-DOSL_PTX_INSTALL_DIR="${EPREFIX}/usr/include/${PN^^}/ptx"
		-DSTOP_ON_WARNING=OFF
		-DUSE_PARTIO=$(usex partio)
		-DUSE_QT=$(usex qt5)
		-DUSE_PYTHON=$(usex python)
		-DUSE_SIMD="$(IFS=","; echo "${mysimd[*]}")"
	)

	cmake_src_configure
}
