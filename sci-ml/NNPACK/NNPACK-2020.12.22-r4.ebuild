# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
inherit cmake python-single-r1

CommitId=c07e3a0400713d546e0dea2d5466dd22ea389c73

DESCRIPTION="acceleration package for neural network computations"
HOMEPAGE="https://github.com/Maratyszcza/NNPACK/"
SRC_URI="https://github.com/Maratyszcza/${PN}/archive/${CommitId}.tar.gz
	-> ${P}.tar.gz"

S="${WORKDIR}"/${PN}-${CommitId}

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test test-full"
RESTRICT="!test? ( test )"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	dev-libs/pthreadpool
	dev-libs/cpuinfo
	$(python_gen_cond_dep '
		~sci-ml/FP16-2024.05.27[${PYTHON_USEDEP}]
		dev-python/peachpy[${PYTHON_USEDEP}]
	')
"
DEPEND="${RDEPEND}
	dev-libs/FXdiv
	dev-libs/psimd
"
BDEPEND="
	${RDEPEND}
	test? ( dev-cpp/gtest )
"

PATCHES=(
	"${FILESDIR}"/${P}-gentoo.patch
	"${FILESDIR}"/${P}-cmake.patch
)

src_prepare() {
	sed -i \
		-e "/-O/d" \
		-e "s:CXX_STANDARD 11:CXX_STANDARD 14:" \
		CMakeLists.txt || die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DNNPACK_BUILD_TESTS=$(usex test ON OFF)
	)
	cmake_src_configure
}

src_test() {
	local CMAKE_SKIP_TESTS=()
	use x86 && CMAKE_SKIP_TESTS+=(
		softmax-output-smoketest
		softmax-output-imagenet
	)
	use test-full || CMAKE_SKIP_TESTS+=(
		convolution-output-overfeat
		convolution-kernel-gradient-vgg
		convolution-input-gradient-overfeat
		convolution-input-gradient-vgg
		convolution-output-vgg
	)
	cmake_src_test
}
