# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/cardpeek/cardpeek-0.8.2.ebuild,v 1.1 2014/03/25 13:26:24 alonbl Exp $

EAPI=5

inherit eutils

DESCRIPTION="Tool to read the contents of smartcards"
HOMEPAGE="http://pannetrat.com/Cardpeek"
SRC_URI="http://downloads.pannetrat.com/install/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="sys-apps/pcsc-lite
	=dev-lang/lua-5.2*
	x11-libs/gtk+:3
	net-misc/curl
	dev-libs/openssl"

DEPEND="${RDEPEND}
	virtual/pkgconfig"
