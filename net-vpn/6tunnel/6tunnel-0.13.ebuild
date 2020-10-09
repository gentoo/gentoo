# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="TCP proxy for applications that don't speak IPv6"
HOMEPAGE="https://github.com/wojtekka/6tunnel"
SRC_URI="https://github.com/wojtekka/6tunnel/releases/download/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~s390 x86"

PATCHES=(
	"${FILESDIR}/${P}-test.patch"
)
