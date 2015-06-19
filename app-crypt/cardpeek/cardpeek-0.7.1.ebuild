# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/cardpeek/cardpeek-0.7.1.ebuild,v 1.1 2012/11/11 03:38:25 flameeyes Exp $

EAPI=5

inherit eutils

DESCRIPTION="Tool to read the contents of smartcards"
HOMEPAGE="https://code.google.com/p/cardpeek/"
SRC_URI="https://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.12:2
	sys-apps/pcsc-lite
	=dev-lang/lua-5.1*
	dev-libs/openssl"

DEPEND="${RDEPEND}
	virtual/pkgconfig"
