# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=PLICEASE
DIST_VERSION=1.23
inherit perl-module

DESCRIPTION="Cross-platform basic tests for scripts"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="test"

RDEPEND="
	dev-perl/Capture-Tiny
	>=virtual/perl-File-Spec-0.800.0
	virtual/perl-IO
	>=dev-perl/Probe-Perl-0.10.0
	>=virtual/perl-Test-Simple-1.302.15
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=dev-perl/Test2-Suite-0.0.72
	)
"
