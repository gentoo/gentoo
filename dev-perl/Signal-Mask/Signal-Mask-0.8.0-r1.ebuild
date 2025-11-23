# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=LEONT
DIST_VERSION=0.008

inherit perl-module

DESCRIPTION="Signal masks made easy"

SLOT="0"
KEYWORDS="amd64 ~riscv ~x86"
IUSE="minimal"

RDEPEND="
	!minimal? ( dev-perl/Thread-SigMask )
	virtual/perl-Carp
	dev-perl/IPC-Signal
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
	test? (
		virtual/perl-File-Spec
		virtual/perl-IO
		virtual/perl-Test-Simple
	)
"

PERL_RM_FILES=( t/release-pod-syntax.t )
