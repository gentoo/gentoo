# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/ckpass/ckpass-0.2.ebuild,v 1.2 2015/01/26 09:46:13 jer Exp $

EAPI=5
inherit autotools eutils

DESCRIPTION="An ncurses based password database client that is compatible with KeePass 1.x format databases"
HOMEPAGE="http://ckpass.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=">=dev-libs/libkpass-6"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-tinfo.patch
	eautoreconf
}

DOCS=( AUTHORS )
