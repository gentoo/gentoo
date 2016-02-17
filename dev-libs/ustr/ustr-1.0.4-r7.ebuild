# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit toolchain-funcs multilib-minimal

DESCRIPTION="Low-overhead managed string library for C"
HOMEPAGE="http://www.and.org/ustr"
SRC_URI="ftp://ftp.and.org/pub/james/ustr/${PV}/${P}.tar.bz2"

LICENSE="|| ( BSD-2 MIT LGPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~x86"

DOCS=(ChangeLog README README-DEVELOPERS AUTHORS NEWS TODO)

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/ustr-conf.h
	/usr/include/ustr-conf-debug.h
)

src_prepare() {
	epatch "${FILESDIR}/${P}-gcc_5-check.patch"
	multilib_copy_sources
}

_emake() {
	emake \
		AR="$(tc-getAR)" \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS} ${CPPFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		prefix="${EPREFIX}/usr" \
		libdir="${EPREFIX}/usr/$(get_libdir)" \
		mandir="${EPREFIX}/usr/share/man" \
		SHRDIR="${EPREFIX}/usr/share/${P}" \
		DOCSHRDIR="${EPREFIX}/usr/share/doc/${PF}" \
		HIDE= \
		"$@"
}

multilib_src_compile() {
	_emake all-shared
}

multilib_src_install() {
	_emake DESTDIR="${D}" install
}

multilib_src_test() {
	_emake check
}
