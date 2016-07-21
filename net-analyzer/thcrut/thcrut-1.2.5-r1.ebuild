# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils

DESCRIPTION="Network discovery and fingerprinting tool"
HOMEPAGE="http://www.thc.org/thc-rut/"
SRC_URI="http://www.thc.org/thc-rut/${P}.tar.gz"

LICENSE="free-noncomm PCRE GPL-1+"
SLOT="0"
KEYWORDS="amd64 ~ppc sparc x86"

DEPEND="
	dev-libs/libpcre
	net-libs/libnet:1.0
	net-libs/libpcap
"

src_prepare() {
	rm -r Libnet-1.0.2a pcre-3.9 || die
	epatch \
		"${FILESDIR}"/${P}-libnet.patch \
		"${FILESDIR}"/${P}-configure.patch
	eautoreconf
}

DOCS=( ChangeLog FAQ README TODO thcrutlogo.txt )
