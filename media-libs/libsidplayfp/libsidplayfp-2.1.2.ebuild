# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic

DESCRIPTION="Library for the sidplay2 fork with resid-fp"
HOMEPAGE="https://sourceforge.net/projects/sidplay-residfp/"
SRC_URI="mirror://sourceforge/sidplay-residfp/${PN}/$(ver_cut 1-2)/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0/6"
KEYWORDS="amd64 ~hppa ~x86"
IUSE="cpu_flags_x86_mmx static-libs"

src_prepare() {
	default
	# fix automagic. warning: modifying .ac triggers maintainer mode.
	sed -i -e 's:doxygen:dIsAbLe&:' configure || die
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		$(use_enable cpu_flags_x86_mmx mmx)
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
