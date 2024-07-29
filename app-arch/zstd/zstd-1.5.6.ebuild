# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic meson-multilib

DESCRIPTION="zstd fast compression library"
HOMEPAGE="https://facebook.github.io/zstd/"
SRC_URI="https://github.com/facebook/zstd/releases/download/v${PV}/${P}.tar.gz"
S="${WORKDIR}"/${P}/build/meson

LICENSE="|| ( BSD GPL-2 )"
SLOT="0/1"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="+lzma lz4 static-libs test zlib"
RESTRICT="!test? ( test )"

RDEPEND="
	lzma? ( app-arch/xz-utils )
	lz4? ( app-arch/lz4:= )
	zlib? ( sys-libs/zlib )
"
DEPEND="${RDEPEND}"

MESON_PATCHES=(
	# Workaround until Valgrind bugfix lands
	"${FILESDIR}"/${PN}-1.5.4-no-find-valgrind.patch
)

PATCHES=(
)

src_prepare() {
	cd "${WORKDIR}"/${P} || die
	default

	cd "${S}" || die
	eapply "${MESON_PATCHES[@]}"
}

multilib_src_configure() {
	local native_file="${T}"/meson.${CHOST}.${ABI}.ini.local

	# This replaces the no-find-valgrind patch once bugfix lands in a meson
	# release + we can BDEPEND on it (https://github.com/mesonbuild/meson/pull/11372)
	cat >> ${native_file} <<-EOF || die
	[binaries]
	valgrind='valgrind-falseified'
	EOF

	# Test suite validates that stack is not executable.  Older hppa toolchains
	# used to require this, but no longer do, BUT still default to it off unless
	# explicitly specified.  See #903923
	# The cmake build sets these, but the meson build doesn't, so set it manually.
	# https://github.com/facebook/zstd/blob/979b047/build/cmake/CMakeModules/AddZstdCompilationFlags.cmake#L77-L82
	append-flags $(test-flags-CCLD "-Wa,--noexecstack")
	append-ldflags $(test-flags-CCLD "-Wl,-z,noexecstack")

	local emesonargs=(
		-Ddefault_library=$(multilib_native_usex static-libs both shared)

		$(meson_native_true bin_programs)
		$(meson_native_true bin_contrib)
		$(meson_use test bin_tests)

		$(meson_native_use_feature zlib)
		$(meson_native_use_feature lzma)
		$(meson_native_use_feature lz4)

		--native-file "${native_file}"
	)

	meson_src_configure
}

multilib_src_test() {
	meson_src_test --timeout-multiplier=2
}
