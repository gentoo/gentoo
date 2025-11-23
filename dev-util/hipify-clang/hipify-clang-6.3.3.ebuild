# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_COMPAT=( 19 )

inherit cmake flag-o-matic llvm-r1

DESCRIPTION="A set of tools to translate CUDA source code into portable HIP C++"
HOMEPAGE="https://github.com/ROCm/HIPIFY"
SRC_URI="https://github.com/ROCm/HIPIFY/archive/rocm-${PV}.tar.gz -> HIPIFY-${PV}.tar.gz"
S="${WORKDIR}/HIPIFY-rocm-${PV}"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"

BDEPEND=">=dev-build/cmake-3.22"
DEPEND="
	$(llvm_gen_dep '
		llvm-core/clang:${LLVM_SLOT}=
		llvm-core/llvm:${LLVM_SLOT}=
	')
"

PATCHES=(
	"${FILESDIR}/${PN}-5.7.1-fix-clang-libs.patch"
)

src_prepare() {
	cmake_src_prepare
	sed -i 's:/../libexec/hipify::' \
		bin/hipconvertinplace.sh bin/hipconvertinplace-perl.sh \
		bin/hipexamine-perl.sh bin/hipexamine.sh || die
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

src_install() {
	cmake_src_install

	fperms +x /usr/bin/hipconvertinplace-perl.sh
	fperms +x /usr/bin/hipconvertinplace.sh
	fperms +x /usr/bin/hipexamine-perl.sh
	fperms +x /usr/bin/hipexamine.sh
	fperms +x /usr/bin/hipify-perl
}
