# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="GNU Spread Sheet Widget"
HOMEPAGE="https://www.gnu.org/software/ssw/"
SRC_URI="mirror://gnu-alpha/ssw/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="x11-libs/gtk+:3"
RDEPEND="${DEPEND}"

src_configure() {
	econf --disable-static
}

src_install() {
	default

	# no static archives
	find "${ED}" -name '*.la' -delete || die
}
