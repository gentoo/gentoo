# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit eutils toolchain-funcs

DESCRIPTION="declick is a dynamic digital declicker for audio sample files"
HOMEPAGE="http://home.snafu.de/wahlm/dl8hbs/declick.html"
SRC_URI="http://home.snafu.de/wahlm/dl8hbs/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""
DEPEND=""

src_prepare() {
	# add $LDFLAGS to link command
	sed -i -e "s:\(-o declick\):\$(LDFLAGS) \1:g" Makefile

	# convert docs to utf-8
	if [ -x "$(type -p iconv)" ]; then
		for X in README; do
			iconv -f LATIN1 -t UTF8 -o "${X}~" "${X}" && mv -f "${X}~" "${X}" || rm -f "${X}~"
		done
	fi
}

src_compile() {
	emake CC="$(tc-getCC)" COPTS="${CFLAGS}" LDFLAGS="${LDFLAGS}" declick || die "emake failed"
}

src_install() {
	dobin declick
	dodoc README
}
