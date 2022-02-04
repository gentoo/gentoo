# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=BRIANSKI
DIST_VERSION=0.11
inherit perl-module

DESCRIPTION="Perl access to fsync() and sync() function calls"

SLOT="0"
KEYWORDS="amd64 ~ia64 ppc ppc64 sparc x86"

BDEPEND="
	virtual/perl-ExtUtils-MakeMaker
"

src_compile() {
	mymake=(
		"OPTIMIZE=${CFLAGS}"
	)
	perl-module_src_compile
}
