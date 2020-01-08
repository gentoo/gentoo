# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=VIPUL
DIST_VERSION=1.52
inherit perl-module

DESCRIPTION="Cryptographically Secure, True Random Number Generator"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE=""

RDEPEND="
	>=dev-perl/Math-Pari-2.1.804
	>=dev-perl/Class-Loader-2.0.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
