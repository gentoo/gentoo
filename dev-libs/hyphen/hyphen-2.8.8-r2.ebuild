# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="ALTLinux hyphenation library"
HOMEPAGE="https://hunspell.github.io/"
SRC_URI="https://downloads.sourceforge.net/hunspell/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1 MPL-1.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv ~sparc x86"
IUSE="static-libs"

DEPEND="app-text/hunspell"
RDEPEND="${DEPEND}"
BDEPEND="dev-lang/perl"

DOCS=( AUTHORS ChangeLog NEWS README{,.nonstandard,.hyphen,.compound} THANKS TODO )

PATCHES=(
	"${FILESDIR}"/${P}-mawk.patch
)

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default

	docinto pdf
	dodoc doc/*.pdf

	rm -r "${ED}"/usr/share/hyphen || die
	# bug #775587
	rm -f "${ED}/usr/$(get_libdir)/libhyphen.la" || die
}
