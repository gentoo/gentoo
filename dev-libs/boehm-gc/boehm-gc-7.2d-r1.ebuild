# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/boehm-gc/boehm-gc-7.2d-r1.ebuild,v 1.11 2014/02/19 19:06:07 sera Exp $

EAPI=5

inherit autotools eutils

MY_P="gc-${PV/_/}"

DESCRIPTION="The Boehm-Demers-Weiser conservative garbage collector"
HOMEPAGE="http://www.hboehm.info/gc/"
SRC_URI="http://www.hboehm.info/gc/gc_source/${MY_P}.tar.gz"

LICENSE="boehm-gc"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="cxx static-libs threads"

DEPEND=">=dev-libs/libatomic_ops-7.2
	virtual/pkgconfig"

S="${WORKDIR}/${MY_P/d}"

src_prepare() {
	rm -r libatomic_ops || die

	epatch "${FILESDIR}"/${P}-configure.patch
	epatch "${FILESDIR}"/${P}-automake-1.13.patch
	eautoreconf
}

src_configure() {
	local config=(
		--with-libatomic-ops
		$(use_enable cxx cplusplus)
		$(use_enable static-libs static)
		$(use threads || echo --disable-threads)
	)
	econf "${config[@]}"
}

src_install() {
	default

	rm -rf "${ED}"/usr/share/gc || die

	# dist_noinst_HEADERS
	insinto /usr/include/gc
	doins include/{cord.h,ec.h,javaxfc.h}
	insinto /usr/include/gc/private
	doins include/private/*.h

	dodoc README.QUICK doc/README{.environment,.linux,.macros} doc/barrett_diagram
	dohtml doc/*.html
	newman doc/gc.man GC_malloc.1

	prune_libtool_files
}
