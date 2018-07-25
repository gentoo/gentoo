# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MLEHMANN
DIST_VERSION=1.0
inherit perl-module

DESCRIPTION="simple data types for common serialisation formats"

SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 s390 sparc x86 ~amd64-fbsd ~x64-macos ~x86-solaris"
IUSE=""

RDEPEND="
	dev-perl/common-sense
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
