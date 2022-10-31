# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}"/usr/share/openpgp-keys/gnupg.asc
inherit autotools flag-o-matic multilib-minimal toolchain-funcs verify-sig

DESCRIPTION="General purpose crypto library based on the code used in GnuPG"
HOMEPAGE="https://www.gnupg.org/"
SRC_URI="mirror://gnupg/${PN}/${P}.tar.bz2"
SRC_URI+=" verify-sig? ( mirror://gnupg/${PN}/${P}.tar.bz2.sig )"

LICENSE="LGPL-2.1 MIT"
SLOT="0/20" # subslot = soname major version
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="+asm cpu_flags_arm_neon cpu_flags_arm_aes cpu_flags_arm_sha1 cpu_flags_arm_sha2 cpu_flags_ppc_altivec cpu_flags_ppc_vsx2 cpu_flags_ppc_vsx3 cpu_flags_x86_aes cpu_flags_x86_avx cpu_flags_x86_avx2 cpu_flags_x86_padlock cpu_flags_x86_sha cpu_flags_x86_sse4_1 doc static-libs"

# Build system only has --disable-arm-crypto-support right now
# If changing this, update src_configure logic too.
# ARM CPUs seem to, right now, support all-or-nothing for crypto extensions,
# but this looks like it might change in future. This is just a safety check
# in case people somehow do have a CPU which only supports some. They must
# for now disable them all if that's the case.
REQUIRED_USE="
	cpu_flags_arm_aes? ( cpu_flags_arm_sha1 cpu_flags_arm_sha2 )
	cpu_flags_arm_sha1? ( cpu_flags_arm_aes cpu_flags_arm_sha2 )
	cpu_flags_arm_sha2? ( cpu_flags_arm_aes cpu_flags_arm_sha1 )
	cpu_flags_ppc_vsx3? ( cpu_flags_ppc_altivec cpu_flags_ppc_vsx2 )
	cpu_flags_ppc_vsx2? ( cpu_flags_ppc_altivec )
"

RDEPEND=">=dev-libs/libgpg-error-1.25[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
BDEPEND="doc? ( virtual/texi2dvi )
	verify-sig? ( sec-keys/openpgp-keys-gnupg )"

PATCHES=(
	"${FILESDIR}"/${PN}-multilib-syspath.patch
	"${FILESDIR}"/${PN}-powerpc-darwin.patch
	"${FILESDIR}"/${PN}-1.10.1-fix-no-asm-hppa.patch
	"${FILESDIR}"/${PN}-1.9.4-no-fgrep-libgcrypt-config.patch
)

MULTILIB_CHOST_TOOLS=(
	/usr/bin/libgcrypt-config
)

src_prepare() {
	default
	eautoreconf
}

multilib_src_configure() {
	if [[ ${CHOST} == *86*-solaris* ]] ; then
		# ASM code uses GNU ELF syntax, divide in particular, we need to
		# allow this via ASFLAGS, since we don't have a flag-o-matic
		# function for that, we'll have to abuse cflags for this
		append-cflags -Wa,--divide
	fi

	if [[ ${CHOST} == powerpc* ]] ; then
		# ./configure does a lot of automagic, prevent that
		# generic ppc32+ppc64 altivec
		use cpu_flags_ppc_altivec || local -x gcry_cv_cc_ppc_altivec=no
		use cpu_flags_ppc_altivec || local -x gcry_cv_cc_ppc_altivec_cflags=no
		# power8 vector extension, aka arch 2.07 ISA, also checked below via ppc-crypto-support
		use cpu_flags_ppc_vsx2 || local -x gcry_cv_gcc_inline_asm_ppc_altivec=no
		# power9 vector extension, aka arch 3.00 ISA
		use cpu_flags_ppc_vsx3 || local -x gcry_cv_gcc_inline_asm_ppc_arch_3_00=no
	fi

	# Workaround for GCC < 11.3 bug
	# https://git.gnupg.org/cgi-bin/gitweb.cgi?p=libgcrypt.git;a=commitdiff;h=0b399721ce9709ae25f9d2050360c5ab2115ae29
	# https://dev.gnupg.org/T5581
	# https://gcc.gnu.org/bugzilla/show_bug.cgi?id=102124
	if use arm64 && tc-is-gcc && (($(gcc-major-version) == 11)) && (($(gcc-minor-version) <= 2)) && (($(gcc-micro-version) == 0)) ; then
		append-flags -fno-tree-loop-vectorize
	fi

	local myeconfargs=(
		CC_FOR_BUILD="$(tc-getBUILD_CC)"

		--enable-noexecstack
		$(use_enable cpu_flags_arm_neon neon-support)
		# See REQUIRED_USE comment above
		$(use_enable cpu_flags_arm_aes arm-crypto-support)
		$(use_enable cpu_flags_ppc_vsx2 ppc-crypto-support)
		$(use_enable cpu_flags_x86_aes aesni-support)
		$(use_enable cpu_flags_x86_avx avx-support)
		$(use_enable cpu_flags_x86_avx2 avx2-support)
		$(use_enable cpu_flags_x86_padlock padlock-support)
		$(use_enable cpu_flags_x86_sha shaext-support)
		$(use_enable cpu_flags_x86_sse4_1 sse41-support)
		# required for sys-power/suspend[crypt], bug 751568
		$(use_enable static-libs static)

		# disabled due to various applications requiring privileges
		# after libgcrypt drops them (bug #468616)
		--without-capabilities

		# http://trac.videolan.org/vlc/ticket/620
		$([[ ${CHOST} == *86*-darwin* ]] && echo "--disable-asm")
		# causes bus-errors on sparc64-solaris
		$([[ ${CHOST} == sparcv9-*-solaris* ]] && echo "--disable-asm")

		$(use asm || echo "--disable-asm")

		GPG_ERROR_CONFIG="${ESYSROOT}/usr/bin/${CHOST}-gpg-error-config"
	)

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}" \
		$("${S}/configure" --help | grep -o -- '--without-.*-prefix')
}

multilib_src_compile() {
	default
	multilib_is_native_abi && use doc && VARTEXFONTS="${T}/fonts" emake -C doc gcrypt.pdf
}

multilib_src_install() {
	emake DESTDIR="${D}" install
	multilib_is_native_abi && use doc && dodoc doc/gcrypt.pdf
}

multilib_src_install_all() {
	default
	find "${ED}" -type f -name '*.la' -delete || die
}
