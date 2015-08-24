# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils

DESCRIPTION="An implementation of the IDNA2008 specifications (RFC 5890, RFC 5891, RFC 5892, RFC 5893)"
HOMEPAGE="https://www.gnu.org/software/libidn/#libidn2"
SRC_URI="mirror://gnu-alpha/libidn/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="static-libs"

src_prepare() {
	epatch "${FILESDIR}"/${P}-examples.patch
	epatch "${FILESDIR}"/${P}-Werror.patch
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable static-libs static)
}
