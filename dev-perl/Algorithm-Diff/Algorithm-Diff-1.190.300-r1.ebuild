# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=TYEMQ
DIST_VERSION=1.1903
DIST_EXAMPLES="examples/*"
inherit perl-module

DESCRIPTION="Compute intelligent differences between two files / lists"

SLOT="0"
KEYWORDS="~alpha ~amd64 arm arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

src_prepare() {
	local file
	mkdir -p examples/ || die "can't make examples/"
	for file in cdiff diffnew diff htmldiff; do
		mv -f ${file}.pl examples/${file}.pl || die "Can't move ${file.pl} to examples/"
		sed -i "s/^${file}.pl/examples\/${file}.pl/" MANIFEST || die "Can't fix MANIFEST"
	done
	perl-module_src_prepare
}
BDEPEND="virtual/perl-ExtUtils-MakeMaker"
