# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=RURBAN
DIST_VERSION=1.60
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="Interface for creation of Perl Filters"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~m68k ~mips ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

BDEPEND="
	virtual/perl-ExtUtils-MakeMaker
"
PERL_RM_FILES=(
	t/z_kwalitee.t
	t/z_manifest.t
	t/z_meta.t
	t/z_perl_minimum_version.t
	t/z_pod-coverage.t
	t/z_pod.t
)
src_compile() {
	mymake=(
		"OPTIMIZE=${CFLAGS}"
	)
	perl-module_src_compile
}
