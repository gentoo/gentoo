# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Virtual for ${PN#perl-}"
HOMEPAGE=""
SRC_URI=""

SLOT="0"
KEYWORDS="alpha amd64 arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc x86 ~amd64-fbsd"
IUSE=""

RDEPEND="
	|| ( =dev-lang/perl-5.24.1* =dev-lang/perl-5.22.3* ~perl-core/${PN#perl-}-${PV} )
	dev-lang/perl:=
	!<perl-core/Locale-Maketext-${PV}
	!>perl-core/Locale-Maketext-${PV}-r999
"
