# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit rakudo

DESCRIPTION="An asynchronous TAP framework written in Raku"
HOMEPAGE="https://raku.land/cpan:LEONT/TAP
	https://github.com/Raku/tap-harness6"
SRC_URI="mirror://cpan/authors/id//L/LE/LEONT/Perl6/${P}.tar.gz"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64"
DOCS=( "README.md" "Changes" )

src_test() {
	raku -I lib t/source-file.t || die
	raku -I lib t/string.t || die
}
