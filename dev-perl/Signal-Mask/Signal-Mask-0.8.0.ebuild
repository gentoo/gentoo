# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=LEONT
DIST_VERSION=0.008

inherit perl-module

DESCRIPTION="Signal masks made easy"

SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="minimal test"
RESTRICT="!test? ( test )"

RDEPEND="
	!minimal? ( dev-perl/Thread-SigMask )
	virtual/perl-Carp
	dev-perl/IPC-Signal
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
	test? (
		virtual/perl-File-Spec
		virtual/perl-IO
		virtual/perl-Test-Simple
	)
"
src_test() {
	perl_rm_files "t/release-pod-syntax.t"
	perl-module_src_test
}
