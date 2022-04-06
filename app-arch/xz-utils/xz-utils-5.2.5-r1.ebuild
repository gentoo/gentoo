# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Remember: we cannot leverage autotools in this ebuild in order
#           to avoid circular deps with autotools

EAPI=7

inherit libtool multilib multilib-minimal preserve-libs usr-ldscript

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://git.tukaani.org/xz.git"
	inherit git-r3 autotools

	# bug #272880 and bug #286068
	BDEPEND="sys-devel/gettext >=sys-devel/libtool-2"
else
	VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}"/usr/share/openpgp-keys/lassecollin.asc
	inherit verify-sig

	MY_P="${PN/-utils}-${PV/_}"
	SRC_URI="https://tukaani.org/xz/${MY_P}.tar.gz"
	SRC_URI+=" verify-sig? ( https://tukaani.org/xz/${MY_P}.tar.gz.sig )"

	if [[ ${PV} != *_alpha* ]] && [[ ${PV} != *_beta* ]] ; then
		KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
	fi
	S="${WORKDIR}/${MY_P}"
fi

DESCRIPTION="Utils for managing LZMA compressed files"
HOMEPAGE="https://tukaani.org/xz/"

# See top-level COPYING file as it outlines the various pieces and their licenses.
LICENSE="public-domain LGPL-2.1+ GPL-2+"
SLOT="0"
IUSE="+extra-filters nls static-libs"

RDEPEND="!<app-arch/lzma-4.63
	!<app-arch/p7zip-4.57
	!<app-i18n/man-pages-de-2.16"
DEPEND="${RDEPEND}"
BDEPEND="verify-sig? ( sec-keys/openpgp-keys-lassecollin )"

# Tests currently do not account for smaller feature set
RESTRICT="!extra-filters? ( test )"

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

multilib_src_configure() {
	local myconf=(
		--enable-threads
		$(use_enable nls)
		$(use_enable static-libs static)
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

			# CRC64 is used by default, though some (old?) files use CRC32
			--enable-checks=crc32,crc64
		)
	fi

	if [[ ${CHOST} == *-solaris* ]] ; then
		export gl_cv_posix_shell="${EPREFIX}"/bin/sh

		# Undo Solaris-based defaults pointing to /usr/xpg5/bin
		myconf+=( --disable-path-for-script )
	fi

	ECONF_SOURCE="${S}" econf "${myconf[@]}"
}

multilib_src_install() {
	default

	gen_usr_ldscript -a lzma
}

multilib_src_install_all() {
	find "${ED}" -type f -name '*.la' -delete || die
	rm "${ED}"/usr/share/doc/${PF}/COPYING* || die
}

pkg_preinst() {
	preserve_old_lib /usr/$(get_libdir)/liblzma$(get_libname 0)
}

pkg_postinst() {
	preserve_old_lib_notify /usr/$(get_libdir)/liblzma$(get_libname 0)
}
