# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# Remember: we cannot leverage autotools in this ebuild in order
#           to avoid circular deps with autotools

EAPI=5

inherit eutils multilib toolchain-funcs libtool multilib-minimal

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://git.tukaani.org/xz.git"
	inherit git-r3 autotools
	SRC_URI=""
	EXTRA_DEPEND="sys-devel/gettext dev-vcs/cvs >=sys-devel/libtool-2" #272880 286068
else
	MY_P="${PN/-utils}-${PV/_}"
	SRC_URI="https://tukaani.org/xz/${MY_P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
	S=${WORKDIR}/${MY_P}
	EXTRA_DEPEND=
fi

DESCRIPTION="utils for managing LZMA compressed files"
HOMEPAGE="https://tukaani.org/xz/"

# See top-level COPYING file as it outlines the various pieces and their licenses.
LICENSE="public-domain LGPL-2.1+ GPL-2+"
SLOT="0"
IUSE="elibc_FreeBSD +extra-filters nls static-libs +threads"

RDEPEND="!<app-arch/lzma-4.63
	!app-arch/lzma-utils
	!<app-arch/p7zip-4.57"
DEPEND="${RDEPEND}
	${EXTRA_DEPEND}"

# Tests currently do not account for smaller feature set
RESTRICT="!extra-filters? ( test )"

src_prepare() {
	if [[ ${PV} == "9999" ]] ; then
		eautopoint
		eautoreconf
	else
		elibtoolize  # to allow building shared libs on Solaris/x64
	fi
}

multilib_src_configure() {
	local myconf=(
		$(use_enable nls)
		$(use_enable threads)
		$(use_enable static-libs static)
	)
	multilib_is_native_abi ||
		myconf+=( --disable-{xz,xzdec,lzmadec,lzmainfo,lzma-links,scripts} )
	if ! use extra-filters; then
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

	use elibc_FreeBSD && export ac_cv_header_sha256_h=no #545714
	ECONF_SOURCE="${S}" econf "${myconf[@]}"
}

multilib_src_install() {
	default
	gen_usr_ldscript -a lzma
}

multilib_src_install_all() {
	prune_libtool_files --all
	rm "${ED}"/usr/share/doc/xz/COPYING* || die
	mv "${ED}"/usr/share/doc/{xz,${PF}} || die
}

pkg_preinst() {
	preserve_old_lib /usr/$(get_libdir)/liblzma$(get_libname 0)
}

pkg_postinst() {
	preserve_old_lib_notify /usr/$(get_libdir)/liblzma$(get_libname 0)
}
