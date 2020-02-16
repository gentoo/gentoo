# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="EB is a C library and utilities for accessing CD-ROM books"
HOMEPAGE="http://www.sra.co.jp/people/m-kasahr/eb/"
SRC_URI="ftp://ftp.sra.co.jp/pub/misc/eb/${P}.tar.lzma"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm hppa ia64 ppc ppc64 sparc x86"
IUSE="ipv6 nls threads"

RDEPEND="
	sys-libs/zlib
	nls? ( virtual/libintl )
"
DEPEND="
	${RDEPEND}
	nls? ( sys-devel/gettext )
"

DOCS=( AUTHORS ChangeLog{,.0,.1,.2} NEWS README )

src_configure() {
	econf \
		$(use_enable ipv6) \
		$(use_enable nls) \
		$(use_enable threads pthread) \
		--with-pkgdocdir=/usr/share/doc/${PF}/html
}
