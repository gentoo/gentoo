# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dot-a meson-multilib toolchain-funcs

DESCRIPTION="Lean cryptographic library usable for bare-metal environments "
HOMEPAGE="https://leancrypto.org/"

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/smuellerDD/leancrypto"
	inherit git-r3
else
	VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/leancrypto.asc
	inherit verify-sig

	SRC_URI="
		https://leancrypto.org/leancrypto/releases/${P}/${P}.tar.xz
		verify-sig? ( https://leancrypto.org/leancrypto/releases/${P}/${P}.tar.xz.asc )
	"

	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~m68k ~ppc ppc64 ~riscv ~s390 ~sparc x86"

	BDEPEND="
		verify-sig? ( sec-keys/openpgp-keys-leancrypto )
	"
fi

LICENSE="|| ( GPL-2 BSD-2 )"
SLOT="0/1"
IUSE="+asm test tools"
RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}"/${PN}-1.6.0-no-force-lto.patch
	"${FILESDIR}"/${PN}-1.7.2-toolchain-hardening.patch
	"${FILESDIR}"/${P}-gcc-16-asm.patch
)

src_configure() {
	use asm && MULTILIB_WRAPPED_HEADERS=(
		# internal/api/meson.build modifies lc_memory_support
		# based on asm support (bug #970513). Sort order here
		# snakes out from that header.
		/usr/include/leancrypto/lc_memory_support.h
		/usr/include/leancrypto/ext_headers.h

		# Another root (LC_HASH_COMMON_ALIGNMENT)
		/usr/include/leancrypto/lc_hash.h
		/usr/include/leancrypto/lc_memset_secure.h
		/usr/include/leancrypto/lc_status.h

		# Another root (LC_DEF_ASCON_AVX512)
		/usr/include/leancrypto/lc_ascon_hash.h
	)

	lto-guarantee-fat
	meson-multilib_src_configure
}

multilib_src_configure() {
	tc-ld-is-mold && tc-ld-force-bfd

	local native_file="${T}"/meson.${CHOST}.${ABI}.ini.local
	cat >> ${native_file} <<-EOF || die
	[binaries]
	doxygen='doxygen-falseified'
	EOF

	local emesonargs=(
		-Dstrip=false
		$(meson_use !asm disable-asm)
		$(meson_feature test tests)
		$(meson_native_use_feature tools apps)
	)

	if multilib_is_native_abi ; then
		emesonargs+=( --native-file "${native_file}" )
	else
		emesonargs+=( --cross-file "${native_file}" )
	fi

	meson_src_configure
}

multilib_src_test() {
	# Only run the regression tests rather than the performance ones
	meson_src_test --timeout-multiplier=16 --suite=regression
}

multilib_src_install_all() {
	strip-lto-bytecode
	einstalldocs
}
