# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=PLICEASE
DIST_VERSION=1.18
inherit perl-module

DESCRIPTION="Cross-platform basic tests for scripts"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

RDEPEND="
	>=virtual/perl-File-Spec-0.800.0
	>=dev-perl/Probe-Perl-0.10.0
	>=dev-perl/IPC-Run3-0.34.0
	>=virtual/perl-Test-Simple-0.960.0"
# NB: Needs Test::Builder::Tester 1.02 =>
#     which is <= Test-Simple-0.96
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
