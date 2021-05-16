# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Dynamic digital declicker for audio sample files"
HOMEPAGE="http://home.snafu.de/wahlm/dl8hbs/declick.html"
SRC_URI="http://home.snafu.de/wahlm/dl8hbs/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_prepare() {
	default
	# add $LDFLAGS to link command
	sed -i -e "s:\(-o declick\):\$(LDFLAGS) \1:g" Makefile || die

	# convert docs to utf-8
	if [ -x "$(type -p iconv)" ]; then
		for X in README; do
			iconv -f LATIN1 -t UTF8 -o "${X}~" "${X}" && mv -f "${X}~" "${X}" || rm -f "${X}~" || die
		done
	fi
}

src_compile() {
	emake CC="$(tc-getCC)" COPTS="${CFLAGS}" LDFLAGS="${LDFLAGS}" declick
}

src_install() {
	dobin declick
	dodoc README
}
