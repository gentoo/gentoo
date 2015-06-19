# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/elfutils/elfutils-0.154-r1.ebuild,v 1.3 2012/10/09 15:49:14 vapier Exp $

EAPI="4"

inherit eutils flag-o-matic

DESCRIPTION="Libraries/utilities to handle ELF objects (drop in replacement for libelf)"
HOMEPAGE="https://fedorahosted.org/elfutils/"
SRC_URI="https://fedorahosted.org/releases/e/l/${PN}/${PV}/${P}.tar.bz2
	https://fedorahosted.org/releases/e/l/${PN}/${PV}/${PN}-portability.patch -> ${P}-portability.patch
	https://fedorahosted.org/releases/e/l/${PN}/${PV}/${PN}-robustify.patch -> ${P}-robustify.patch"

LICENSE="GPL-2-with-exceptions"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="bzip2 lzma nls static-libs test +threads +utils zlib"

# This pkg does not actually seem to compile currently in a uClibc
# environment (xrealloc errs), but we need to ensure that glibc never
# gets pulled in as a dep since this package does not respect virtual/libc
RDEPEND="zlib? ( >=sys-libs/zlib-1.2.2.3 )
	bzip2? ( app-arch/bzip2 )
	lzma? ( app-arch/xz-utils )
	!dev-libs/libelf"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )
	>=sys-devel/flex-2.5.4a
	sys-devel/m4"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.118-PaX-support.patch
	epatch "${DISTDIR}"/${P}-{portability,robustify}.patch
	sed -i -e 's:-Werror::g' $(find -name Makefile.in) || die
	use test || sed -i -e 's: tests::' Makefile.in #226349
	use static-libs || sed -i -e '/^lib_LIBRARIES/s:=.*:=:' -e '/^%.os/s:%.o$::' lib{asm,dw,elf}/Makefile.in
	# some patches touch both configure and configure.ac
	find -type f -exec touch -r configure {} +
}

src_configure() {
	use test && append-flags -g #407135
	econf \
		--disable-werror \
		$(use_enable nls) \
		$(use_enable threads thread-safety) \
		--program-prefix="eu-" \
		$(use_with zlib) \
		$(use_with bzip2 bzlib) \
		$(use_with lzma)
}

src_test() {
	env LD_LIBRARY_PATH="${S}/libelf:${S}/libebl:${S}/libdw:${S}/libasm" \
		LC_ALL="C" \
		emake check || die
}

src_install() {
	default
	dodoc NOTES
	# These build quick, and are needed for most tests, so don't
	# disable their building when the USE flag is disabled.
	use utils || rm -rf "${ED}"/usr/bin
}
