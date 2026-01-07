# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

DESCRIPTION="Converts Japanese text between kanji, kana, and romaji"
HOMEPAGE="http://kakasi.namazu.org/"
SRC_URI="http://kakasi.namazu.org/stable/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 ppc ppc64 ~sparc x86"
IUSE="l10n_ja"

BDEPEND="sys-devel/gettext"

PATCHES=(
	"${FILESDIR}"/${PN}-2.3.6-configure-clang16.patch
)

src_prepare() {
	default

	eautoreconf # for clang16.patch

	append-cflags -std=gnu17 # gcc15 (bug #944244)
}

src_install() {
	default
	dodoc AUTHORS ChangeLog {,O}NEWS README{,-ja} THANKS TODO
	dodoc doc/{ChangeLog.lib,JISYO,README.lib}

	if use l10n_ja; then
		iconv -f EUC-JP -t UTF-8 man/${PN}.1.ja > man/${PN}.ja.1
		doman man/${PN}.ja.1
	fi

	find "${ED}" -type f -name '*.la' -delete || die
}
