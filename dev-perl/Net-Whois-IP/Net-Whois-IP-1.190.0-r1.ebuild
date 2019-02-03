# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_VERSION=${PV%0.0}
DIST_AUTHOR=BSCHMITZ
inherit perl-module

DESCRIPTION="Perl extension for looking up the whois information for ip addresses"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
PERL_RM_FILES=(
	"test.pl" # gets installed otherwise :(
)
RDEPEND="
	dev-perl/Regexp-IPv6
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
src_test() {
	local MODULES=(
		"Net::Whois::IP ${DIST_VERSION}"
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
	# # All tests defined require networking
	#  and all fail.
	# https://rt.cpan.org/Public/Bug/Display.html?id=110961
	# local my_test_control
	# my_test_control=${DIST_TEST_OVERRIDE:-${DIST_TEST:-do parallel}}
	# if ! has network ${my_test_control} ; then
	#	perl_rm_files "t/test1.t" "t/testx.t"
	# fi
	# perl-module_src_test
}
