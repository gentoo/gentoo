# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit flag-o-matic ltprune multilib

DESCRIPTION="An abstract library implementation of a VT220/xterm/ECMA-48 terminal emulator"
HOMEPAGE="http://www.leonerd.org.uk/code/libvterm/"
SRC_URI="https://dev.gentoo.org/~yngwin/distfiles/${P}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="sys-devel/libtool
	virtual/pkgconfig"

src_compile() {
	append-cflags -fPIC
	emake PREFIX="${EPREFIX}/usr" LIBDIR="${EPREFIX}/usr/$(get_libdir)"
}

src_install() {
	emake PREFIX="${EPREFIX}/usr" LIBDIR="${EPREFIX}/usr/$(get_libdir)" \
		DESTDIR="${D}" install
	prune_libtool_files

	dodoc doc/*
}
