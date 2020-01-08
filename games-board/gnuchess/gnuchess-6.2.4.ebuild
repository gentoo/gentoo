# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic

DESCRIPTION="Console based chess interface"
HOMEPAGE="https://www.gnu.org/software/chess/chess.html"
SRC_URI="mirror://gnu/chess/${P}.tar.gz"

KEYWORDS="amd64 ~arm arm64 ppc64 x86"
LICENSE="GPL-3"
SLOT="0"
IUSE=""

src_configure() {
	strip-flags # bug #199097
	econf --without-readline # bug 491088
}
