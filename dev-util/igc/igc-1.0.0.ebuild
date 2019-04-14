# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

CLANG_VERSION=8

DESCRIPTION="LLVM based compiler for OpenCL targeting Intel Gen8+ graphics hardware"
HOMEPAGE="http://01.org/compute-runtime https://github.com/intel/intel-graphics-compiler"
SRC_URI="https://github.com/intel/intel-graphics-compiler/archive/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# depend only on opencl-clang to pull-in spirv-llvm-translator, clang, llvm
DEPEND="=dev-libs/opencl-clang-8*"
RDEPEND="${DEPEND}"
BDEPEND=""

PATCHES=(
	"${FILESDIR}/${P}-fix-undefined-references.patch"
	)

S="${WORKDIR}/intel-graphics-compiler-igc-${PV}"

src_configure() {
	local mycmakeargs=(
		-DIGC_PREFERRED_LLVM_VERSION="${CLANG_VERSION}"
		-DLLVM_DIR="${EPREFIX}/usr/$(get_libdir)/llvm/${CLANG_VERSION}/$(get_libdir)/cmake/llvm"
	)

	cmake-utils_src_configure
}
