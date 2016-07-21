# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit eutils toolchain-funcs

DESCRIPTION=" alterMIME is a small program which is used to alter your mime-encoded mailpacks"
SRC_URI="http://www.pldaniels.com/altermime/${P}.tar.gz"
HOMEPAGE="http://pldaniels.com/altermime/"

LICENSE="Sendmail"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.3.10-MIME_headers-overflow.patch \
		"${FILESDIR}"/${P}-respect-flags.patch
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install () {
	dobin altermime
	dodoc CHANGELOG README
}
