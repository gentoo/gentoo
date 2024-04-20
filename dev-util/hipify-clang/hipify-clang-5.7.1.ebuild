# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="A set of tools to translate CUDA source code into portable HIP C++"
HOMEPAGE="https://github.com/ROCm-Developer-Tools/HIPIFY"
SRC_URI="https://github.com/ROCm-Developer-Tools/HIPIFY/archive/rocm-${PV}.tar.gz -> HIPIFY-${PV}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0/$(ver_cut 1-2)"

BDEPEND=">=dev-build/cmake-3.22"
DEPEND="
	sys-devel/clang:17
	sys-devel/llvm:17"

S="${WORKDIR}/HIPIFY-rocm-${PV}"

PATCHES=(
	"${FILESDIR}/${PN}-5.7.1-fix-clang-libs.patch"
)

src_prepare() {
	cmake_src_prepare
	sed -i 's:/../libexec/hipify::' \
		bin/hipconvertinplace.sh bin/hipconvertinplace-perl.sh \
		bin/hipexamine-perl.sh bin/hipexamine.sh || die
	# Workaround for bug https://github.com/ROCm/HIPIFY/issues/1396
	sed -i 's/find_package(LLVM REQUIRED/find_package(LLVM 17 REQUIRED/' CMakeLists.txt || die
}

src_install() {
	cmake_src_install

	# rm unwanted copy
	rm -rf "${ED}/usr/hip" || die
}
