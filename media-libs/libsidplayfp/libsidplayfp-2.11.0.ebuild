# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Library for the sidplay2 fork with resid-fp"
HOMEPAGE="https://sourceforge.net/projects/sidplay-residfp/"
SRC_URI="https://downloads.sourceforge.net/sidplay-residfp/${PN}/$(ver_cut 1-2)/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0/6"
KEYWORDS="amd64 ~hppa ~riscv x86"
IUSE="static-libs test"
RESTRICT="!test? ( test )"

BDEPEND="test? ( dev-libs/unittest++ )"

src_prepare() {
	default
	# fix automagic. warning: modifying .ac triggers maintainer mode.
	sed -i -e 's:doxygen:dIsAbLe&:' configure || die
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		$(use_enable test tests)
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
