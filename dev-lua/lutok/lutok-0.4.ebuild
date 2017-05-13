# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit ltprune

DESCRIPTION="Lightweight C++ API library for Lua"
HOMEPAGE="https://github.com/jmmv/lutok"
SRC_URI="https://github.com/jmmv/lutok/releases/download/${P}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm64 ~hppa ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-lang/lua:0
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? (
		dev-libs/atf
		dev-util/kyua
	)
"

src_configure() {
	econf --disable-static
}

src_install() {
	default
	prune_libtool_files
}
