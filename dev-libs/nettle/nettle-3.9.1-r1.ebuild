# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/nettle.asc
inherit multilib-build multilib-minimal toolchain-funcs verify-sig

DESCRIPTION="Low-level cryptographic library"
HOMEPAGE="https://www.lysator.liu.se/~nisse/nettle/ https://git.lysator.liu.se/nettle/nettle"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"
SRC_URI+=" verify-sig? ( mirror://gnu/${PN}/${P}.tar.gz.sig )"

LICENSE="|| ( LGPL-3 LGPL-2.1 )"
# Subslot = libnettle - libhogweed soname version
SLOT="0/8-6"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="+asm doc +gmp static-libs cpu_flags_arm_neon cpu_flags_arm_aes cpu_flags_arm_sha1 cpu_flags_arm_sha2 cpu_flags_ppc_altivec cpu_flags_ppc_vsx2 cpu_flags_ppc_vsx3 cpu_flags_x86_aes cpu_flags_x86_sha cpu_flags_x86_pclmul"
# The arm64 crypto option controls AES, SHA1, and SHA2 usage.
REQUIRED_USE="
	cpu_flags_arm_aes? ( cpu_flags_arm_sha1 cpu_flags_arm_sha2 )
	cpu_flags_arm_sha1? ( cpu_flags_arm_aes cpu_flags_arm_sha2 )
	cpu_flags_arm_sha2? ( cpu_flags_arm_aes cpu_flags_arm_sha1 )
"

DEPEND="gmp? ( >=dev-libs/gmp-6.1:=[static-libs?,${MULTILIB_USEDEP}] )"
RDEPEND="${DEPEND}"
BDEPEND="
	sys-devel/m4
	doc? ( sys-apps/texinfo )
	verify-sig? ( sec-keys/openpgp-keys-nettle )
"

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/nettle/version.h
)

DOCS=()
HTML_DOCS=()

src_prepare() {
	default

	# I do not see in config.sub reference to sunldsolaris.
	# if someone complains readd
	# -e 's/solaris\*)/sunldsolaris*)/' \
	sed -e '/CFLAGS=/s: -ggdb3::' \
		-i configure.ac configure || die

	if use doc ; then
		DOCS+=( nettle.pdf )
		HTML_DOCS+=( nettle.html )
	fi
}

multilib_src_configure() {
	local myeconfargs=(
		CC_FOR_BUILD="$(tc-getBUILD_CC)"

		$(tc-is-static-only && echo --disable-shared)

		# Intrinsics
		$(use_enable cpu_flags_arm_neon arm-neon)
		$(use_enable cpu_flags_arm_aes arm64-crypto)
		$(use_enable cpu_flags_ppc_altivec power-altivec)
		$(use_enable cpu_flags_ppc_vsx2 power-crypto-ext)
		$(use_enable cpu_flags_ppc_vsx3 power9)
		$(use_enable cpu_flags_x86_aes x86-aesni)
		$(use_enable cpu_flags_x86_sha x86-sha-ni)
		$(use_enable cpu_flags_x86_pclmul x86-pclmul)
		$([[ ${CHOST} == *-solaris* ]] && echo '--disable-symbol-versions')
		# TODO: cpu_flags_s390?
		--disable-s390x-vf
		--disable-s390x-msa

		$(use_enable asm assembler)
		$(multilib_native_use_enable doc documentation)
		$(use_enable gmp public-key)
		$(use_enable static-libs static)
		--disable-fat

		# openssl is just used for benchmarks (bug #427526)
		--disable-openssl
	)

	# https://git.lysator.liu.se/nettle/nettle/-/issues/7
	if use cpu_flags_ppc_altivec && ! tc-cpp-is-true "defined(__VSX__) && __VSX__ == 1" ${CPPFLAGS} ${CFLAGS} ; then
		ewarn "cpu_flags_ppc_altivec is enabled, but nettle's asm requires >=P7."
		ewarn "Disabling, sorry! See bug #920234."
		myeconfargs+=( --disable-power-altivec )
	fi

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}
