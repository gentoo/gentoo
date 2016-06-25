# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils flag-o-matic multilib-minimal

DESCRIPTION="Libraries/utilities to handle ELF objects (drop in replacement for libelf)"
HOMEPAGE="https://fedorahosted.org/elfutils/"
SRC_URI="https://fedorahosted.org/releases/e/l/${PN}/${PV}/${P}.tar.bz2"

LICENSE="GPL-2-with-exceptions"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc x86 ~amd64-linux ~arm-linux ~x86-linux"
IUSE="bzip2 lzma nls static-libs test +threads +utils"

# This pkg does not actually seem to compile currently in a uClibc
# environment (xrealloc errs), but we need to ensure that glibc never
# gets pulled in as a dep since this package does not respect virtual/libc
RDEPEND=">=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}]
	bzip2? ( >=app-arch/bzip2-1.0.6-r4[${MULTILIB_USEDEP}] )
	lzma? ( >=app-arch/xz-utils-5.0.5-r1[${MULTILIB_USEDEP}] )
	!dev-libs/libelf
	abi_x86_32? (
		!<=app-emulation/emul-linux-x86-baselibs-20130224-r11
		!app-emulation/emul-linux-x86-baselibs[-abi_x86_32(-)]
	)"
# We need to require a newer glibc for its elf.h defs. #571814
DEPEND="${RDEPEND}
	!<sys-libs/glibc-2.22
	nls? ( sys-devel/gettext )
	>=sys-devel/flex-2.5.4a
	sys-devel/m4"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.118-PaX-support.patch
	use static-libs || sed -i -e '/^lib_LIBRARIES/s:=.*:=:' -e '/^%.os/s:%.o$::' lib{asm,dw,elf}/Makefile.in
	sed -i 's:-Werror::' */Makefile.in
	# some patches touch both configure and configure.ac
	find -type f -exec touch -r configure {} +
}

src_configure() {
	use test && append-flags -g #407135
	multilib-minimal_src_configure
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf \
		$(use_enable nls) \
		$(use_enable threads thread-safety) \
		--program-prefix="eu-" \
		--with-zlib \
		$(use_with bzip2 bzlib) \
		$(use_with lzma)
}

multilib_src_test() {
	env	LD_LIBRARY_PATH="${BUILD_DIR}/libelf:${BUILD_DIR}/libebl:${BUILD_DIR}/libdw:${BUILD_DIR}/libasm" \
		LC_ALL="C" \
		emake check || die
}

multilib_src_install_all() {
	einstalldocs
	dodoc NOTES
	# These build quick, and are needed for most tests, so don't
	# disable their building when the USE flag is disabled.
	use utils || rm -rf "${ED}"/usr/bin
}
