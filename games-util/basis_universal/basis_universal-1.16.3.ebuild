# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake toolchain-funcs

DESCRIPTION="Basis Universal GPU Texture Codec"
HOMEPAGE="https://github.com/BinomialLLC/basis_universal"
# dist .zip is just a exe for windows
SRC_URI="https://github.com/BinomialLLC/basis_universal/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 zstd? ( BSD )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cpu_flags_x86_sse4_1 opencl zstd"

# zstd is bundled, see https://github.com/BinomialLLC/basis_universal/pull/228
DEPEND="
	opencl? ( virtual/opencl )
"
RDEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.16.3-respect-CFLAGS.patch
	"${FILESDIR}"/${PN}-1.16.3-fix-RPATH.patch
	"${FILESDIR}"/${PN}-1.16.3-SSE4.1-AVX-checks.patch
)

src_configure() {
	local x64=ON
	if $(tc-getCC) -dM -E  -x c - < <(echo 'int main() { }') | grep -qi "#define __PTRDIFF_WIDTH__ 32" ; then
		x64=OFF
	fi

	local mycmakeargs=(
		-DBUILD_X64=${x64}
		-DOPENCL=$(usex opencl)
		-DSSE=$(usex cpu_flags_x86_sse4_1)
		-DZSTD=$(usex zstd)
	)

	cmake_src_configure
}
