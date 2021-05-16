# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Advanced Internet Whois client capable of recursive queries"
HOMEPAGE="https://www.gnu.org/software/jwhois/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ~m68k ~mips ppc ppc64 ~s390 sparc x86"
IUSE="idn nls"

RDEPEND="idn? ( net-dns/libidn )"
DEPEND="${RDEPEND}"

PATCHES=(
	# bug 208875
	"${FILESDIR}"/${P}-connect-logic.patch
)

src_configure() {
	econf \
		--localstatedir="${EPREFIX}"/var/cache \
		--without-cache \
		$(use_enable nls) \
		$(use_with idn libidn)
}
