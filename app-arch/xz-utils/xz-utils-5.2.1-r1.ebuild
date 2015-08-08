# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# Remember: we cannot leverage autotools in this ebuild in order
#           to avoid circular deps with autotools

EAPI="4"

inherit eutils multilib toolchain-funcs libtool multilib-minimal

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="http://git.tukaani.org/xz.git"
	inherit git-2 autotools
	SRC_URI=""
	EXTRA_DEPEND="sys-devel/gettext dev-vcs/cvs >=sys-devel/libtool-2" #272880 286068
else
	MY_P="${PN/-utils}-${PV/_}"
	SRC_URI="http://tukaani.org/xz/${MY_P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~hppa-hpux ~ia64-hpux ~amd64-linux ~arm-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
	S=${WORKDIR}/${MY_P}
	EXTRA_DEPEND=
fi

DESCRIPTION="utils for managing LZMA compressed files"
HOMEPAGE="http://tukaani.org/xz/"

# See top-level COPYING file as it outlines the various pieces and their licenses.
LICENSE="public-domain LGPL-2.1+ GPL-2+"
SLOT="0"
IUSE="elibc_FreeBSD nls static-libs +threads"

RDEPEND="!<app-arch/lzma-4.63
	!app-arch/lzma-utils
	!<app-arch/p7zip-4.57"
DEPEND="${RDEPEND}
	${EXTRA_DEPEND}"

src_prepare() {
	if [[ ${PV} == "9999" ]] ; then
		eautopoint
		eautoreconf
	else
		elibtoolize  # to allow building shared libs on Solaris/x64
	fi
}

multilib_src_configure() {
	use elibc_FreeBSD && export ac_cv_header_sha256_h=no #545714
	ECONF_SOURCE="${S}" econf \
		$(use_enable nls) \
		$(use_enable threads) \
		$(use_enable static-libs static) \
		$(multilib_is_native_abi || echo --disable-{xz,xzdec,lzmadec,lzmainfo,lzma-links,scripts})
}

multilib_src_install() {
	default
	multilib_is_native_abi && gen_usr_ldscript -a lzma
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
