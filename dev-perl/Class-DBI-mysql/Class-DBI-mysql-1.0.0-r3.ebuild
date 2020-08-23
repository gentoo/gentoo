# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=TMTM
DIST_VERSION=1.00
inherit perl-module

DESCRIPTION="Extensions to Class::DBI for MySQL"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-perl/Class-DBI-0.940.0
	dev-perl/DBD-mysql
"
BDEPEND="${RDEPEND}
	test? (
		>=virtual/perl-Test-Simple-0.450.0
	)
"
PERL_RM_FILES=(
	t/pod-coverage.t
	t/pod.t
)
src_test() {
	local MODULES=(
		"Class::DBI::mysql ${DIST_VERSION}"
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
	if [[ -n "${DBD_MYSQL_DBNAME}" ]]; then
		perl-module_src_test
	else
		ewarn "Functional testing of this package requires user intervention."
		ewarn "For details, see:"
		ewarn "https://wiki.gentoo.org/Project:Perl/maint-notes/dev-perl/Class-DBI-mysql"
	fi
}
