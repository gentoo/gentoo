# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit gnustep-2

DESCRIPTION="Addresses is a Apple Addressbook work alike (standalone and for GNUMail)"
HOMEPAGE="http://gap.nongnu.org/addresses/"
SRC_URI="https://savannah.nongnu.org/download/gap/${P/a/A}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~x86-fbsd"
IUSE=""

S=${WORKDIR}/${P/a/A}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.4.7-as-needed.patch
}
