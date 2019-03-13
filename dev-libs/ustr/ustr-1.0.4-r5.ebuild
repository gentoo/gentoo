# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit toolchain-funcs multilib-minimal

DESCRIPTION="Low-overhead managed string library for C"
HOMEPAGE="http://www.and.org/ustr/"
SRC_URI="ftp://ftp.and.org/pub/james/ustr/${PV}/${P}.tar.bz2"

LICENSE="|| ( BSD-2 MIT LGPL-2 )"
SLOT="0"
KEYWORDS="amd64 ~arm ~mips x86"
IUSE=""

DEPEND=""
RDEPEND=""

DOCS=(ChangeLog README README-DEVELOPERS AUTHORS NEWS TODO)

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/ustr-conf.h
	/usr/include/ustr-conf-debug.h
)

src_prepare() {
	multilib_copy_sources
}

multilib_src_compile() {
	emake \
		AR="$(tc-getAR)" \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		prefix="${EPREFIX}/usr" \
		SHRDIR="/usr/share/${P}" \
		HIDE= \
		all-shared
}

multilib_src_install() {
	emake \
		DESTDIR="${D}" \
		prefix="${EPREFIX}/usr" \
		libdir="${EPREFIX}/usr/$(get_libdir)" \
		mandir="/usr/share/man" \
		SHRDIR="/usr/share/${P}" \
		DOCSHRDIR="/usr/share/doc/${PF}" \
		HIDE= \
		install
}

multilib_src_test() {
	emake \
		AR="$(tc-getAR)" \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		prefix="${EPREFIX}/usr" \
		SHRDIR="/usr/share/${P}" \
		HIDE= \
		check
}
