# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_VERSION=2.28
DIST_AUTHOR=RURBAN
inherit perl-module

DESCRIPTION="Interface to Bzip2 compression library"
# perl5.x or newer license
# https://bugs.gentoo.org/718946#c7
LICENSE="|| ( Artistic GPL-1+ ) BZIP2"
SLOT="0"
KEYWORDS="amd64 ~ia64 ~mips sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	app-arch/bzip2
	virtual/perl-Carp
	virtual/perl-File-Spec
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"
PERL_RM_FILES=(
	t/900_kwalitee.t
	t/900_leaktrace.t
	t/900_meta.t
	t/900_perl_minimum_version.t
	t/900_pod-coverage.t
	t/900_pod.t
)
src_compile() {
	mymake=(
		"OPTIMIZE=${CFLAGS}"
	)
	perl-module_src_compile
}
