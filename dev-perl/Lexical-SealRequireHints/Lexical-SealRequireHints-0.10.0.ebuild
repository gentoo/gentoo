# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=ZEFRAM
DIST_VERSION=0.010
inherit perl-module

DESCRIPTION="Prevent leakage of lexical hints"

SLOT="0"
KEYWORDS="~amd64 ~hppa ~x86"
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
