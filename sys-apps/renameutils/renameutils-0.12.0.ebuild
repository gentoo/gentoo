# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Use your favorite text editor to rename files"
HOMEPAGE="http://www.nongnu.org/renameutils/"
SRC_URI="https://savannah.nongnu.org/download/renameutils/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm64 ppc x86"
IUSE="nls"

DEPEND="sys-libs/readline:="
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-typo.patch
	"${FILESDIR}"/${P}-autopoint.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf $(use_enable nls)
}
