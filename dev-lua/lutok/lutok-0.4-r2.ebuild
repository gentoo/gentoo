# Copyright 2017-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Lightweight C++ API library for Lua"
HOMEPAGE="https://github.com/jmmv/lutok"
SRC_URI="https://github.com/jmmv/lutok/releases/download/${P}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="static-libs test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-lang/lua:0[static-libs(+)?]
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? (
		dev-libs/atf
		dev-util/kyua
	)
"

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	rm -rf "${ED}"/usr/tests || die
	find "${ED}" -name '*.la' -type f -delete || die
}
