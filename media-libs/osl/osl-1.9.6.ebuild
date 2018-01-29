# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit cmake-utils

DESCRIPTION="Advanced shading language for production GI renderers"
HOMEPAGE="http://opensource.imageworks.com/?p=osl"

MY_PV=${PV//_} # Remove underscore if any.
[[ "${PV}" = *_rc* ]] && MY_PV=${MY_PV^^} # They use capitals for RC.

SRC_URI="https://github.com/imageworks/OpenShadingLanguage/archive/Release-${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

X86_CPU_FEATURES=(
	sse2:sse2 sse3:sse3 ssse3:ssse3 sse4_1:sse4.1 sse4_2:sse4.2
	avx:avx avx2:avx2 avx512f:avx512f f16c:f16c
)
CPU_FEATURES=( ${X86_CPU_FEATURES[@]/#/cpu_flags_x86_} )

IUSE="doc partio test ${CPU_FEATURES[@]%:*}"

RDEPEND=">=media-libs/openexr-2.2.0
	>=media-libs/openimageio-1.8.0
	dev-libs/pugixml
	sys-libs/zlib:=
	partio? ( media-libs/partio )"

DEPEND="${RDEPEND}
	>=dev-libs/boost-1.62
	sys-devel/clang
	sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig"

# Restricting tests as Make file handles them differently
RESTRICT="test"

S="${WORKDIR}/OpenShadingLanguage-Release-${MY_PV}"

src_configure() {
	local cpufeature
	local mysimd=()
	for cpufeature in "${CPU_FEATURES[@]}"; do
		use "${cpufeature%:*}" && mysimd+=("${cpufeature#*:}")
	done

	# If no CPU SIMDs were used, completely disable them
	[[ -z ${mysimd} ]] && mysimd=("0")

	# LLVM needs CPP11. Do not disable.
	local mycmakeargs=(
		-DLLVM_STATIC=ON
		-DUSE_EXTERNAL_PUGIXML=ON
		-DUSE_PARTIO=$(usex partio)
		-DENABLERTTI=OFF
		-DSTOP_ON_WARNING=OFF
		-DOSL_BUILD_TESTS=$(usex test)
		-DINSTALL_DOCS=$(usex doc)
		-DCMAKE_INSTALL_DOCDIR="share/doc/${PF}"
		-DUSE_SIMD="$(IFS=","; echo "${mysimd[*]}")"
	)

	cmake-utils_src_configure
}
