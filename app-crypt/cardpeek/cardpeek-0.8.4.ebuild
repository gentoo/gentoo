# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

DESCRIPTION="Tool to read the contents of smartcards"
HOMEPAGE="http://pannetrat.com/Cardpeek"
SRC_URI="http://downloads.pannetrat.com/install/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="libressl"

RDEPEND="sys-apps/pcsc-lite
	dev-lang/lua:5.2
	x11-libs/gtk+:3
	net-misc/curl
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )"

DEPEND="${RDEPEND}
	virtual/pkgconfig"
