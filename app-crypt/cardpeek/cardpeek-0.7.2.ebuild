# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xdg

DESCRIPTION="Tool to read the contents of smartcards"
HOMEPAGE="http://pannetrat.com/Cardpeek"
SRC_URI="https://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="libressl"

RDEPEND=">=x11-libs/gtk+-2.12:2
	sys-apps/pcsc-lite
	dev-lang/lua:0
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"
