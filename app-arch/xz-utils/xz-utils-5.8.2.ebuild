# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Remember: we cannot leverage autotools in this ebuild in order
#           to avoid circular deps with autotools

EAPI=8

inherit dot-a flag-o-matic libtool multilib multilib-minimal preserve-libs toolchain-funcs

if [[ ${PV} == 9999 ]] ; then
	# Per tukaani.org, git.tukaani.org is a mirror of github and
	# may be behind.
	EGIT_REPO_URI="
		https://github.com/tukaani-project/xz
		https://git.tukaani.org/xz.git
	"
	inherit git-r3 autotools

	# bug #272880 and bug #286068
	BDEPEND="sys-devel/gettext >=dev-build/libtool-2"
else
	VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/lassecollin.asc
	inherit verify-sig

	MY_P="${PN/-utils}-${PV/_}"
	SRC_URI="
		https://github.com/tukaani-project/xz/releases/download/v${PV/_}/${MY_P}.tar.gz
		https://downloads.sourceforge.net/lzmautils/${MY_P}.tar.gz
		https://tukaani.org/xz/${MY_P}.tar.gz
		verify-sig? (
			https://github.com/tukaani-project/xz/releases/download/v${PV/_}/${MY_P}.tar.gz.sig
			https://tukaani.org/xz/${MY_P}.tar.gz.sig
		)
	"

	if [[ ${PV} != *_alpha* && ${PV} != *_beta* ]] ; then
		KEYWORDS="~alpha ~amd64 arm arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos ~x64-macos ~x64-solaris"
	fi

	S="${WORKDIR}/${MY_P}"
fi

DESCRIPTION="Utils for managing LZMA compressed files"
HOMEPAGE="https://tukaani.org/xz/"

# See top-level COPYING file as it outlines the various pieces and their licenses.
LICENSE="0BSD LGPL-2.1+ GPL-2+ doc? ( CC-BY-SA-4.0 )"
SLOT="0"
IUSE="cpu_flags_arm_crc32 doc +extra-filters pgo nls static-libs"

if [[ ${PV} != 9999 ]] ; then
	BDEPEND+=" verify-sig? ( >=sec-keys/openpgp-keys-lassecollin-20250313 )"
fi

src_prepare() {
	default

	if [[ ${PV} == 9999 ]] ; then
		eautopoint
		eautoreconf
	else
		# Allow building shared libs on Solaris/x64
		elibtoolize
	fi
}

src_configure() {
	use static-libs && lto-guarantee-fat
	multilib-minimal_src_configure
}

multilib_src_configure() {
	local myconf=(
		--enable-threads
		$(multilib_native_use_enable doc)
		$(use_enable nls)
		$(use_enable static-libs static)
		$(use_enable cpu_flags_arm_crc32 arm64-crc32)
	)

	if ! multilib_is_native_abi ; then
		myconf+=(
			--disable-{xz,xzdec,lzmadec,lzmainfo,lzma-links,scripts}
		)
	fi

	if ! use extra-filters ; then
		myconf+=(
			# LZMA1 + LZMA2 for standard .lzma & .xz files
			--enable-encoders=lzma1,lzma2
			--enable-decoders=lzma1,lzma2

			# those are used by default, depending on preset
			--enable-match-finders=hc3,hc4,bt4

			# CRC64 is used by default, though 7-Zip uses CRC32 by default.
			# Also, XZ Embedded in Linux doesn't support CRC64, so
			# kernel modules and friends are CRC32.
			--enable-checks=crc32,crc64
		)
	fi

	if [[ ${CHOST} == *-solaris* ]] ; then
		export gl_cv_posix_shell="${EPREFIX}"/bin/sh

		# Undo Solaris-based defaults pointing to /usr/xpg4/bin
		myconf+=( --disable-path-for-script )
	fi

	ECONF_SOURCE="${S}" econf "${myconf[@]}"
}

multilib_src_compile() {
	# -fprofile-partial-training because upstream note the test suite isn't super comprehensive
	# TODO: revisit that now we have the tar/xz loop below?
	# See https://documentation.suse.com/sbp/all/html/SBP-GCC-10/index.html#sec-gcc10-pgo
	local pgo_generate_flags=$(usev pgo "-fprofile-update=atomic -fprofile-dir=${T}/${ABI}-pgo -fprofile-generate=${T}/${ABI}-pgo $(test-flags-CC -fprofile-partial-training)")
	local pgo_use_flags=$(usev pgo "-fprofile-use=${T}/${ABI}-pgo -fprofile-dir=${T}/${ABI}-pgo $(test-flags-CC -fprofile-partial-training)")

	emake CFLAGS="${CFLAGS} ${pgo_generate_flags}"

	if use pgo ; then
		emake CFLAGS="${CFLAGS} ${pgo_generate_flags}" -k check

		local tar_pgo_args=()

		if has_version -b "app-alternatives/tar[gnu]" ; then
			tar_pgo_args+=(
				--mtime=@2718281828
				--sort=name
			)
		fi

		if multilib_is_native_abi ; then
			(
				shopt -s globstar

				tar \
					"${tar_pgo_args[@]}" \
					-cf xz-pgo-test-01.tar \
					{"${S}","${BUILD_DIR}"}/**/*.[cho] \
					{"${S}","${BUILD_DIR}"}/**/.libs/* \
					{"${S}","${BUILD_DIR}"}/**/**.txt \
					{"${S}","${BUILD_DIR}"}/tests/files

				stat --printf="xz-pgo-test-01.tar.tar size: %s\n" xz-pgo-test-01.tar || die
				md5sum xz-pgo-test-01.tar || die
			)

			local test_variants=(
				# Borrowed from ALT Linux
				# https://packages.altlinux.org/en/sisyphus/srpms/xz/specfiles/#line-80
				'-0 -C none'
				'-2 -C crc32'
				"$(usev extra-filters '-6 --arm --lzma2 -C crc64')"
				"$(usev extra-filters '-6 --x86 --lzma2=lc=4 -C sha256')"
				'-7e --format=lzma'

				# Our own variants
				''
				'-e'
				"$(usev extra-filters '--x86 --lzma2=preset=6e')"
			)
			local test_variant
			for test_variant in "${test_variants[@]}" ; do
				einfo "Testing '${test_variant}' variant"
				"${BUILD_DIR}"/src/xz/xz -c ${test_variant} xz-pgo-test-01.tar | "${BUILD_DIR}"/src/xz/xz -c -d - > /dev/null
				assert "Testing '${test_variant}' variant failed"
			done
		fi

		if tc-is-clang; then
			llvm-profdata merge "${T}"/${ABI}-pgo --output="${T}"/${ABI}-pgo/default.profdata || die
		fi

		emake clean
		emake CFLAGS="${CFLAGS} ${pgo_use_flags}"
	fi
}

multilib_src_install() {
	default

	# bug #934370 and bug #450436 (and bug #934515)
	if ! tc-is-static-only && [[ ! -f "${ED}/usr/$(get_libdir)/liblzma$(get_libname)" ]] ; then
		eerror "Sanity check for liblzma$(get_libname) failed."
		eerror "Shared library wasn't built, possible libtool bug"
		[[ -z ${I_KNOW_WHAT_I_AM_DOING} ]] && die "liblzma$(get_libname) not found in build, aborting"
	fi
}

multilib_src_install_all() {
	strip-lto-bytecode

	find "${ED}" -type f -name '*.la' -delete || die

	if use doc ; then
		rm "${ED}"/usr/share/doc/${PF}/COPYING* || die
	fi
}

pkg_preinst() {
	preserve_old_lib /usr/$(get_libdir)/liblzma$(get_libname 0)
}

pkg_postinst() {
	preserve_old_lib_notify /usr/$(get_libdir)/liblzma$(get_libname 0)
}
