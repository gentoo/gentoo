# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=ZEFRAM
DIST_VERSION=0.011
inherit perl-module

DESCRIPTION="Prevent leakage of lexical hints"

SLOT="0"
KEYWORDS="amd64 hppa ppc x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"

# Note: This module is a no-op at runtime since Perl 5.12
# but is required for dependency resolution
RDEPEND="
	!<dev-perl/B-Hooks-OP-Check-0.190.0
"
DEPEND="${RDEPEND}
	dev-perl/Module-Build
	test? (
		>=virtual/perl-Test-Simple-0.410.0
	)
"
src_test() {
	perl_rm_files t/pod_{cvg{,_pp},syn}.t
	perl-module_src_test
}
