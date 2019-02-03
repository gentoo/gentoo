# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Libggi extension for advanced color and palette handling"
HOMEPAGE="https://ibiblio.org/ggicore/packages/libggigcp.html"
SRC_URI="mirror://sourceforge/ggi/${P}.src.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=media-libs/libggi-2.2.2"
DEPEND="${RDEPEND}"

DOCS=( ChangeLog README doc/TODO doc/libggigcp{,-functions,-libraries,-structures}.txt
	doc/colors{,2}.faq )

src_configure(){
	econf --disable-static
}

src_install(){
	default
	find "${D}" -name '*.la' -delete || die
}
