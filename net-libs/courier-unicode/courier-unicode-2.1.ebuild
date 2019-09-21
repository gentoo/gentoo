# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Unicode library used by the courier mail server"
HOMEPAGE="https://www.courier-mta.org/"
SRC_URI="mirror://sourceforge/courier/${P}.tar.bz2"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 sh sparc x86"
IUSE=""

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
	dodoc AUTHORS ChangeLog README
}
