# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3
inherit gnustep-2

S=${WORKDIR}/${PN/p/P}

DESCRIPTION="Simple image viewer"
HOMEPAGE="http://www.sonappart.net/softwares/preview/"
SRC_URI="http://www.sonappart.net/softwares/preview/download/${P/p/P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

src_prepare() {
	sed -e 's/sel_eq(/sel_isEqual(/' -i Document.m || die "sed failed"
	# Fix compilation, patch from debian
	epatch "${FILESDIR}"/${PN}-0.8.5-compilation-errors.patch
}
