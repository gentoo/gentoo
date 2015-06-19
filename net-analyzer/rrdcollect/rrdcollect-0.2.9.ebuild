# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/rrdcollect/rrdcollect-0.2.9.ebuild,v 1.3 2014/07/15 17:57:14 jer Exp $

EAPI=5

inherit eutils

DESCRIPTION="Read system statistical data and feed it to RRDtool"
HOMEPAGE="http://rrdcollect.sourceforge.net/"
SRC_URI="mirror://sourceforge/rrdcollect/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="exec librrd pcre"

DEPEND="
	librrd? ( net-analyzer/rrdtool )
	pcre? ( dev-libs/libpcre )
"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-include.patch
}

src_configure() {
	econf \
		$(use_enable exec) \
		$(use_with librrd) \
		$(use_with pcre libpcre)
}

DOCS=( AUTHORS ChangeLog NEWS TODO )

src_install() {
	default
	docinto examples
	dodoc doc/examples/*
}
