# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Implements Wake On LAN (Magic Paket) functionality in a small program"
HOMEPAGE="http://ahh.sourceforge.net/wol/"
SRC_URI="mirror://sourceforge/ahh/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ~ia64 ppc ppc64 ~sparc x86"
IUSE="nls"

PATCHES=( "${FILESDIR}/${P}-musl.patch" )

src_configure() {
	local myeconfargs=(
		--disable-rpath
		$(use_enable nls)
	)

	econf ${myeconfargs[@]}
}

src_compile() {
	emake AR="$(tc-getAR)"
}
