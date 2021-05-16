# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=GAAS
DIST_VERSION=1.06
inherit perl-module

DESCRIPTION="Dump arbitrary data structures as XML"

SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ~mips ppc ppc64 sparc x86 ~sparc-solaris"
IUSE=""

RDEPEND="
	>=dev-perl/Array-RefElem-0.10.0
	>=virtual/perl-MIME-Base64-2
	>=dev-perl/XML-Parser-2
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
