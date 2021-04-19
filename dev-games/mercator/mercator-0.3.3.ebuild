# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="WorldForge library primarily aimed at terrain"
HOMEPAGE="https://www.worldforge.org/index.php/components/mercator/"
SRC_URI="mirror://sourceforge/worldforge/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc"

RDEPEND=">=dev-games/wfmath-1"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"

src_compile() {
	default
	use doc && emake docs
}

src_install() {
	default
	use doc && dodoc -r doc/html

	find "${ED}" -name '*.la' -delete || die
}
