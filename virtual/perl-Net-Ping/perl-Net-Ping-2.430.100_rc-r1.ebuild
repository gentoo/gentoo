# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Virtual for ${PN#perl-}"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="alpha amd64 arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE=""

DEPEND=""
RDEPEND="
	|| ( =dev-lang/perl-5.24.1* =dev-lang/perl-5.22.3* ~perl-core/${PN#perl-}-${PV} )
	dev-lang/perl:=
	!<perl-core/Net-Ping-${PV}
	!>perl-core/Net-Ping-${PV}-r999
"
