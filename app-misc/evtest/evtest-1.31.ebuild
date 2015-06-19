# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/evtest/evtest-1.31.ebuild,v 1.1 2015/01/14 04:40:25 vapier Exp $

EAPI="4"

inherit autotools eutils

DESCRIPTION="test program for capturing input device events"
HOMEPAGE="http://cgit.freedesktop.org/evtest/"
SRC_URI="http://cgit.freedesktop.org/evtest/snapshot/${PN}-${P}.tar.gz -> ${P}.tar.gz
	mirror://gentoo/${P}-mans.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE=""

# We bundled the man pages ourselves to avoid xmlto/asciidoc.
# We need libxml2 for the capture tool.  While at runtime,
# we have a file that can be used with xsltproc, we don't
# directly need it ourselves, so don't depend on libxslt.
# tar zcf ${P}-mans.tar.gz *.1 --transform=s:^:evtest-${P}/:
RDEPEND=""
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${PN}-${P}

src_prepare() {
	eautoreconf
}

src_configure() {
	# We pre-compile the man pages.
	XMLTO=$(type -P true) ASCIIDOC=$(type -P true) \
	econf
}
