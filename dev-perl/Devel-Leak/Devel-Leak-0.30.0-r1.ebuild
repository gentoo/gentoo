# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=NI-S
DIST_VERSION=0.03
inherit perl-module

DESCRIPTION="Utility for looking for perl objects that are not reclaimed"

SLOT="0"
KEYWORDS="~alpha amd64 arm ~ia64 ~mips ppc ppc64 sparc x86"

BDEPEND="virtual/perl-ExtUtils-MakeMaker"
src_compile() {
	mymake=(
		"OPTIMIZE=${CFLAGS}"
	)
	perl-module_src_compile
}
