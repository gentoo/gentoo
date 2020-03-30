# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit toolchain-funcs

DESCRIPTION="Converts Japanese text between kanji, kana, and romaji"
HOMEPAGE="http://kakasi.namazu.org/"
SRC_URI="http://${PN}.namazu.org/stable/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris"
IUSE=""

DOCS=( AUTHORS ChangeLog {,O}NEWS README{,-ja} THANKS TODO doc/{ChangeLog.lib,JISYO,README.lib} )

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	default
	einstalldocs

	iconv -f EUC-JP -t UTF-8 doc/${PN}.1 > doc/${PN}.ja.1
	doman doc/${PN}.ja.1
}
