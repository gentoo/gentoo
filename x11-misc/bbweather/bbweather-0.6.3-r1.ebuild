# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

inherit autotools eutils

DESCRIPTION="blackbox weather monitor"
HOMEPAGE="http://www.netmeister.org/apps/bbweather/"
SRC_URI="http://www.netmeister.org/apps/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 hppa ppc x86"
IUSE=""

DEPEND="dev-lang/perl
	x11-libs/libX11"
RDEPEND="${DEPEND}
	net-misc/wget
	x11-apps/xmessage
	!<=x11-plugins/gkrellweather-2.0.7-r1"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-asneeded.patch
	gunzip doc/*.gz || die
	sed -i \
		-e "s:man_DATA:man1_MANS:;s:.gz::g;/^mandir/d" \
		doc/Makefile.am || die
	sed -i \
		-e 's|-helvetica-|-*-|g' \
		resource.cpp data/${PN}.{nobb,style} || die
	eautoreconf
}

src_install () {
	emake DESTDIR="${D}" docdir="/usr/share/doc/${PF}" install || die
	dodoc README AUTHORS ChangeLog NEWS TODO data/README.bbweather || die

	# since multiple bbtools packages provide this file, install
	# it in /usr/share/doc/${PF}
	mv "${D}"/usr/share/bbtools/bbtoolsrc.in \
		"${D}"/usr/share/doc/${PF}/bbtoolsrc.example
}
