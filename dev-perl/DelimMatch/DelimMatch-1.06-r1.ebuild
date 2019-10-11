# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit perl-module
MY_P=${P}a

DESCRIPTION="A Perl 5 module for locating delimited substrings with proper nesting"
SRC_URI="mirror://cpan/authors/id/N/NW/NWALSH/${MY_P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~nwalsh/"

LICENSE="|| ( Artistic GPL-1+ )"
SLOT="0"
KEYWORDS="alpha amd64 ~hppa ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris"
IUSE=""

SRC_TEST="do"
