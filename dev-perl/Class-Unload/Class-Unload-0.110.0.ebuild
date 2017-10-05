# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=ILMARI
DIST_VERSION=0.11
inherit perl-module

DESCRIPTION="Unload a class"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="dev-perl/Class-Inspector"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-Test-Simple-0.880
		dev-perl/Test-Requires
	)
"
src_test() {
	local i;
	elog "Install the following optional dependencies for comprehensive tests:"
	i="$(if has_version 'dev-perl/Moose'; then echo '[I]'; else echo '[ ]'; fi)"
	elog " $i dev-perl/Moose"
	elog "     - Test unloadability of Moose Classes and Meta-Classes";
	elog
	perl_rm_files t/author-{eol,no-tabs}.t t/author-pod-{coverage,syntax}.t
	perl-module_src_test
}
