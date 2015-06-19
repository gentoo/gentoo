# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/evtest/evtest-1.30.ebuild,v 1.5 2013/10/19 00:11:16 vapier Exp $

EAPI="4"

inherit autotools eutils

DESCRIPTION="test program for capturing input device events"
HOMEPAGE="http://cgit.freedesktop.org/evtest/"
SRC_URI="http://cgit.freedesktop.org/evtest/snapshot/${PN}-${P}.tar.gz -> ${P}.tar.gz
	mirror://gentoo/${P}-mans.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc x86"
IUSE="+xml"

# We bundled the man pages ourselves to avoid xmlto/asciidoc.
# We need libxml2 for the capture tool.  While at runtime,
# we have a file that can be used with xsltproc, we don't
# directly need it ourselves, so don't depend on libxslt.
# tar zcf ${P}-mans.tar.gz *.1 --transform=s:^:evtest-${P}/:
RDEPEND="xml? ( dev-libs/libxml2 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${PN}-${P}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.30-autoconf.patch
	epatch "${FILESDIR}"/${PN}-1.30-xml.patch
	eautoreconf
}

src_configure() {
	# We pre-compile the man pages.
	XMLTO=/bin/true ASCIIDOC=/bin/true \
	econf $(use_enable xml)
}
