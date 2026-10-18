# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_COMPAT=( 23 )

inherit cmake flag-o-matic llvm-r2

DESCRIPTION="A set of tools to translate CUDA source code into portable HIP C++"
HOMEPAGE="https://github.com/ROCm/HIPIFY"
SRC_URI="https://github.com/ROCm/HIPIFY/archive/therock-${PV%.0}.tar.gz -> HIPIFY-${PV}.tar.gz"
S="${WORKDIR}/HIPIFY-therock-${PV%.0}"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"

DEPEND="
	$(llvm_gen_dep "
		llvm-core/clang:\${LLVM_SLOT}=
		llvm-core/llvm:\${LLVM_SLOT}=
	")
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-7.0.1-fix-clang-libs.patch"
)

src_prepare() {
	cmake_src_prepare

	# Set clang resource prefix to /usr/lib/clang/...
	sed -i 's:/lib/llvm/lib/clang/:/lib/clang/:' src/main.cpp || die

	# do not dereference an empty OptionalFileEntryRef for headers that are not found
	sed -e 's/auto f = &file->getFileEntry();/auto f = file ? \&file->getFileEntry() : nullptr;/' \
		-i src/HipifyAction.cpp || die

	# libc++ does not include <vector> transitively
	sed -e "/#include <list>/a #include <vector>" -i src/Statistics.h || die
}

src_configure() {
	# 928906: CMakeLists.txt ignores CC/CXX, switches compiler to clang
	# and fails if non-compatible CFLAGS/CXXFLAGS are used
	strip-unsupported-flags

	local mycmakeargs=(
		-DCMAKE_PREFIX_PATH="$(get_llvm_prefix)/$(get_libdir)/cmake/llvm"
	)

	cmake_src_configure
}
