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
IUSE="java +moar test"
REQUIRED_USE="|| ( java moar )"

RDEPEND="=dev-lang/nqp-${PV}*:=[moar?,java?]"
DEPEND="${RDEPEND}
	>=dev-lang/perl-5.10"

PATCHES=(${FILESDIR}/${PV})

src_configure() {
	local BACKENDS

	# The order of this list determines which gets installed as "perl6"
	use moar && BACKENDS+="moar,"
	use java && BACKENDS+="jvm,"
	#use javascript && BACKENDS+="js,"

	perl Configure.pl --prefix=/usr --sysroot=/usr --backends=$BACKENDS
}

src_test() {
	export RAKUDO_PRECOMP_PREFIX=$(mktemp -d)
	default
}
