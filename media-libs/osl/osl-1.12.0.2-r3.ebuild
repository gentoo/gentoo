# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8,9,10} )

# check this on updates
LLVM_MAX_SLOT=12

inherit cmake llvm toolchain-funcs python-single-r1

DESCRIPTION="Advanced shading language for production GI renderers"
HOMEPAGE="http://opensource.imageworks.com/?p=osl"
SRC_URI="https://github.com/imageworks/OpenShadingLanguage/archive/Release-${PV}-dev.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

X86_CPU_FEATURES=(
	sse2:sse2 sse3:sse3 ssse3:ssse3 sse4_1:sse4.1 sse4_2:sse4.2
	avx:avx avx2:avx2 avx512f:avx512f f16c:f16c
)
CPU_FEATURES=( ${X86_CPU_FEATURES[@]/#/cpu_flags_x86_} )

IUSE="doc partio qt5 test ${CPU_FEATURES[@]%:*} python"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# See bug #821202 for openimageio < dep
RDEPEND="
	dev-libs/boost:=
	dev-libs/pugixml
	media-libs/openexr:=
	<media-libs/openimageio-2.3:=
	<sys-devel/clang-$((${LLVM_MAX_SLOT} + 1)):=
	sys-libs/zlib:=
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-python/pybind11[${PYTHON_USEDEP}]
		')
	)
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
	${FILESDIR}/${P}-llvm-11.patch
	${FILESDIR}/${P}-llvm-12.patch
)

# Restricting tests as Makefile handles them differently
RESTRICT="test"

S="${WORKDIR}/OpenShadingLanguage-Release-${PV}-dev"

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

	local gcc=$(tc-getCC)
	# LLVM needs CPP11. Do not disable.
	local mycmakeargs=(
		-DCMAKE_CXX_STANDARD=14
		-DCMAKE_INSTALL_DOCDIR="share/doc/${PF}"
		-DINSTALL_DOCS=$(usex doc)
		-DUSE_CCACHE=OFF
		-DLLVM_STATIC=OFF
		-DOSL_BUILD_TESTS=$(usex test)
		-DSTOP_ON_WARNING=OFF
		-DUSE_PARTIO=$(usex partio)
		-DUSE_QT=$(usex qt5)
		-DUSE_PYTHON=$(usex python)
		-DUSE_SIMD="$(IFS=","; echo "${mysimd[*]}")"
	)

	cmake_src_configure
}
