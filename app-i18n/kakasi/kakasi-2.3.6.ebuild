# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

DESCRIPTION="Converts Japanese text between kanji, kana, and romaji"
HOMEPAGE="http://kakasi.namazu.org/"
SRC_URI="http://${PN}.namazu.org/stable/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ~ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris"
IUSE="l10n_ja static-libs"

DOCS=( AUTHORS ChangeLog {,O}NEWS README{,-ja} THANKS TODO doc/{ChangeLog.lib,JISYO,README.lib} )

src_install() {
	default
	einstalldocs
	find "${ED}" -name '*.la' -delete || die
	use static-libs || find "${ED}" -name '*.a' -delete || die

	if use l10n_ja; then
		iconv -f EUC-JP -t UTF-8 man/${PN}.1.ja > man/${PN}.ja.1
		doman man/${PN}.ja.1
	fi
}
