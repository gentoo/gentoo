# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-2 )

inherit lua-single

DESCRIPTION="Tool to read the contents of smartcards"
HOMEPAGE="http://pannetrat.com/Cardpeek"
SRC_URI="http://downloads.pannetrat.com/install/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="libressl"

REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="${LUA_DEPS}
	sys-apps/pcsc-lite
	x11-libs/gtk+:3
	net-misc/curl
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"
