# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit base autotools

DESCRIPTION="C library and ncurses based program to generate ICMP echo requests and ping multiple hosts at once"
HOMEPAGE="http://verplant.org/liboping"
SRC_URI="http://verplant.org/${PN}/files/${P}.tar.bz2"

LICENSE="LGPL-2.1 GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="perl"

DEPEND="
	sys-libs/ncurses
	perl? ( dev-lang/perl )
"
RDEPEND=${DEPEND}

PATCHES=( "${FILESDIR}/${PN}-1.6.2-nouidmagic.patch" )

src_prepare() {
	base_src_prepare
	eautoreconf
}

src_configure() {
	econf \
		$(use_with perl perl-bindings INSTALLDIRS=vendor) \
		--disable-static
}

src_install() {
	default
	find "${D}" -name '*.la'  -delete || die

	fperms u+s,og-r /usr/bin/oping
	fperms u+s,og-r /usr/bin/noping
}
