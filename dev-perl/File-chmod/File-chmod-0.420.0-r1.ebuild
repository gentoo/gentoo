# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=XENO
DIST_VERSION=0.42
inherit perl-module

DESCRIPTION="Implements symbolic and ls chmod modes"

SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ppc sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Exporter
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Spec
		virtual/perl-File-Temp
		virtual/perl-IO
		virtual/perl-Test-Simple
		virtual/perl-autodie
	)
"
PERL_RM_FILES=(
	t/author-critic.t
	t/author-eol.t
	t/release-cpan-changes.t
	t/release-dist-manifest.t
	t/release-meta-json.t
	t/release-minimum-version.t
	t/release-pod-coverage.t
	t/release-pod-syntax.t
	t/release-portability.t
	t/release-test-version.t
	t/release-unused-vars.t
)
