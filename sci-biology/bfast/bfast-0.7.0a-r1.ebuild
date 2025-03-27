# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Blat-like Fast Accurate Search Tool"
HOMEPAGE="https://sourceforge.net/projects/bfast/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="test" # tests broken, upstream unresponsive

RDEPEND="dev-perl/XML-Simple"

PATCHES=(
	"${FILESDIR}"/${P}-autotools.patch
	"${FILESDIR}"/${P}-test-sourcing.patch
	"${FILESDIR}"/${P}-C99-inline.patch
	"${FILESDIR}"/${P}-gzeof.patch
)

src_prepare() {
	default
	eautoreconf
}
