# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit cmake llvm toolchain-funcs

# check this on updates
LLVM_MAX_SLOT=8

DESCRIPTION="Advanced shading language for production GI renderers"
HOMEPAGE="http://opensource.imageworks.com/?p=osl"
SRC_URI="https://github.com/imageworks/OpenShadingLanguage/archive/Release-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

X86_CPU_FEATURES=(
	sse2:sse2 sse3:sse3 ssse3:ssse3 sse4_1:sse4.1 sse4_2:sse4.2
	avx:avx avx2:avx2 avx512f:avx512f f16c:f16c
)
CPU_FEATURES=( ${X86_CPU_FEATURES[@]/#/cpu_flags_x86_} )

IUSE="doc partio qt5 test ${CPU_FEATURES[@]%:*}"

# >=clang-3.4 is needed, but at least llvm:5 if both are installed
RDEPEND="
	>=dev-libs/boost-1.62:=
	dev-libs/pugixml
	>=media-libs/openexr-2.2.0:=
	>=media-libs/openimageio-1.8.5
	>=sys-devel/clang-5:=
	sys-libs/zlib:=
	partio? ( media-libs/partio )
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

PATCHES=(
	"${FILESDIR}/${P}-upstream-patch-to-find-openexr-version.patch"
	"${FILESDIR}/${P}-fix-install-shaders.patch"
)

# Restricting tests as Make file handles them differently
RESTRICT="test"

S="${WORKDIR}/OpenShadingLanguage-Release-${PV}"

llvm_check_deps() {
	has_version  -r "sys-devel/clang:${LLVM_SLOT}"
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
	# LLVM needs CPP11. Do not disable.
	local mycmakeargs=(
		-DENABLERTTI=OFF
		-DINSTALL_DOCS=$(usex doc)
		-DLLVM_STATIC=ON
		-DOSL_BUILD_TESTS=$(usex test)
		-DSTOP_ON_WARNING=OFF
		-DUSE_PARTIO=$(usex partio)
		-DUSE_QT=$(usex qt5)
		-DUSE_SIMD="$(IFS=","; echo "${mysimd[*]}")"
	)

	cmake_src_configure
}
