# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils autotools

DESCRIPTION="A library for writing RADIUS clients accompanied with several client utilities"
HOMEPAGE="http://freshmeat.net/projects/radiusclient/"
SRC_URI="ftp://ftp.cityline.net/pub/radiusclient/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE=""

DEPEND="!net-dialup/radiusclient-ng
	!net-dialup/freeradius-client"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}

	cd "${S}"
	epatch "${FILESDIR}/pkgsysconfdir-install.patch"
	eautoreconf
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc README BUGS CHANGES COPYRIGHT
	dohtml doc/instop.html
}
