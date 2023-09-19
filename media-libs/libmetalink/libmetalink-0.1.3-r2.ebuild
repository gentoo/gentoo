# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Library for handling Metalink files"
HOMEPAGE="https://launchpad.net/libmetalink"
SRC_URI="https://launchpad.net/${PN}/trunk/${P}/+download/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv sparc x86"
IUSE="expat static-libs test xml"

RDEPEND="expat? ( >=dev-libs/expat-2.1.0-r3 )
	 xml? ( >=dev-libs/libxml2-2.9.1-r4 )"
DEPEND="${RDEPEND}
	test? ( >=dev-util/cunit-2.1_p2 )"

REQUIRED_USE="^^ ( expat xml )"
RESTRICT="!test? ( test )"

src_configure() {
	local myeconfargs=(
		$(use_with expat libexpat)
		$(use_with xml libxml2)
		$(use_enable static-libs static)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default

	find "${ED}" -type f -name "*.la" -delete || die
}
