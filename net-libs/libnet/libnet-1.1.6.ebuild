# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libnet/libnet-1.1.6.ebuild,v 1.13 2014/06/09 23:58:56 vapier Exp $

EAPI=4

inherit eutils

DESCRIPTION="library to provide an API for commonly used low-level network functions (mainly packet injection)"
HOMEPAGE="http://libnet-dev.sourceforge.net/"
SRC_URI="mirror://sourceforge/project/${PN}-dev/${P}.tar.gz"

LICENSE="BSD BSD-2 HPND"
SLOT="1.1"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="doc static-libs"

DEPEND="sys-devel/autoconf"
RDEPEND=""

DOCS=(
	README doc/{CHANGELOG,CONTRIB,DESIGN_NOTES,MIGRATION}
	doc/{PACKET_BUILDING,PORTED,RAWSOCKET_NON_SEQUITUR,TODO}
)

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default

	if use doc ; then
		dohtml -r doc/html/*
		docinto sample
		dodoc sample/*.[ch]
	fi

	if ! use static-libs; then
		rm "${ED}"/usr/lib*/libnet.la || die
	fi
}
