# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/elfutils/elfutils-0.152-r1.ebuild,v 1.5 2012/10/09 15:49:14 vapier Exp $

EAPI="3"

inherit eutils toolchain-funcs

DESCRIPTION="Libraries/utilities to handle ELF objects (drop in replacement for libelf)"
HOMEPAGE="https://fedorahosted.org/elfutils/"
SRC_URI="https://fedorahosted.org/releases/e/l/${PN}/${PV}/${P}.tar.bz2
	https://fedorahosted.org/releases/e/l/${PN}/${PV}/${PN}-portability.patch -> ${P}-portability.patch
	https://fedorahosted.org/releases/e/l/${PN}/${PV}/${PN}-robustify.patch -> ${P}-robustify.patch"

LICENSE="GPL-2-with-exceptions"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="bzip2 lzma nls zlib"

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
	# some patches touch both configure and configure.ac
	find -type f -exec touch -r configure {} +
	mkdir -p ${CBUILD} ${CHOST}
}

econf_build() {
	CFLAGS=${BUILD_CFLAGS:--O1 -pipe} \
	CXXFLAGS=${BUILD_CXXFLAGS:--O1 -pipe} \
	CPPFLAGS=${BUILD_CPPFLAGS} \
	LDFLAGS=${BUILD_LDFLAGS} \
	CC=$(tc-getBUILD_CC) \
	LD=$(tc-getBUILD_LD) \
	econf --host=${CBUILD} "$@"
}

src_configure() {
	ECONF_SOURCE=${S}

	if tc-is-cross-compiler ; then
		pushd ${CBUILD} >/dev/null
		econf_build --disable-nls --without-{zlib,bzlib,lzma}
		popd >/dev/null
	fi

	pushd ${CHOST} >/dev/null
	econf \
		$(use_enable nls) \
		--program-prefix="eu-" \
		$(use_with zlib) \
		$(use_with bzip2 bzlib) \
		$(use_with lzma)
	popd >/dev/null
}

src_compile() {
	if tc-is-cross-compiler ; then
		pushd ${CBUILD} >/dev/null
		emake -C lib || die
		emake -C libcpu || die
		popd >/dev/null
		ln ${CBUILD}/libcpu/i386_gendis ${CHOST}/libcpu/ || die
		sed -i -e '/^%_dis.h: %_defs/s: i386_gendis::' ${CHOST}/libcpu/Makefile || die
	fi

	emake -C ${CHOST} || die
}

src_test() {
	env LD_LIBRARY_PATH="${S}/libelf:${S}/libebl:${S}/libdw:${S}/libasm" \
		LC_ALL="C" \
		emake -C ${CHOST} -j1 check || die "test failed"
}

src_install() {
	emake -C ${CHOST} DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS NOTES README THANKS TODO
}
