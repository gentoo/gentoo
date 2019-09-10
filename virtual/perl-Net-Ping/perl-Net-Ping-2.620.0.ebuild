# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Virtual for ${PN#perl-}"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 ~hppa ia64 m68k ppc ppc64 s390 sh sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~x86-macos"

RDEPEND="
	|| ( =dev-lang/perl-5.28* ~perl-core/${PN#perl-}-${PV} )
	dev-lang/perl:=
	!<perl-core/Net-Ping-${PV}
	!>perl-core/Net-Ping-${PV}-r999
"
