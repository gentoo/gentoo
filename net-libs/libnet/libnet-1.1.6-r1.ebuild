# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit autotools eutils

DESCRIPTION="library providing an API for commonly used low-level network functions"
HOMEPAGE="http://libnet-dev.sourceforge.net/"
SRC_URI="mirror://sourceforge/project/${PN}-dev/${P}.tar.gz"

LICENSE="BSD BSD-2 HPND"
SLOT="1.1"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="doc static-libs"

DEPEND="sys-devel/autoconf"

DOCS=(
	README doc/{CHANGELOG,CONTRIB,DESIGN_NOTES,MIGRATION}
	doc/{PACKET_BUILDING,PORTED,RAWSOCKET_NON_SEQUITUR,TODO}
)
PATCHES=(
	"${FILESDIR}"/${PN}-1.1.6-_SOURCE.patch
	"${FILESDIR}"/${PN}-1.1.6-musl.patch
	"${FILESDIR}"/${PN}-1.2-sizeof.patch
)

src_prepare() {
	default

	mv configure{.in,.ac} || die
	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default

	if use doc ; then
		dodoc -r doc/html

		docinto sample
		dodoc sample/*.[ch]
	fi

	prune_libtool_files
}
