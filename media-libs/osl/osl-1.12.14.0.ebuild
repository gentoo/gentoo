# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )

# Check this on updates
LLVM_MAX_SLOT=15

inherit cmake flag-o-matic llvm toolchain-funcs python-single-r1

DESCRIPTION="Advanced shading language for production GI renderers"
HOMEPAGE="https://www.imageworks.com/technology/opensource https://github.com/AcademySoftwareFoundation/OpenShadingLanguage"
# If a development release, please don't keyword!
SRC_URI="https://github.com/AcademySoftwareFoundation/OpenShadingLanguage/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/OpenShadingLanguage-${PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64"

X86_CPU_FEATURES=(
	sse2:sse2 sse3:sse3 ssse3:ssse3 sse4_1:sse4.1 sse4_2:sse4.2
	avx:avx avx2:avx2 avx512f:avx512f f16c:f16c
)
CPU_FEATURES=( ${X86_CPU_FEATURES[@]/#/cpu_flags_x86_} )

IUSE="debug doc gui partio qt6 test ${CPU_FEATURES[@]%:*} python"
RESTRICT="!test? ( test )"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	dev-libs/boost:=
	dev-libs/pugixml
	>=media-libs/openexr-3:0=
	>=media-libs/openimageio-2.3.12.0:=
	<sys-devel/clang-$((${LLVM_MAX_SLOT} + 1)):=
	sys-libs/zlib:=
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-python/pybind11[${PYTHON_USEDEP}]
		')
	)
	partio? ( media-libs/partio )
	gui? (
		!qt6? (
			dev-qt/qtcore:5
			dev-qt/qtgui:5
			dev-qt/qtwidgets:5
		)
		qt6? (
			dev-qt/qtbase:6[gui,widgets]
		)
	)
"

DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig
"

llvm_check_deps() {
	has_version -r "sys-devel/clang:${LLVM_SLOT}"
}

pkg_setup() {
	llvm_pkg_setup

	use python && python-single-r1_pkg_setup
}

src_configure() {
	# -Werror=lto-type-mismatch
	# https://bugs.gentoo.org/875836
	# https://github.com/AcademySoftwareFoundation/OpenShadingLanguage/issues/1810
	filter-lto

	local cpufeature
	local mysimd=()
	for cpufeature in "${CPU_FEATURES[@]}"; do
		use "${cpufeature%:*}" && mysimd+=("${cpufeature#*:}")
	done

	local mybatched=()
	use cpu_flags_x86_avx && mybatched+=(
		"b8_AVX"
	)
	use cpu_flags_x86_avx2 && mybatched+=(
		"b8_AVX2"
		"b8_AVX2_noFMA"
	)
	use cpu_flags_x86_avx512f && mybatched+=(
		"b8_AVX512"
		"b8_AVX512_noFMA"
		"b16_AVX512"
		"b16_AVX512_noFMA"
	)

	# If no CPU SIMDs were used, completely disable them
	[[ -z ${mysimd} ]] && mysimd=("0")
	[[ -z ${mybatched} ]] && mybatched=("0")

	# This is currently needed on arm64 to get the NEON SIMD wrapper to compile the code successfully
	# Even if there are no SIMD features selected, it seems like the code will turn on NEON support if it is available.
	use arm64 && append-flags -flax-vector-conversions

	local gcc="$(tc-getCC)"
	local mycmakeargs=(
		# std::tuple_size_v is c++17
		-DCMAKE_CXX_STANDARD=17
		-DDOWNSTREAM_CXX_STANDARD=17
		-DCMAKE_INSTALL_DOCDIR="share/doc/${PF}"
		-DINSTALL_DOCS=$(usex doc)
		-DUSE_CCACHE=OFF
		-DLLVM_STATIC=OFF
		-DOSL_BUILD_TESTS=$(usex test)
		-DSTOP_ON_WARNING=OFF
		-DUSE_PARTIO=$(usex partio)
		-DUSE_PYTHON=$(usex python)
		-DPYTHON_VERSION="${EPYTHON/python}"
		-DUSE_SIMD="$(IFS=","; echo "${mysimd[*]}")"
		-DUSE_BATCHED="$(IFS=","; echo "${mybatched[*]}")"
	)

	if use debug; then
		mycmakeargs+=(
			-DVEC_REPORT="yes"
		)
	fi

	if use gui; then
		mycmakeargs+=( -DUSE_QT=yes )
		if ! use qt6; then
			mycmakeargs+=( -DCMAKE_DISABLE_FIND_PACKAGE_Qt6=ON )
		fi
	else
		mycmakeargs+=( -DUSE_QT=no )
	fi

	cmake_src_configure
}

src_test() {
	# TODO: investigate failures
	local myctestargs=(
		-E "(osl-imageio|osl-imageio.opt|render-background|render-bumptest|render-mx-furnace-burley-diffuse|render-mx-furnace-sheen|render-mx-burley-diffuse|render-mx-conductor|render-mx-generalized-schlick|render-mx-generalized-schlick-glass|render-microfacet|render-oren-nayar|render-uv|render-veachmis|render-ward|render-raytypes.opt|color|color.opt|example-deformer)"
	)

	cmake_src_test
}
