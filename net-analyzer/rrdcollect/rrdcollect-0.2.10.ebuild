# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools

DESCRIPTION="Read system statistical data and feed it to RRDtool"
HOMEPAGE="http://rrdcollect.sourceforge.net/"
SRC_URI="mirror://sourceforge/rrdcollect/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="exec librrd pcre"

DEPEND="
	librrd? ( net-analyzer/rrdtool )
	pcre? ( dev-libs/libpcre )
"
RDEPEND="${DEPEND}"
DOCS=( AUTHORS ChangeLog NEWS TODO )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable exec) \
		$(use_with librrd) \
		$(use_with pcre libpcre)
}

src_install() {
	default
	docinto examples
	dodoc doc/examples/*
}
