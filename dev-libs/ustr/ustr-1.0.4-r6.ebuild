# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/ustr/ustr-1.0.4-r3.ebuild,v 1.4 2014/01/14 13:58:01 ago Exp $

EAPI=5

inherit multilib-build toolchain-funcs eutils

DESCRIPTION="Low-overhead managed string library for C"
HOMEPAGE="http://www.and.org/ustr"
SRC_URI="ftp://ftp.and.org/pub/james/ustr/${PV}/${P}.tar.bz2"

LICENSE="|| ( BSD-2 MIT LGPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_prepare() {
	epatch "${FILESDIR}/${P}-gcc_5-check.patch"
	multilib_copy_sources
}

ustr_make() {
	emake "$@" \
		AR="$(tc-getAR)" \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		prefix="${EPREFIX}/usr" \
		SHRDIR="/usr/share/${P}" \
		HIDE= || die
}

ustr_install() {
	cd "${BUILD_DIR}" || die

	emake "$@" \
		DESTDIR="${D}" \
		prefix="${EPREFIX}/usr" \
		libdir="${EPREFIX}/usr/$(get_libdir)" \
		mandir="/usr/share/man" \
		SHRDIR="/usr/share/${P}" \
		DOCSHRDIR="/usr/share/doc/${PF}" \
		HIDE= || die
}

src_compile() {
	multilib_foreach_abi ustr_make all-shared
}

multilib_src_test() {
	multilib_foreach_abi ustr_make check
}

src_install() {
	multilib_foreach_abi ustr_install install-multilib-linux
	dodoc ChangeLog README README-DEVELOPERS AUTHORS NEWS TODO
}
