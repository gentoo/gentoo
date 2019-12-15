# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Implements Wake On LAN (Magic Paket) functionality in a small program"
HOMEPAGE="http://ahh.sourceforge.net/wol/"
SRC_URI="mirror://sourceforge/ahh/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 arm ppc ppc64 x86"
IUSE="nls"

src_configure() {
	local myeconfargs=(
		--disable-rpath
		$(use_enable nls)
	)

	econf ${myeconfargs[@]}
}
