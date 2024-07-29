# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_VERSION=2.28
DIST_AUTHOR=RURBAN
DIST_TEST="verbose do"
inherit perl-module

DESCRIPTION="Interface to Bzip2 compression library"

# perl5.x or newer license
# https://bugs.gentoo.org/718946#c7
LICENSE="|| ( Artistic GPL-1+ ) BZIP2"
SLOT="0"
KEYWORDS="amd64 ~ia64 ~mips sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

RDEPEND="
	app-arch/bzip2
	virtual/perl-Carp
	virtual/perl-File-Spec
"
BDEPEND="
	${RDEPEND}
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

src_test() {
	# Compares byte-for-byte against a reference bzip2'd file, so
	# fails with e.g. lbzip2.
	if ! has_version -b "app-alternatives/bzip2[reference]" ; then
		perl_rm_files t/02{4,5,6}-compfile.t
	fi

	perl-module_src_test
}
