# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit ltprune

DESCRIPTION="Lightweight C++ API library for Lua"
HOMEPAGE="https://github.com/jmmv/lutok"
SRC_URI="https://github.com/jmmv/lutok/releases/download/${P}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-lang/lua:0
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

src_configure() {
	econf --disable-static
}

src_install() {
	default
	prune_libtool_files
}
