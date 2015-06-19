# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/boehm-gc/boehm-gc-7.2d.ebuild,v 1.12 2014/02/19 19:06:07 sera Exp $

EAPI=4

AUTOTOOLS_AUTORECONF=yes

inherit autotools-utils

MY_P="gc-${PV/_/}"

DESCRIPTION="The Boehm-Demers-Weiser conservative garbage collector"
HOMEPAGE="http://www.hboehm.info/gc/"
SRC_URI="http://www.hboehm.info/gc/gc_source/${MY_P}.tar.gz"

LICENSE="boehm-gc"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="cxx static-libs threads"

RDEPEND=">=dev-libs/libatomic_ops-7.2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${MY_P/d}"

DOCS=( README.QUICK doc/README{,.environment,.linux,.macros} doc/barrett_diagram )

PATCHES=( "${FILESDIR}"/${P}-configure.patch )

AUTOTOOLS_AUTORECONF=1

src_prepare() {
	sed '/Cflags/s:$:/gc:g' -i bdw-gc.pc.in || die
	sed \
		-e '/gc_allocator.h/d' \
		-i Makefile.am || die
	rm -rf libatomic_ops || die
	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		--with-libatomic-ops=yes
		$(use_enable cxx cplusplus)
		$(use threads || echo --disable-threads)
		)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install

	rm -rf "${ED}"/usr/share/gc || die

	# dist_noinst_HEADERS
	insinto /usr/include/gc
	doins include/{cord.h,ec.h,javaxfc.h}
	insinto /usr/include/gc/private
	doins include/private/*.h

	dohtml doc/*.html
	newman doc/gc.man GC_malloc.1
}
