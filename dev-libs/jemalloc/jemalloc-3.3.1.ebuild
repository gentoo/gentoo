# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit autotools eutils

DESCRIPTION="Jemalloc is a general-purpose scalable concurrent allocator"
HOMEPAGE="http://www.canonware.com/jemalloc/"
SRC_URI="http://www.canonware.com/download/${PN}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ppc ppc64 ~s390 x86 ~x64-macos"
IUSE="debug static-libs stats"

src_prepare() {
	epatch \
		"${FILESDIR}/${PN}-3.0.0-strip-optimization.patch" \
		"${FILESDIR}/${PN}-3.0.0-no-pprof.patch" \
		"${FILESDIR}/${PN}-3.0.0_fix_html_install.patch"

	eautoreconf
}

src_configure() {
	econf \
		$(use_enable debug) \
		$(use_enable stats)
}

src_install() {
	default
	dohtml doc/jemalloc.html

	if [[ ${CHOST} == *-darwin* ]] ; then
		# fixup install_name, #437362
		install_name_tool \
			-id "${EPREFIX}"/usr/$(get_libdir)/libjemalloc.1.dylib \
			"${ED}"/usr/$(get_libdir)/libjemalloc.1.dylib || die
	fi

	use static-libs || find "${D}" -name '*.a' -delete
}
