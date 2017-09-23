# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Virtual for ${PN#perl-}"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~x86-macos"

RDEPEND="
	|| ( =dev-lang/perl-5.24.3* =dev-lang/perl-5.24.2* =dev-lang/perl-5.24.1* ~perl-core/${PN#perl-}-${PV} )
	dev-lang/perl:=
	!<perl-core/Net-Ping-${PV}
	!>perl-core/Net-Ping-${PV}-r999
"
