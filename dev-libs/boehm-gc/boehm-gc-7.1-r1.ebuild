# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/boehm-gc/boehm-gc-7.1-r1.ebuild,v 1.4 2014/02/19 19:06:07 sera Exp $

inherit eutils

MY_P="gc-${PV/_/}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="The Boehm-Demers-Weiser conservative garbage collector"
HOMEPAGE="http://www.hboehm.info/gc/"
SRC_URI="http://www.hboehm.info/gc/gc_source/${MY_P}.tar.gz"

LICENSE="boehm-gc"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ~hppa ~ia64 ppc ppc64 ~sparc x86"
IUSE="cxx threads"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i -e '/^SUBDIRS/s/doc//' Makefile.in || die
	epatch "${FILESDIR}"/${PN}-6.5-gentoo.patch
	epatch "${FILESDIR}"/gc6.6-builtin-backtrace-uclibc.patch
	sed '/Cflags/s:$:/gc:g' -i bdw-gc.pc.in || die
}

src_compile() {
	econf \
		$(use_enable cxx cplusplus) \
		$(use threads || echo --disable-threads)
	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die

	rm -rf "${D}"/usr/share/gc || die

	# dist_noinst_HEADERS
	insinto /usr/include/gc
	doins include/{cord.h,ec.h,javaxfc.h}
	insinto /usr/include/gc/private
	doins include/private/*.h

	dodoc README.QUICK doc/README* doc/barrett_diagram
	dohtml doc/*.html
	newman doc/gc.man GC_malloc.1
}
