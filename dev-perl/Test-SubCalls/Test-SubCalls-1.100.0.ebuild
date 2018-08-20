# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=ETHER
DIST_VERSION=1.10
inherit perl-module

DESCRIPTION="Track the number of times subs are called"

SLOT="0"
KEYWORDS="alpha amd64 ~arm ppc ~ppc64 ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris"
IUSE=""

DEPEND="
	virtual/perl-Exporter
	>=virtual/perl-File-Spec-0.800.0
	>=dev-perl/Hook-LexWrap-0.200.0
	>=virtual/perl-Test-Simple-0.420.0
"
RDEPEND="${DEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
