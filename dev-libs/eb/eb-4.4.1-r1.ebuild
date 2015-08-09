# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="EB is a C library and utilities for accessing CD-ROM books"
HOMEPAGE="http://www.sra.co.jp/people/m-kasahr/eb/"
SRC_URI="ftp://ftp.sra.co.jp/pub/misc/eb/${P}.tar.lzma"
LICENSE="BSD"

SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86"
IUSE="ipv6 linguas_ja threads"

RDEPEND="
	sys-libs/zlib
	linguas_ja? ( virtual/libintl )
"
DEPEND="
	${RDEPEND}
	linguas_ja? ( sys-devel/gettext )
"

DOCS=( AUTHORS ChangeLog{,.0,.1,.2} NEWS README )

src_configure() {
	econf \
		$(use_enable ipv6) \
		$(use_enable linguas_ja nls) \
		$(use_enable threads pthread) \
		--with-pkgdocdir=/usr/share/doc/${PF}/html
}
