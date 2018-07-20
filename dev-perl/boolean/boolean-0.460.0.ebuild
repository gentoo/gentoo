# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=INGY
DIST_VERSION=0.46
inherit perl-module

DESCRIPTION="Boolean support for Perl"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
src_test() {
	elog "Install the following dependencies for comprehensive tests:"
	local i="$(if has_version 'dev-perl/JSON-MaybeXS'; then echo '[I]'; else echo '[ ]'; fi)"
	elog " $i dev-perl/JSON-MaybeXS - Interop testing with native C JSON Decoders";
	echo
	perl_rm_files t/author-pod-syntax.t
	perl-module_src_test
}
