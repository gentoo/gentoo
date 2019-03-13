# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=EDD
DIST_VERSION=0.25
inherit perl-module

DESCRIPTION="Get stock quotes from Yahoo! Finance"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="
	dev-perl/libwww-perl
	virtual/perl-MIME-Base64
	>=dev-perl/HTML-Parser-2.200.0
	>=virtual/perl-Text-ParseWords-3.100.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
src_test() {
	local MODULES=(
		"Finance::YahooQuote ${DIST_VERSION}"
	)
	local failed=()
	for dep in "${MODULES[@]}"; do
		ebegin "Compile testing ${dep}"
			perl -Mblib="${S}" -M"${dep} ()" -e1
		eend $? || failed+=( "$dep" )
	done
	if [[ ${failed[@]} ]]; then
		echo
		eerror "One or more modules failed compile:";
		for dep in "${failed[@]}"; do
			eerror "  ${dep}"
		done
		die "Failing due to module compilation errors";
	fi
	if ! has network ${DIST_TEST_OVERRIDE:-${DIST_TEST:-do parallel}}; then
		ewarn "Comprehensive tests require network access. For details, see:"
		ewarn "https://wiki.gentoo.org/wiki/Project:Perl/maint-notes/dev-perl/Finance-YahooQuote"
		perl_rm_files "t/04custom.t" "t/02simple.t" "t/03extended.t" "t/05test.t";
	fi
	perl-module_src_test
}
