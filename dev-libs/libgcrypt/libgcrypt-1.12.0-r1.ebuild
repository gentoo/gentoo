# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/gnupg.asc
inherit autotools flag-o-matic linux-info multilib-minimal toolchain-funcs verify-sig

DESCRIPTION="General purpose crypto library based on the code used in GnuPG"
HOMEPAGE="https://www.gnupg.org/"
SRC_URI="mirror://gnupg/${PN}/${P}.tar.bz2"
SRC_URI+=" verify-sig? ( mirror://gnupg/${PN}/${P}.tar.bz2.sig )"

LICENSE="LGPL-2.1+ GPL-2+ MIT"
SLOT="0/20" # subslot = soname major version
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos ~x64-macos ~x64-solaris"
IUSE="+asm doc +getentropy static-libs"
IUSE+=" cpu_flags_arm_neon cpu_flags_arm_aes cpu_flags_arm_sha1 cpu_flags_arm_sha2 cpu_flags_arm_sve"
IUSE+=" cpu_flags_ppc_altivec cpu_flags_ppc_vsx2 cpu_flags_ppc_vsx3"
IUSE+=" cpu_flags_x86_aes cpu_flags_x86_avx cpu_flags_x86_avx2 cpu_flags_x86_avx512f cpu_flags_x86_padlock cpu_flags_x86_sha cpu_flags_x86_sse4_1"

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

RDEPEND="
	>=dev-libs/libgpg-error-1.56[${MULTILIB_USEDEP}]
	getentropy? (
		kernel_linux? (
			elibc_glibc? ( >=sys-libs/glibc-2.25 )
			elibc_musl? ( >=sys-libs/musl-1.1.20 )
		)
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	doc? ( virtual/texi2dvi )
	verify-sig? ( sec-keys/openpgp-keys-gnupg )
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.12.0-multilib-syspath.patch
	"${FILESDIR}"/${PN}-powerpc-darwin.patch
)

MULTILIB_CHOST_TOOLS=(
	/usr/bin/libgcrypt-config
)

pkg_pretend() {
	if [[ ${MERGE_TYPE} == buildonly ]]; then
		return
	fi
	if use kernel_linux && use getentropy; then
		unset KV_FULL
		get_running_version
		if [[ -n ${KV_FULL} ]] && kernel_is -lt 3 17; then
			eerror "The getentropy function requires the getrandom syscall."
			eerror "This was introduced in Linux 3.17."
			eerror "Your system is currently running Linux ${KV_FULL}."
			eerror "Disable the 'getentropy' USE flag or upgrade your kernel."
			die "Kernel is too old for getentropy"
		fi
	fi
}

pkg_setup() {
	:
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# Temporary workaround for a build failure (known gcc issue):
	#  * https://bugs.gentoo.org/956605
	#  * https://gcc.gnu.org/PR110812
	use riscv && filter-lto

	# Temporary workaround for mfpmath=sse on x86 causing issues when -msse is
	# stripped as it's not clear cut on how to handle in flag-o-matic we can at
	# least solve it the ebuild see https://bugs.gentoo.org/959349
	use x86 && filter-flags -mfpmath=sse

	# Hardcodes the path to FGREP in libgcrypt-config
	export ac_cv_path_SED="sed"
	export ac_cv_path_EGREP="grep -E"
	export ac_cv_path_EGREP_TRADITIONAL="grep -E"
	export ac_cv_path_FGREP="grep -F"
	export ac_cv_path_GREP="grep"

	multilib-minimal_src_configure
}

multilib_src_configure() {
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

	append-ldflags $(test-flags-CCLD -Wl,--undefined-version)

	local myeconfargs=(
		CC_FOR_BUILD="$(tc-getBUILD_CC)"

		--enable-noexecstack
		$(use_enable cpu_flags_arm_neon neon-support)
		# See REQUIRED_USE comment above
		$(use_enable cpu_flags_arm_aes arm-crypto-support)
		$(use_enable cpu_flags_arm_sve sve-support)
		$(use_enable cpu_flags_ppc_vsx2 ppc-crypto-support)
		$(use_enable cpu_flags_x86_aes aesni-support)
		$(use_enable cpu_flags_x86_avx avx-support)
		$(use_enable cpu_flags_x86_avx2 avx2-support)
		$(use_enable cpu_flags_x86_avx512f avx512-support)
		$(use_enable cpu_flags_x86_padlock padlock-support)
		$(use_enable cpu_flags_x86_sha shaext-support)
		$(use_enable cpu_flags_x86_sse4_1 sse41-support)
		# required for sys-power/suspend[crypt], bug 751568
		$(use_enable static-libs static)

		# disabled due to various applications requiring privileges
		# after libgcrypt drops them (bug #468616)
		--without-capabilities

		$(use asm || echo "--disable-asm")

		GPG_ERROR_CONFIG="${ESYSROOT}/usr/bin/${CHOST}-gpg-error-config"
		GPGRT_CONFIG="${ESYSROOT}/usr/bin/${CHOST}-gpgrt-config"
	)

	if use kernel_linux; then
		# --enable-random=getentropy requires getentropy/getrandom.
		# --enable-random=linux enables legacy code that tries getrandom
		# and falls back to reading /dev/random.
		myeconfargs+=( --enable-random=$(usex getentropy getentropy linux) )
	fi

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}" \
		$("${S}/configure" --help | grep -o -- '--without-.*-prefix')
}

multilib_src_compile() {
	default
	multilib_is_native_abi && use doc && VARTEXFONTS="${T}/fonts" emake -C doc gcrypt.pdf
}

multilib_src_test() {
	# t-secmem and t-sexp need mlock which requires extra privileges; nspawn
	# at least disallows that by default.
	local -x GCRYPT_IN_ASAN_TEST=1
	# Avoid running (very) expensive bench-slope test. On hppa, it
	# takes at least 7 hours.
	local -x GCRYPT_NO_BENCHMARKS=1

	default
}

multilib_src_install() {
	emake DESTDIR="${D}" install
	multilib_is_native_abi && use doc && dodoc doc/gcrypt.pdf
}

multilib_src_install_all() {
	default
	find "${ED}" -type f -name '*.la' -delete || die
}
