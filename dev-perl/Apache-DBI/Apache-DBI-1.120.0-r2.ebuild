# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=PHRED
DIST_VERSION=1.12
DIST_EXAMPLES=( "eg/*" )
inherit perl-module

DESCRIPTION="Authentication and Authorization via Perl's DBI"

SLOT="0"
KEYWORDS="alpha amd64 ppc ppc64 x86"
IUSE="test"

RDEPEND=">=dev-perl/Digest-SHA1-2.10.0
	>=virtual/perl-Digest-MD5-2.2
	>=dev-perl/DBI-1.30"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"
src_test() {
	local MODULES=(
		"Apache::DBI ${DIST_VERSION}"
	# Defaults to Apache1 Logic, but supports
	# Apache2 but must run under Apache2
	#	"Apache::AuthDBI ${DIST_VERSION}"
	)
	has_version "dev-perl/DBD-mysql" && MODULES+=( "DBD::mysql" );
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
	local i;
	elog "Install the following dependencies for comprehensive tests:"
	i="$(if has_version "dev-perl/DBD-mysql"; then echo '[I]'; else echo '[ ]'; fi)"
	elog " $i dev-perl/DBD-mysql"
	elog "    - Test apache authentication using mysql as a backing store"
	elog "      (Also requires a running mysql instance)"
	elog "For testing details, see:"
	elog "https://wiki.gentoo.org/wiki/Project:Perl/maint-notes/dev-perl/Apache-DBI"
	perl-module_src_test
}
