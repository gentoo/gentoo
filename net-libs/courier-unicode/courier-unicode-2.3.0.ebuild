# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Unicode library used by the courier mail server"
HOMEPAGE="https://www.courier-mta.org/"
SRC_URI="mirror://sourceforge/courier/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0/7"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

src_configure() {
	econf --disable-static
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
	dodoc AUTHORS ChangeLog README
}
