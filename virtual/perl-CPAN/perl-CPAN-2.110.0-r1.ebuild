# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Virtual for ${PN#perl-}"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="alpha amd64 arm ~hppa ia64 ~mips ppc ppc64 sparc x86"
IUSE=""

DEPEND=""
RDEPEND="
	|| ( =dev-lang/perl-5.24* =dev-lang/perl-5.22* )
	!<perl-core/${PN#perl-}-${PV}
	!>perl-core/${PN#perl-}-${PV}-r999
"

# special case: Perl 5.22 version does not correspond to any separate release...
