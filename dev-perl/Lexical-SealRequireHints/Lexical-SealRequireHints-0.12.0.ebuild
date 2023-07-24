# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ZEFRAM
DIST_VERSION=0.012
inherit perl-module

DESCRIPTION="Prevent leakage of lexical hints"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

# Note: This module is a no-op at runtime since Perl 5.12
# but is required for dependency resolution
RDEPEND="
	!<dev-perl/B-Hooks-OP-Check-0.190.0
"
BDEPEND="
	${RDEPEND}
	virtual/perl-Exporter
	dev-perl/Module-Build
	test? (
		>=virtual/perl-Test-Simple-0.410.0
	)
"

src_test() {
	perl_rm_files t/pod_{cvg{,_pp},syn}.t
	perl-module_src_test
}
