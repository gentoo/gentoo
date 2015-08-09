# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils multilib-minimal toolchain-funcs flag-o-matic

DESCRIPTION="Asynchronous input/output library that uses the kernels native interface"
HOMEPAGE="https://git.fedorahosted.org/cgit/libaio.git/  http://lse.sourceforge.net/io/aio.html"
SRC_URI="https://fedorahosted.org/releases/${PN:0:1}/${PN:1:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-linux ~x86-linux"
IUSE="static-libs test"

src_prepare() {
	epatch \
		"${FILESDIR}"/${PN}-0.3.109-install.patch \
		"${FILESDIR}"/${PN}-0.3.109-x32.patch \
		"${FILESDIR}"/${PN}-0.3.109-testcase-8.patch \
		"${FILESDIR}"/${PN}-0.3.110-cppflags.patch \
		"${FILESDIR}"/${PN}-0.3.110-optional-werror.patch

	local sed_args=(
		-e "/^prefix=/s:/usr:${EPREFIX}/usr:"
		-e '/^libdir=/s:lib$:$(ABI_LIBDIR):'
	)
	if ! use static-libs; then
		sed_args+=( -e '/\tinstall .*\/libaio.a/d' )
		# Tests require the static library to be built.
		use test || sed_args+=( -e '/^all_targets +=/s/ libaio.a//' )
	fi
	sed -i "${sed_args[@]}" src/Makefile Makefile || die

	multilib_copy_sources
}

multilib_src_configure() {
	if use arm ; then
		# When building for thumb, we can't allow frame pointers.
		# http://crbug.com/464517
		if $(tc-getCPP) ${CFLAGS} ${CPPFLAGS} - <<<$'#ifndef __thumb__\n#error\n#endif' >&/dev/null ; then
			append-flags -fomit-frame-pointer
		fi
	fi
}

_emake() {
	CC=$(tc-getCC) \
	AR=$(tc-getAR) \
	RANLIB=$(tc-getRANLIB) \
	ABI_LIBDIR=$(get_libdir) \
	CFLAGS_WERROR= \
	emake "$@"
}

multilib_src_compile() {
	_emake
}

multilib_src_test() {
	mkdir -p testdir || die
	# 'make check' breaks with sandbox, 'make partcheck' works
	_emake partcheck prefix="${S}/src" libdir="${S}/src"
}

multilib_src_install() {
	_emake install DESTDIR="${D}"
}

multilib_src_install_all() {
	doman man/*
	dodoc ChangeLog TODO

	# move crap to / for multipath-tools #325355
	gen_usr_ldscript -a aio

	# This lib is a bare minimal shim on top of kernel syscalls.
	export QA_DT_NEEDED=$(find "${ED}" -type f -name 'libaio.so.*' -printf '/%P\n')
}
