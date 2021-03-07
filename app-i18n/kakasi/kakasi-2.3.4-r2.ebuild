# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit toolchain-funcs

DESCRIPTION="Converts Japanese text between kanji, kana, and romaji"
HOMEPAGE="http://kakasi.namazu.org/"
SRC_URI="http://${PN}.namazu.org/stable/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris"
IUSE="static-libs"

DOCS=( AUTHORS ChangeLog {,O}NEWS README{,-ja} THANKS TODO doc/{ChangeLog.lib,JISYO,README.lib} )

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	default
	einstalldocs
	find "${ED}" -name '*.la' -delete || die
	use static-libs || find "${ED}" -name '*.a' -delete || die

	iconv -f EUC-JP -t UTF-8 doc/${PN}.1 > doc/${PN}.ja.1
	doman doc/${PN}.ja.1
}
