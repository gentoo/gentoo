# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils llvm

LLVM_MAX_SLOT=8
MY_PV="${PV//_p/-}"

DESCRIPTION="A tool and a library for bi-directional translation between SPIR-V and LLVM IR"
HOMEPAGE="https://github.com/KhronosGroup/SPIRV-LLVM-Translator"
SRC_URI="https://github.com/KhronosGroup/SPIRV-LLVM-Translator/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="UoI-NCSA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="tools"

DEPEND=">=sys-devel/clang-8.0.0-r1:8"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/0001-Update-LowerOpenCL-pass-to-handle-new-blocks-represn.patch"
	)

S="${WORKDIR}/SPIRV-LLVM-Translator-${MY_PV}"

src_configure() {
	local mycmakeargs=(
		-DBUILD_EXTERNAL=ON
		-DCCACHE_EXE_FOUND=OFF  # disable explicit ccache usage
		-DBUILD_SHARED_LIBS=ON
		-DLLVM_BUILD_TOOLS=$(usex tools)
		-DLLVM_DIR="$(get_llvm_prefix)/$(get_libdir)/cmake/llvm"
	)

	cmake-utils_src_configure
}
