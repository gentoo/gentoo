# Copyright 1999-2015 Gentoo Foundation
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
IUSE=""

RDEPEND="sys-apps/pcsc-lite
	dev-lang/lua:5.2
	x11-libs/gtk+:3
	net-misc/curl
	dev-libs/openssl:*"

DEPEND="${RDEPEND}
	virtual/pkgconfig"
