# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson-multilib usr-ldscript

DESCRIPTION="zstd fast compression library"
HOMEPAGE="https://facebook.github.io/zstd/"
# Drop .gh on next bump (>1.5.4), it's only here as we switched to release
# tarball.
SRC_URI="https://github.com/facebook/zstd/releases/download/v${PV}/${P}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}"/${P}/build/meson

LICENSE="|| ( BSD GPL-2 )"
SLOT="0/1"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
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
	# Allow building tests w/o programs (useful for multilib)
	"${FILESDIR}"/${PN}-1.5.4-tests-no-programs.patch
)

PATCHES=(
	# Fix build w/o zlib, bug #894058
	"${FILESDIR}"/${P}-fix-no-zlib-build.patch
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

multilib_src_install() {
	meson_src_install

	multilib_is_native_abi && gen_usr_ldscript -a zstd
}
