# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit toolchain-funcs

DESCRIPTION="An ultra-fast, ultra-compact key-value embedded data store"
HOMEPAGE="http://symas.com/mdb/"
SRC_URI="https://github.com/LMDB/lmdb/archive/LMDB_${PV}.tar.gz"

LICENSE="OPENLDAP"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~ppc-aix ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="static-libs"

DEPEND=""
# =net-nds/openldap-2.4.40 installs lmdb files.
RDEPEND="!=net-nds/openldap-2.4.40"

S="${WORKDIR}/${PN}-LMDB_${PV}/libraries/liblmdb"

src_prepare() {
	sed -i -e "s!^CC.*!CC = $(tc-getCC)!" \
		-e "s!^CFLAGS.*!CFLAGS = ${CFLAGS}!" \
		-e "s!^AR.*!AR = $(tc-getAR)!" \
		-e "/mkdir/s!lib!$(get_libdir)!" \
		-e "/for f/s!lib!$(get_libdir)!" \
		-e "s!prefix)/man!mandir)!" \
		-e "s!shared!shared -Wl,-soname,liblmdb.so.0!" \
		"${S}/Makefile" || die
}

src_configure() {
	:
}

src_compile() {
	emake LDLIBS+=" -pthread" || die
}

src_install() {
	emake DESTDIR="${ED}" prefix="${EROOT}usr" mandir="${EROOT}usr/share/man" install || die

	mv "${ED}"usr/$(get_libdir)/liblmdb.so{,.0} || die
	dosym liblmdb.so.0 "${EROOT}"usr/$(get_libdir)/liblmdb.so

	use static-libs || rm "${ED}"usr/$(get_libdir)/liblmdb.a || die
}
