# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="A compiler for the Perl 6 programming language"
HOMEPAGE="http://rakudo.org"

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/rakudo/${PN}.git"
	inherit git-r3
else
	SRC_URI="${HOMEPAGE}/downloads/${PN}/${P}.tar.gz"
fi

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# TODO: add USE="javascript" once that's usable in nqp
IUSE="test"

RDEPEND="=dev-lang/nqp-${PV}:=[moar]"
DEPEND="${RDEPEND}
	>=dev-lang/perl-5.10"

src_configure() {
	perl Configure.pl --prefix=/usr --sysroot=/usr --backends=moar
}

src_test() {
	export RAKUDO_PRECOMP_PREFIX=$(mktemp -d)
	default
}
