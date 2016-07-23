# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils

DESCRIPTION="An implementation of the IDNA2008 specifications (RFCs 5890, 5891, 5892, 5893)"
HOMEPAGE="https://www.gnu.org/software/libidn/#libidn2"
SRC_URI="mirror://gnu-alpha/libidn/${P}.tar.gz"

LICENSE="GPL-2+ LGPL-3+"
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
