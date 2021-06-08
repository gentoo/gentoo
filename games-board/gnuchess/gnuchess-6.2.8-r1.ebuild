# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Console based chess interface"
HOMEPAGE="https://www.gnu.org/software/chess/chess.html"
SRC_URI="mirror://gnu/chess/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ppc64 x86"

PATCHES=(
	"${FILESDIR}"/${P}-cve-2021-30184.patch  # bug 780855
)

src_configure() {
	# bug #491088
	econf --without-readline
}
