# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools toolchain-funcs

DESCRIPTION="Advanced Internet Whois client capable of recursive queries"
HOMEPAGE="https://github.com/jonasob/jwhois/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="idn nls"

RDEPEND="idn? ( net-dns/libidn )"
DEPEND="${RDEPEND}"

PATCHES=(
	# bug 208875
	"${FILESDIR}"/${P}-connect-logic.patch
	"${FILESDIR}"/${P}-avoid-implicit-declarations.patch
	"${FILESDIR}"/${P}-add-timeout_init-prototype.patch
)

src_configure() {
	econf \
		--localstatedir="${EPREFIX}"/var/cache \
		--without-cache \
		$(use_enable nls) \
		$(use_with idn libidn)
	eautoreconf
}

src_compile(){
	emake AR="$(tc-getAR)"
}
