# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="A free VHDL simulator"
SRC_URI="mirror://sourceforge/qucs/${P}.tar.gz"
HOMEPAGE="http://freehdl.seul.org/"
LICENSE="GPL-2"

SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND=">=dev-scheme/guile-2.0:*"
DEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${PN}-0.0.8-fix-c++14.patch"
	"${FILESDIR}/${PN}-0.0.8-qa.patch"
)

src_configure() {
	econf --disable-static
}

src_install() {
	default

	# package provides .pc files
	find "${D}" -name '*.la' -delete || die
}
