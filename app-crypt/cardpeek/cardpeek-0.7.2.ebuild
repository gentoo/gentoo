# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

DESCRIPTION="Tool to read the contents of smartcards"
HOMEPAGE="https://code.google.com/p/cardpeek/"
SRC_URI="https://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="libressl"

RDEPEND=">=x11-libs/gtk+-2.12:2
	sys-apps/pcsc-lite
	=dev-lang/lua-5.1*
	dev-libs/openssl
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )"

DEPEND="${RDEPEND}
	virtual/pkgconfig"
