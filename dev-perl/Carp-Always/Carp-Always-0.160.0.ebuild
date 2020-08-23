# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=FERREIRA
DIST_VERSION=0.16
inherit perl-module

DESCRIPTION="Warns and dies noisily with stack backtraces"

SLOT="0"
KEYWORDS="~amd64 ~arm arm64 ~ppc ~ppc64 ~x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Carp
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test-Simple
		dev-perl/Test-Base
	)
"
PERL_RM_FILES=(
	"t/098pod-coverage.t"
	"t/099pod.t"
)
